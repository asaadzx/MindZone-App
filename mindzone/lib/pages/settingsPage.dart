// ignore_for_file: file_names, depend_on_referenced_packages, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart'; 
import 'package:path_provider/path_provider.dart'; 
import 'package:path/path.dart';

import 'loginPage.dart'; // Import the login page for navigation after logout
import 'package:mindzone/utils/theme_provider.dart'; // Import the ThemeProvider
import 'package:mindzone/data/database_helper.dart'; // Import the database helper


// This is a settings page widget.
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _descriptionController = TextEditingController();
  String? _profilePicturePath;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserSettings();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadUserSettings() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Load description from Firestore
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          _descriptionController.text = userDoc.data()?['description'] ?? '';
        }

        // Load profile picture path from SQLite
        final dbUser = await DatabaseHelper().getUser(); // Get the user from SQLite
        if (dbUser != null && dbUser.profilePicturePath != null) {
          setState(() {
            _profilePicturePath = dbUser.profilePicturePath;
          });
        }
      }
    } catch (e) {
      // Handle errors
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveSettings(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Save description to Firestore
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
          { 'description': _descriptionController.text.trim() },
          SetOptions(merge: true), // Use merge to update without overwriting other fields
        );

        // Save profile picture path to SQLite
        if (_profilePicturePath != null) {
          // Assuming the user's email is unique and exists in SQLite
          await DatabaseHelper().updateUserProfilePicture(user.email!, _profilePicturePath!); 
        }
      }
      // Add a comment to trigger re-analysis
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Settings saved successfully!'))
        );
      }
    } catch (e) {
       if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving settings: ${e.toString()}'))
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickProfilePicture(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Get the application documents directory
      final appDocumentsDirectory = await getApplicationDocumentsDirectory();
      // Create a unique filename for the image
      final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.png';
      // Create the file path
      final localPath = join(appDocumentsDirectory.path, fileName);

      // Save the picked file to the local path
      final File newImage = await File(pickedFile.path).copy(localPath);

      setState(() {
        _profilePicturePath = newImage.path;
      });

      // Automatically save the settings after picking a picture
      _saveSettings(context);
    }
  }

  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();

      // Delete user data from SQLite
      await DatabaseHelper().deleteUser();

      // Show a success message
      if (mounted) {
        ScaffoldMessenger.of(context as BuildContext).showSnackBar(
          const SnackBar(
            content: Text('Successfully logged out and local data cleared.'),
            backgroundColor: Colors.green,
          ),
        );
      }

      // Navigate back to the login page after signing out
      if (mounted) {
        Navigator.of(context as BuildContext).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context as BuildContext).showSnackBar(
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // Profile Picture
                Center(
                  child: GestureDetector(
                    onTap: () => _pickProfilePicture(context),
                    child: CircleAvatar(
                      radius: 50,
                      // Display profile picture if available, otherwise a default icon
                      backgroundImage: _profilePicturePath != null
                          ? FileImage(File(_profilePicturePath!)) as ImageProvider // Use FileImage for local files
                          : null,
                      child: _profilePicturePath == null
                          ? const Icon(Icons.camera_alt, size: 50) // Default icon
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Description Field
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Tell us about yourself...',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 20),

                // Save Button
                ElevatedButton(
                  onPressed: () => _saveSettings(context),
                  child: const Text('Save Settings'),
                ),
                const Divider(),

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