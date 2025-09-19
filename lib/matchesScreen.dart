import 'package:flutter/material.dart';

class MatchesScreen extends StatelessWidget {
  const MatchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Define the color palette
    final Color primaryColor = const Color(0xFFFFD6BA);
    final Color secondaryColor = const Color(0xFFFFE8CD);
    final Color backgroundColor = const Color(0xFFFFF2EB);
    final Color cardColor1 = const Color(0xFFDCDCFF); // Using a different shade for contrast
    final Color cardColor2 = const Color(0xFFE8C8B3); // A mix of the palette for a reddish tone

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Handle back navigation
          },
        ),
        title: const Text(
          'Matches',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Top tabs
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // _buildTabButton('Online', true, primaryColor),
                // _buildTabButton('Matches', false, primaryColor),
              ],
            ),
          ),
          // Grid of profile cards
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.75, // Adjust this ratio to fit the card content
              ),
              itemCount: 8, // Placeholder for a fixed number of items
              itemBuilder: (context, index) {
                // Alternating card colors for visual variety
                final cardColor = index % 2 == 0 ? cardColor1 : cardColor2;
                return _buildProfileCard(cardColor);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String text, bool isActive, Color activeColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? activeColor : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive ? activeColor : Colors.grey,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildProfileCard(Color cardColor) {
    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(13)),
              child: Image.network(
                'https://via.placeholder.com/150', // Placeholder image
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Name, 25', // Placeholder for name and age
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: const [
                    Icon(Icons.location_on, size: 14),
                    SizedBox(width: 4),
                    Text(
                      'City, Country', // Placeholder for location
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}