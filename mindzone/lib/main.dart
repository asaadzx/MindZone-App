import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart'; // Import provider

// import Pages
import 'package:mindzone/pages/signupPage.dart'; 
import 'package:mindzone/utils/themes.dart'; // Import themes
import 'package:mindzone/utils/theme_provider.dart'; // Import ThemeProvider

// import Firebase Options
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MindZoneApp());
}

class MindZoneApp extends StatelessWidget { 
  const MindZoneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider( 
      create: (context) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'MindZone',
            theme: lightTheme, // Use light theme
            darkTheme: darkTheme, // Use dark theme
            themeMode: themeProvider.themeMode, 
            home: SignupPage(),
          );
        },
      ),
    );
  }
}

