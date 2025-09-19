import 'dart:io';
import 'package:flutter/material.dart';
import 'package:login_screen/database.dart';

class ProfileScreen extends StatefulWidget {
  final Map<String, dynamic> profileData;
  final VoidCallback onFavouriteRemoved;

  const ProfileScreen({
    Key? key,
    required this.profileData,
    required this.onFavouriteRemoved,
  }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavourite();
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
      await MyDataBase.instance.removeFromFavouriteByEmail(email);
      widget.onFavouriteRemoved();
    } else {
      await MyDataBase.instance.addToFavourite(widget.profileData);
    }

    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.profileData;
    final String? imagePath = data['Complexion'];

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : Colors.white,
            ),
            onPressed: _toggleFavourite,
          ),
          const Icon(Icons.more_vert, color: Colors.white),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(imagePath, data['Name'], data['City']),
            const SizedBox(height: 100),
            _buildDetailsSection(data),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(String? imagePath, String? name, String? city) {
    ImageProvider profileImage;
    if (imagePath != null && imagePath.isNotEmpty) {
      profileImage = imagePath.startsWith('http')
          ? NetworkImage(imagePath)
          : FileImage(File(imagePath));
    } else {
      profileImage = const NetworkImage(
          'https://cdn-icons-png.flaticon.com/512/3135/3135789.png');
    }

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Container(
          height: 250,
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
                colors: [Colors.pink.withOpacity(0.5), Colors.black26],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
        Positioned(
          top: 180,
          child: CircleAvatar(
            radius: 60,
            backgroundColor: Colors.white,
            backgroundImage: profileImage,
          ),
        ),
        Positioned(
          top: 100,
          child: Column(
            children: [
              Text(
                name ?? 'Unknown User',
                style: const TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Text(
                city ?? 'Not Specified',
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsSection(Map<String, dynamic> data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle("About Me"),
              _buildAboutMeSection(data['Bio'] ?? 'No bio available'),
              const Divider(thickness: 1, height: 30),

              _buildSectionTitle("Basic Details"),
              _buildInfoRow("Age", data['Age']?.toString() ?? 'N/A'),
              _buildInfoRow("Height", data['Height']?.toString() ?? 'N/A'),
              _buildInfoRow("City", data['City']?.toString() ?? 'N/A'),

              const Divider(thickness: 1, height: 30),
              _buildSectionTitle("Professional & Education"),
              _buildInfoRow("Education", data['Education'] ?? 'N/A'),
              _buildInfoRow("Occupation", data['Occupation'] ?? 'N/A'),
              _buildInfoRow("Income", data['Income']?.toString() ?? 'N/A'),

              const Divider(thickness: 1, height: 30),
              _buildSectionTitle("Religion & Caste"),
              _buildInfoRow("Religion", data['Religion'] ?? 'N/A'),
              _buildInfoRow("Caste", data['Caste'] ?? 'N/A'),
              _buildInfoRow("SubCaste", data['SubCaste'] ?? 'N/A'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title,
        style: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pink));
  }

  Widget _buildAboutMeSection(String bio) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Text(bio, style: TextStyle(color: Colors.grey.shade600)),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label,
            style: TextStyle(
                color: Colors.grey.shade700, fontWeight: FontWeight.w500)),
        Text(value, style: const TextStyle(color: Colors.black87)),
      ]),
    );
  }
}
