import 'package:flutter/material.dart';
// Assuming you have this file for database interaction
import 'package:login_screen/database.dart';
import 'dart:io';

import 'package:login_screen/userProfilePage.dart';

class Searchscreen extends StatefulWidget {
  const Searchscreen({super.key});

  @override
  State<Searchscreen> createState() => _SearchscreenState();
}

class _SearchscreenState extends State<Searchscreen> {
  final TextEditingController _searchController = TextEditingController();
  final MyDataBase dbHelper = MyDataBase.instance;

  List<Map<String, dynamic>> _allUsers = [];
  List<Map<String, dynamic>> _searchResults = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllUsers();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  // Fetch all users from the backend (database)
  Future<void> _loadAllUsers() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final users = await dbHelper.getAllProfiles();
      setState(() {
        _allUsers = users;
        _searchResults = users; // Initially, show all users
      });
    } catch (e) {
      print("Error loading users: $e");
      // Handle the error, e.g., show a snackbar
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Listener for the search text field
  void _onSearchChanged() {
    _performSearch(_searchController.text);
  }

  // This function will be called when the user types or submits a query
  void _performSearch(String query) {
    final lowerCaseQuery = query.toLowerCase();
    setState(() {
      _searchResults = _allUsers.where((user) {
        final name = user['Name']?.toLowerCase() ?? '';
        final city = user['City']?.toLowerCase() ?? '';
        final occupation = user['Occupation']?.toLowerCase() ?? '';
        final caste = user['Caste']?.toLowerCase() ?? '';
        final subCaste = user['SubCaste']?.toLowerCase() ?? '';

        return name.contains(lowerCaseQuery) ||
            city.contains(lowerCaseQuery) ||
            occupation.contains(lowerCaseQuery) ||
            caste.contains(lowerCaseQuery) ||
            subCaste.contains(lowerCaseQuery);
      }).toList();
    });
  }

  Widget _buildSearchResultsList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_searchResults.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            _searchController.text.isEmpty
                ? 'Start typing to search for profiles.'
                : 'No profiles found matching "${_searchController.text}".',
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final person = _searchResults[index];
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.black12),
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundImage: (person["Complexion"] != null &&
                    person["Complexion"].toString().isNotEmpty)
                    ? (person["Complexion"].toString().startsWith("http")
                    ? NetworkImage(person["Complexion"])
                    : FileImage(File(person["Complexion"]))
                as ImageProvider)
                    : const NetworkImage(
                    'https://i.pinimg.com/736x/37/9c/02/379c02a95aa49101b879cce1eb7a5a35.jpg'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(person["Name"] ?? 'Unknown',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(person["Education"] ?? 'Unknown',
                        style:
                        const TextStyle(fontSize: 13, color: Colors.grey)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF0066),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(person["City"] ?? 'Unknown',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12)),
                        ),
                        const SizedBox(width: 6),
                        Text("(${person["Caste"] ?? 'Unknown'})",
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey)),
                      ],
                    )
                  ],
                ),
              ),
              // Replaced the "LIKE" button with "View Profile"
              InkWell(
                onTap: () {
                  // Navigate to the profile page
                  // Replace 'ProfilePage()' with the actual name of your profile screen widget
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => (profileData:person, onFavouriteRemoved:onFavouriteRemove() async {

                    }), // Pass user data to the profile page if needed
                    ),
                  );
                },
                child: Column(
                  children: const [
                    Icon(Icons.more_horiz, color: Color(0xFFEA2264), size: 28),
                    Text("View",
                        style: TextStyle(fontSize: 12, color: Color(0xFFEA2264))),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            toolbarHeight: 120,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFF05A7E), Color(0xFFF05A7E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: const FlexibleSpaceBar(
                centerTitle: true,
                titlePadding: EdgeInsets.only(bottom: 24),
                title: Text(
                  'Search',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search for profiles by name, city, etc.',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      prefixIcon:
                      const Icon(Icons.search, color: Color(0xFFD9A299)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 20.0),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(
                            color: Color(0xFFD9A299), width: 2.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSearchResultsList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}