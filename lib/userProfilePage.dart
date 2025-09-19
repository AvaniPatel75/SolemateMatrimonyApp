// File: userProfilePage.dart (This is the file where you would make this change)

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:login_screen/database.dart';
import 'package:login_screen/editProfile.dart'; // Ensure this import is correct
import 'package:login_screen/homeScreen.dart';
import 'package:login_screen/userProfilePage.dart';

class ProfilePage extends StatefulWidget {
  final Map<String, dynamic> profileData;
  final VoidCallback onFavouriteRemoved;
  const ProfilePage({Key? key, required this.profileData, required this.onFavouriteRemoved}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isFavorite = false;
  List<Map<String, dynamic>> users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
    _checkIfFavourite();
  }

  void _loadUsers() async {
    final result = await MyDataBase.instance.getAllProfiles();
    setState(() {
      users = result;
    });
  }

  void _checkIfFavourite() async {
    final email = widget.profileData['Email'];
    if (email != null) {
      final fav = await MyDataBase.instance.isFavourite(email);
      setState(() {
        _isFavorite = fav;
      });
    }
  }

  Future<void> _toggleFavourite() async {
    final email = widget.profileData['Email'];
    if (email == null) return;

    if (_isFavorite) {
      // Remove from Favourite
      await MyDataBase.instance.removeFromFavouriteByEmail(email);
      widget.onFavouriteRemoved(); // 🔔 notify parent
    } else {
      // Add to Favourite
      await MyDataBase.instance.addToFavourite(widget.profileData);
    }

    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String name = widget.profileData['Name']?.toString() ?? 'Samantha John';
    final String age = widget.profileData['Age']?.toString() ?? 'Not specified';
    final String city = widget.profileData['City']?.toString() ?? 'Not specified';
    final String bio = widget.profileData['Bio']?.toString() ?? 'A few lines about me...';
    final String religion = widget.profileData['Religion']?.toString() ?? 'Not specified';
    final String caste = widget.profileData['Caste']?.toString() ?? 'Not specified';
    final String subCaste = widget.profileData['SubCaste']?.toString() ?? 'Not specified';
    final String occupation = widget.profileData['Occupation']?.toString() ?? 'Not specified';
    final String income = widget.profileData['Income']?.toString() ?? 'Not specified';
    final String height = widget.profileData['Height']?.toString() ?? 'Not specified';
    final String education = widget.profileData['Education']?.toString() ?? 'Not specified';
    final String? imagePath = widget.profileData['Complexion'];

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : Colors.white,
            ),
            onPressed: _toggleFavourite, // Corrected onPressed
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildProfileHeader(imagePath),
            const SizedBox(height: 100.0),
            _buildDetailsSection(name, bio, education, occupation, income, age, height, city, religion, caste, subCaste),
            const SizedBox(height: 20.0),
            _buildEditProfileButton(context),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(String? imagePath) {
    ImageProvider profileImage;
    if (imagePath != null && imagePath.isNotEmpty) {
      if (imagePath.startsWith('http')) {
        profileImage = NetworkImage(imagePath);
      } else {
        profileImage = FileImage(File(imagePath));
      }
    } else {
      profileImage = const NetworkImage('https://cdn-icons-png.flaticon.com/512/3135/3135789.png');
    }

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: <Widget>[
        Container(
          height: 250.0,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  'https://static.vecteezy.com/system/resources/thumbnails/058/184/470/small/two-wedding-rings-on-a-pink-background-with-roses-and-confetti-photo.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFFFF0066).withOpacity(0.4),
                  const Color(0xFFF75270).withOpacity(0.7),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 180,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white,
              backgroundImage: profileImage,
            ),
          ),
        ),
        Positioned(
          top: 100,
          child: Column(
            children: [
              Text(
                widget.profileData['Name']?.toString() ?? 'Samantha John',
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsSection(String name, String bio, String education, String occupation, String income, String age, String height, String city, String religion, String caste, String subCaste) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildSectionTitle('About Me'),
              _buildAboutMeSection(bio),
              const Divider(thickness: 1, height: 30),
              _buildSectionTitle('Basic Details'),
              _buildInfoRow('Age', age),
              _buildInfoRow('Height', height),
              _buildInfoRow('City', city),
              const Divider(thickness: 1, height: 30),
              _buildSectionTitle('Professional & Educational Details'),
              _buildInfoRow('Education', education),
              _buildInfoRow('Occupation', occupation),
              _buildInfoRow('Income', income),
              const Divider(thickness: 1, height: 30),
              _buildSectionTitle('Religious & Caste Details'),
              _buildInfoRow('Religion', religion),
              _buildInfoRow('Caste', caste),
              _buildInfoRow('Sub Caste', subCaste),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditProfileButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF0066), Color(0xFFF75270)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ElevatedButton(
          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Editprofile(
                  profileData: widget.profileData, // Pass the full map
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            'Edit Profile',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          color: Color(0xFFF75270),
        ),
      ),
    );
  }

  Widget _buildAboutMeSection(String bio) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5.0),
        Text(
          bio,
          style: TextStyle(color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w500),
          ),
          Text(value, style: const TextStyle(color: Colors.black87)),
        ],
      ),
    );
  }
}