import 'dart:io';
import 'package:flutter/material.dart';
import 'package:login_screen/database.dart';
import 'package:login_screen/homeScreen.dart';
import 'package:login_screen/notificationScreen.dart';
import 'package:login_screen/searchScreen.dart';
import 'package:login_screen/userProfilePage.dart';

class Dashboardscreen extends StatefulWidget {
  final List<Map<String, dynamic>> users;
  final Map<String, dynamic> profileData;
  final String username;
  final String password;

  const Dashboardscreen({
    Key? key,
    required this.users,
    required this.username,
    required this.password,
    required this.profileData,
  }) : super(key: key);

  @override
  State<Dashboardscreen> createState() => _DashboardscreenState();
}

class _DashboardscreenState extends State<Dashboardscreen> {
  int _selectedIndex = 0;
  Map<String, dynamic> profileData = {};
  bool _isLoadingProfile = true;
  List<Map<String, dynamic>> favoriteUsers = [];

  final MyDataBase dbHelper = MyDataBase.instance;

  @override
  void initState() {
    super.initState();
    _fetchAndSetUserProfile().then((_) => _fetchFavoriteUsers());
  }

  Future<void> _fetchAndSetUserProfile() async {
    setState(() => _isLoadingProfile = true);
    try {
      final userProfile = await dbHelper.getUserProfile(
        username: widget.username,
        password: widget.password,
      );
      if (userProfile != null) {
        setState(() => profileData = userProfile);
      }
    } catch (e) {
      print("Error fetching user profile: $e");
    } finally {
      setState(() => _isLoadingProfile = false);
    }
  }

  Future<void> _fetchFavoriteUsers() async {
    try {
      final favourites = await dbHelper.getAllFavourites();
      print("Favourite Users fetched from dashboard: $favourites");
      setState(() => favoriteUsers = favourites);
    } catch (e) {
      print("Error fetching favorites: $e");
    }
  }
  Widget _buildMatchesScreen() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(140),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFF05A7E), // Bright Pink
                Color(0xFFF05A7E), // Deeper Pink
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Row: Greeting + Profile Pic
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Text(
                      //   "Hello, ${profileData['Name'] ?? 'User'}!",
                      //   style: const TextStyle(
                      //     fontSize: 18,
                      //     fontWeight: FontWeight.bold,
                      //     color: Colors.white70,
                      //   ),
                      // ),
                      Text(
                        "Favourites",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      // Inside Row in AppBar
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfilePage(
                                profileData: profileData,
                                onFavouriteRemoved: _fetchFavoriteUsers,
                              ),
                            ),
                          );
                        },
                        child: CircleAvatar(
                          radius: 20,
                          backgroundImage: (profileData['Complexion'] != null &&
                              profileData['Complexion'].toString().isNotEmpty)
                              ? FileImage(File(profileData['Complexion']))
                              :  NetworkImage(
                            "https://i.pinimg.com/736x/37/9c/02/379c02a95aa49101b879cce1eb7a5a35.jpg",
                          ) as ImageProvider,
                        ),
                      ),

                    ],
                  ),
                  const SizedBox(height: 12),
                  // Search box
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search Name!",
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        prefixIcon: const Icon(Icons.search, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: favoriteUsers.isEmpty
          ? const Center(
        child: Text(
          "No favourite users found.",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      )
          : ListView.builder(
        itemCount: favoriteUsers.length,
        itemBuilder: (context, index) {
          final person = favoriteUsers[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: CircleAvatar(
                radius: 28,
                backgroundImage: (person["Complexion"] != null &&
                    person["Complexion"].toString().isNotEmpty)
                    ? FileImage(File(person["Complexion"]))
                    : const NetworkImage(
                    "https://i.pinimg.com/736x/37/9c/02/379c02a95aa49101b879cce1eb7a5a35.jpg")
                as ImageProvider,
              ),
              title: Text(
                person["Name"] ?? "Unknown",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                "${person["Education"] ?? "Unknown"} • ${person["City"] ?? "Unknown"}",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  final deletedRows =
                  await dbHelper.removeFromFavouriteByEmail(
                    person['Email'] ?? '',
                  );
                  if (deletedRows > 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Removed from favourites')),
                    );
                    await _fetchFavoriteUsers();
                  }
                },
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(
                      profileData: person,
                      onFavouriteRemoved: _fetchFavoriteUsers,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    if (_isLoadingProfile) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
          ),
        ),
      );
    }

    final widgetList = [
      Homescreen(
        users: widget.users,
        profileData: profileData,
        onFavouriteRemoved: _fetchFavoriteUsers,
      ),
      _buildMatchesScreen(),
      Searchscreen(),
      Notificationscreen(),
      ProfilePage(
        profileData: profileData,
        onFavouriteRemoved: _fetchFavoriteUsers,
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: widgetList[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Matches'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notifications'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (index) async {
          setState(() => _selectedIndex = index);
          if (index == 1) {
            await _fetchFavoriteUsers(); // refresh favourites on Matches tab
          }
        },
      ),
    );
  }
}
