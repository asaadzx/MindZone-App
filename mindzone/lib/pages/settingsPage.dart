// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart'; 
import 'package:provider/provider.dart';

import 'loginPage.dart'; // Import the login page for navigation after logout
import 'package:mindzone/utils/theme_provider.dart'; // Import the ThemeProvider
import 'package:mindzone/data/database_helper.dart'; // Import the database helper

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();

      // Delete user data from SQLite
      await DatabaseHelper().deleteUser();

      // Show a success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Successfully logged out and local data cleared.'),
            backgroundColor: Colors.green,
          ),
        );
      }

      // Navigate back to the login page after signing out
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error logging out: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Access the ThemeProvider
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Theme Settings
          ListTile(
            title: const Text('Theme Mode'),
            trailing: DropdownButton<bool>(
              // Use the theme mode from ThemeProvider
              value: themeProvider.themeMode == ThemeMode.dark,
              items: const [
                DropdownMenuItem(value: false, child: Text('Light')),
                DropdownMenuItem(value: true, child: Text('Dark')),
              ],
              onChanged: (bool? newValue) {
                if (newValue != null) {
                  // Call toggleTheme from ThemeProvider
                  themeProvider.toggleTheme(newValue);
                }
              },
            ),
          ),
          const Divider(),

          // Logout Button
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text('Logout', style: TextStyle(color: Colors.redAccent)),
            onTap: _signOut,
          ),
          const Divider(),

          // Credits Section
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Credits',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => _launchUrl('https://github.com/asaadzx'),
                  child: const Text(
                    'Developed by asaadzx',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}