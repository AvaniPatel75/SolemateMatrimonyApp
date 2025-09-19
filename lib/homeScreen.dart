// File: homeScreen.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:login_screen/changePasswordScreen.dart';
import 'package:login_screen/database.dart';
import 'package:login_screen/editProfile.dart';
import 'package:login_screen/logonScreen.dart';
import 'package:login_screen/signupScreen.dart';
import 'package:login_screen/userAccountScreen.dart';
import 'package:login_screen/userProfilePage.dart';

class Homescreen extends StatefulWidget {
  final List<Map<String, dynamic>> users;
  final Map<String, dynamic> profileData;
  final VoidCallback onFavouriteRemoved;
  const Homescreen({
    Key? key,
    required this.users,
    required this.profileData,
    required this.onFavouriteRemoved
  }) : super(key: key);

  @override
  State<Homescreen> createState() => HomescreenState();
}

class HomescreenState extends State<Homescreen> {
  List<bool> isLiked = [];
  MyDataBase dbHelper = MyDataBase.instance;

  @override
  void initState() {
    super.initState();
    _loadLikedStatus();
    fetchAllProfiles();
  }

  // Asynchronously load the liked status from the database
  Future<void> _loadLikedStatus() async {
    final favorites = await dbHelper.getAllFavourites();
    final favoriteUserEmails = favorites.map((user) => user['Email']).toSet();
    isLiked = List.filled(favorites.length, false);

    setState(() {
      isLiked = widget.users.map((user) {
        return favoriteUserEmails.contains(user['Email']?.toString() ?? '');
      }).toList();
    });
  }

  Future<void> _toggleFavourite(int index) async {
    final userDetail = widget.users[index];
    final userEmail = userDetail['Email']?.toString() ?? '';

    if (isLiked[index]) {
      final deletedRows = await dbHelper.removeFromFavouriteByEmail(userEmail);
      if (deletedRows > 0) {
        setState(() {
          isLiked[index] = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Removed from favourites')),
        );
        widget.onFavouriteRemoved(); // Call the callback to notify the parent
      }
    }  else {
      // Add to favourites
      final addedId = await dbHelper.addToFavourite(userDetail);
      if (addedId > 0) {
        setState(() {
          isLiked[index] = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Added to favourites')),
        );
        widget.onFavouriteRemoved();
      }
    }
  }

  Future<void> fetchAllProfiles() async {
    try {
      List<Map<String, dynamic>> profiles = await dbHelper.getAllProfiles();
      if (profiles.isNotEmpty) {
        print('Found ${profiles.length} profiles:');
      } else {
        print('No user profiles found.');
      }
    } catch (e) {
      print('Error fetching profiles: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: MainDrawer(profileData: widget.profileData,onFavouriteRemoved: widget.onFavouriteRemoved,),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF05A7E),
        elevation: 0,
        title: const Text("Home Screen", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.search, color: Colors.white),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: widget.users.length,
        itemBuilder: (context, index) {
          final person = widget.users[index];
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.black12),
              ),
            ),
            child: Card(
              margin: const EdgeInsets.all(3),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: (person['Complexion'] != null && person['Complexion'].toString().isNotEmpty)
                              ? (person['Complexion'].toString().startsWith('http')
                              ? NetworkImage(person['Complexion'])
                              : FileImage(File(person['Complexion'])) as ImageProvider)
                              : const NetworkImage("https://i.pinimg.com/736x/37/9c/02/379c02a95aa49101b879cce1eb7a5a35.jpg"),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            person["Name"] ?? 'Unknown',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            person["Education"] ?? 'Unknown',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            '${person["City"] ?? "Unknown"}',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            '${person["Caste"] ?? "Unknown"} | ${person["SubCaste"] ?? "Unknown"}',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF05A7E),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  person["Occupation"] ?? 'Unknown',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfileScreen(profileData: person,onFavouriteRemoved: widget.onFavouriteRemoved,),
                              ),
                            );
                          },
                          child: Column(
                            children: const [
                              Icon(Icons.view_sidebar, color: Color(0xFFEA2264), size: 28),
                              Text("Profile", style: TextStyle(fontSize: 12, color: Color(0xFFEA2264))),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        InkWell(
                          onTap: () => _toggleFavourite(index),
                          child: Column(
                            children: [
                              Icon(
                                isLiked.isNotEmpty && isLiked[index] ? Icons.favorite : Icons.favorite_border,
                                color: isLiked.isNotEmpty && isLiked[index] ? Colors.red : const Color(0xFFF05A7E),
                                size: 28,
                              ),
                              Text(
                                "LIKE",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isLiked.isNotEmpty && isLiked[index] ? Colors.red : const Color(0xFFF05A7E),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
// File: homeScreen.dart



class MainDrawer extends StatelessWidget {
  final Map<String, dynamic> profileData;
  final VoidCallback onFavouriteRemoved;
  const MainDrawer({
    Key? key,
    required this.profileData,
    required this.onFavouriteRemoved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String userName = profileData['Name'] ?? 'Guest User';
    final String userEmail = profileData['Email'] ?? 'guest@example.com';
    final String? userImagePath = profileData['Complexion'] as String?;
    ImageProvider userImageProvider;

    if (userImagePath != null && userImagePath.isNotEmpty) {
      userImageProvider = userImagePath.startsWith('http')
          ? NetworkImage(userImagePath)
          : FileImage(File(userImagePath)) as ImageProvider;
    } else {
      userImageProvider = const AssetImage('assets/3809110.jpg');
    }

    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(userName,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold)),
            accountEmail: Text(userEmail,
                style: const TextStyle(color: Colors.white, fontSize: 10)),
            currentAccountPicture: CircleAvatar(
              radius: 35,
              backgroundImage: userImageProvider,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xFFF05A7E), Colors.pinkAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.lock, color: Colors.pink),
            title: const Text('Change Password', style: TextStyle(fontSize: 16)),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChangePasswordScreen(profileData: profileData)));
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.pink),
            title: const Text('Log Out', style: TextStyle(fontSize: 16)),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const Logonscreen()),
                     // remove all previous routes
              );
            },
          ),

        ],
      ),
    );
  }
}