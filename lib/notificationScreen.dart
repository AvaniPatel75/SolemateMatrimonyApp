import 'package:flutter/material.dart';

class Notificationscreen extends StatefulWidget {
  const Notificationscreen({super.key});

  @override
  State<Notificationscreen> createState() => _NotificationscreenState();
}

class _NotificationscreenState extends State<Notificationscreen> {
  final List<Map<String, dynamic>> notifications = [
    {
      'title': 'New Profile Match',
      'body': 'Dhruvi Shah has matched with you!',
      'time': '2 mins ago',
      'icon': Icons.favorite,
    },
    {
      'title': 'New Message',
      'body': 'You have a new message from Ramesh Patel.',
      'time': '1 hour ago',
      'icon': Icons.chat_bubble,
    },
    {
      'title': 'Profile Viewed',
      'body': 'Aman Joshi viewed your profile.',
      'time': 'Yesterday',
      'icon': Icons.visibility,
    },
    {
      'title': 'Profile Updated',
      'body': 'Your profile has been updated successfully.',
      'time': '3 days ago',
      'icon': Icons.person,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70, // Light background color
      appBar: AppBar(
        backgroundColor: Color(0xFFF05A7E),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF05A7E), Color(0xFFF05A7E)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: notifications.isEmpty
          ? const Center(
        child: Text(
          'No new notifications.',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16.0),
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFFF05A7E).withOpacity(0.2), // Light theme color background
                  child: Icon(
                    notification['icon'] as IconData,
                    color: const Color(0xFFF05A7E), // Theme color for the icon
                  ),
                ),
                title: Text(
                  notification['title'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: Colors.black87,
                  ),
                ),
                subtitle: Text(
                  '${notification['body']}\n${notification['time']}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14.0,
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Tapped on: ${notification['title']}'),
                      backgroundColor: const Color(0xFFF05A7E),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}