// ignore_for_file: file_names

import 'package:flutter/material.dart';

import 'settingsPage.dart'; // Import the settings page
import 'package:mindzone/data/database_helper.dart'; // Import the database helper

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> { 
  String _userName = 'User';

  @override
  void initState() {
    super.initState();
    _loadUserName(); // Load user name when the widget is created
  }

  Future<void> _loadUserName() async {
    final user = await DatabaseHelper().getUser();
    if (user != null) {
      setState(() {
        _userName = user.name; 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MindZone'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Welcome to MindZone',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.add_comment),
              title: const Text('Assistant'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('Favorites'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                // Navigate to SettingsPage when the Settings ListTile is tapped
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, $_userName!', // Use the state variable here
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(36),
              ),
              child: ListTile(
                leading: const Icon(Icons.chat, size: 40, color: Colors.lightBlue),
                title: const Text('Start Asking '),
                subtitle: const Text('Tap to begin your journey for best advices and tips'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 29, color: Colors.blueAccent),
                onTap: () {},
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Recommended for you with AI',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                children: [
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.nightlight_round, color: Colors.lightBlue),
                      title: const Text('Sleep Stories'),
                      onTap: () {},
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.spa, color: Colors.lightBlue),
                      title: const Text('Exercises for Relaxation'),
                      onTap: () {},
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.music_note, color: Colors.lightBlue),
                      title: const Text('Calming Music'),
                      onTap: () {},
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.book, color: Colors.lightBlue),
                      title: const Text('Hoobbies and Interests tracker'),
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}