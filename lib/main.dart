import 'package:flutter/material.dart';
import 'package:login_screen/basicDetailScreen.dart';
import 'package:login_screen/dashboardScreen.dart';
import 'package:login_screen/landingPage.dart';
import 'package:login_screen/logonScreen.dart';
import 'package:login_screen/notificationScreen.dart';
import 'package:login_screen/onBoardingScreen.dart';

void main() {
  runApp(const MatrimonyLoginApp());
}

class MatrimonyLoginApp extends StatelessWidget {
  const MatrimonyLoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //checkerboardOffscreenLayers: false,
      title: 'Matrimony App Login',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
        seedColor: Color(0xFFFF0066), // A strong red, matching your image's primary accent
        brightness: Brightness.light, // Overall brightness of the theme
        primary: Color(0xFFFF0066),
        onPrimary: Colors.white,
        // secondary: Colors.blueAccent, // Example secondary color
        // background: Colors.white,
        // surface: Colors.white,
        // onSurface: Colors.black,
      ),
        primarySwatch: Colors.grey, // Using a pink shade similar to rose-600
        fontFamily: 'Inter', // Assuming Inter font is available or will be configured
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.pink, width: 2.0),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          hintStyle: TextStyle(color: Colors.grey[500]),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink[600],
            foregroundColor: Colors.white, // Text color for the button
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            textStyle: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
            ),
            elevation: 5, // Shadow effect
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.pink[600], // Text color for links
            textStyle: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      initialRoute: '/',
      // routes: {
      //   '/':Onboardingscreen()
      // },
      home: Landingpage(),
    );
  }
}

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});
//
//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//
//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }
//
//   void _handleLogin() {
//     // Implement login logic here
//     // For now, just print the values
//     print('Email: ${_emailController.text}');
//     print('Password: ${_passwordController.text}');
//     // In a real app, you would call an authentication service
//     // and navigate to the next screen upon successful login.
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return LoginPage();
//   }
// }
