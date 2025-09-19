import 'package:flutter/material.dart';
import 'package:login_screen/basicDetailScreen.dart';
import 'package:login_screen/homeScreen.dart';
import 'package:login_screen/signupScreen.dart';
import 'package:login_screen/dashboardScreen.dart';

import 'database.dart'; // ✅ Import Dashboard

class Logonscreen extends StatefulWidget {
  const Logonscreen({super.key});

  @override
  State<Logonscreen> createState() => _LogonscreenState();
}

class _LogonscreenState extends State<Logonscreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final Color primaryColor = const Color(0xFFD9A299);
  final Color secondaryColor = const Color(0xFFE5C0BF);
  final Color textColor = const Color(0xFF6B4226);

  List<Map<String, dynamic>> _profiles = [];
  bool _isLoading = true;
  Map<String, dynamic> _userProfile ={};

  @override
  void initState(){
    super.initState();
    _fetchAndSetProfiles();
  }
  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final db = MyDataBase.instance;

      bool exists = await db.verifyUser(
        username: _usernameController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (exists) {

        final userProfile = await db.getUserProfile(
          username: _usernameController.text.trim(),
          password: _passwordController.text.trim(),
        );
        print('User Profile found from UserDetails in login screen $userProfile');
        final allUser=await db.getAllProfiles();
        if(userProfile!=null){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("Login successful 🎉"),
              backgroundColor: Colors.green,

            ),
          );
          //final allUsers = await db.getAllProfiles();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Dashboardscreen(users: allUser, username: _usernameController.text, password: _passwordController.text ,profileData:userProfile )),
          );
        }else{
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("User profile not found ❌"),
              backgroundColor: Colors.red,
            ),
          );
        }

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Invalid username or password ❌"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // ✅ Pop back to previous screen
          },
        ),
        title: const Text(
          "Login",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // 🔝 Top Logo Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(30),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(80),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    Image.asset(
                      "assets/3561190.jpg", // replace with your logo
                      height: 120,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Solemate",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFB6F92),
                      ),
                    ),
                    const Text(
                      "Matrimony App",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),

              // 🔽 Login Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Username
                      _buildTextField(
                        controller: _usernameController,
                        label: "User Id",
                        icon: Icons.person,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Username is required";
                          } else if (value.length < 8) {
                            return "Username must be at least 8 characters";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Password
                      _buildTextField(
                        controller: _passwordController,
                        label: "Password",
                        icon: Icons.lock,
                        isObscure: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Password is required";
                          }
                          final hasDigit = RegExp(r'\d').hasMatch(value);
                          final hasSpecial = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value);
                          if (!hasDigit || !hasSpecial) {
                            return "Password must contain at least 1 digit & 1 special character";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 15),

                      // Links Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const Signinscreen()),
                              );
                            },
                            child: const Text(
                              "New user? Sign up",
                              style: TextStyle(
                                color: Color(0xFFFB6F92),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Forgot password
                            },
                            child: const Text(
                              "Forgot password?",
                              style: TextStyle(
                                color: Color(0xFFFB6F92),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),

                      // 🔘 Gradient Login Button
                      Container(
                        width: double.infinity,
                        height: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFB6F92), Color(0xFFFF8FAB)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: _handleLogin,
                          child: const Text(
                            "Login",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  MyDataBase dbHelper = MyDataBase.instance;

// 2. Call the method to get all profiles
  Future<void> _fetchAndSetProfiles() async {
    try {
      final dbHelper = MyDataBase.instance;
      final fetchedProfiles = await dbHelper.getAllProfiles();
      setState(() {
        _profiles = fetchedProfiles;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching profiles: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // 🔧 Reusable TextField Builder
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    bool isObscure = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isObscure,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: primaryColor),
        labelStyle: TextStyle(color: textColor),
        floatingLabelStyle: TextStyle(color: primaryColor),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: secondaryColor, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: primaryColor, width: 2.0),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      ),
    );
  }
}
