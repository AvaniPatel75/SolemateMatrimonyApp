// File: changePasswordScreen.dart

import 'package:flutter/material.dart';
import 'package:login_screen/database.dart';

class ChangePasswordScreen extends StatefulWidget {
  final Map<String, dynamic> profileData;

  const ChangePasswordScreen({Key? key, required this.profileData}) : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();

  final MyDataBase dbHelper = MyDataBase.instance;
  bool _isLoading = false;
  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final String userEmail = widget.profileData['Email'];
      final String userName = widget.profileData['UserName'];
      final String currentPassword = _currentPasswordController.text;
      final String newPassword = _newPasswordController.text;

      final isVerified = await dbHelper.verifyUser(username: userEmail, password: currentPassword);

      if (!isVerified) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Incorrect current password.')),
          );
        }
        setState(() => _isLoading = false);
        return;
      }

      final rowsAffected = await dbHelper.updateUserPasswordByEmail(userEmail, newPassword);

      if (rowsAffected > 0) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password changed successfully!')),
          );
          Navigator.pop(context);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to change password. Please try again.')),
          );
        }
      }
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Added an AppBar with a back button and title
      appBar: AppBar(
        title: const Text(
          'Change Password',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.pink,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              // Current Password Field with show/hide button
              _buildPasswordField(
                controller: _currentPasswordController,
                labelText: 'Current Password',
                icon: Icons.lock,
                isVisible: _isCurrentPasswordVisible,
                onToggle: (value) => setState(() => _isCurrentPasswordVisible = value),
              ),
              const SizedBox(height: 20),
              // New Password Field with show/hide button
              _buildPasswordField(
                controller: _newPasswordController,
                labelText: 'New Password',
                icon: Icons.lock_open,
                isVisible: _isNewPasswordVisible,
                onToggle: (value) => setState(() => _isNewPasswordVisible = value),
                isNewPassword: true,
              ),
              const SizedBox(height: 20),
              // Confirm New Password Field with show/hide button
              _buildPasswordField(
                controller: _confirmNewPasswordController,
                labelText: 'Confirm New Password',
                icon: Icons.lock_reset,
                isVisible: _isConfirmPasswordVisible,
                onToggle: (value) => setState(() => _isConfirmPasswordVisible = value),
                isConfirmPassword: true,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _isLoading ? null : _changePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                    : const Text(
                  'Change Password',
                  style: TextStyle(fontSize: 18.0, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget to build a password field with a toggle button
  Widget _buildPasswordField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    required bool isVisible,
    required ValueChanged<bool> onToggle,
    bool isNewPassword = false,
    bool isConfirmPassword = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !isVisible,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        suffixIcon: IconButton(
          icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
          onPressed: () => onToggle(!isVisible),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $labelText.';
        }
        if (isConfirmPassword && value != _newPasswordController.text) {
          return 'Passwords do not match.';
        }
        if (isNewPassword && value.length < 6) {
          return 'Password must be at least 6 characters long.';
        }
        return null;
      },
    );
  }
}