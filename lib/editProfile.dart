// File: editProfile.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:login_screen/dashboardScreen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:login_screen/database.dart';
import '../database.dart';

class Editprofile extends StatefulWidget {
  final Map<String, dynamic> profileData;

  const Editprofile({
    Key? key,
    required this.profileData,
  }) : super(key: key);

  @override
  EditprofileState createState() => EditprofileState();
}

class EditprofileState extends State<Editprofile> {
  final List<Map<String, dynamic>> users = [];
  final MyDataBase dbHelper = MyDataBase.instance;

  // Text controllers
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _casteController = TextEditingController();
  final TextEditingController _subCasteController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();
  final TextEditingController _educationController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  // Dropdown selections
  String? _selectedGender;
  String? _selectedReligion;
  String? _selectedIncome;
  String? _selectedFamilyType;
  String? _selectedMaritalStatus;
  String? _selectedMarryOutside;

  File? _pickedImage;
  Map<String, dynamic>? _currentProfile;
  bool _isLoading = true;

  final Color primaryColor = const Color(0xFFFB6F92);
  final Color secondaryColor = const Color(0xFFFF8FAB);
  final Color textColor = const Color(0xFF6B4226);

  // New variables to hold username and password
  String? _username;
  String? _password;

  @override
  void initState() {
    super.initState();
    _populateFields(widget.profileData);
    _fetchProfileAndCredentials();
    _dobController.addListener(_updateAgeFromDob);
  }

  @override
  void dispose() {
    _dobController.removeListener(_updateAgeFromDob);
    _fullNameController.dispose();
    _ageController.dispose();
    _dobController.dispose();
    _emailController.dispose();
    _cityController.dispose();
    _casteController.dispose();
    _subCasteController.dispose();
    _heightController.dispose();
    _occupationController.dispose();
    _educationController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _fetchProfileAndCredentials() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final userEmail = widget.profileData['Email']?.toString();
      if (userEmail == null) {
        throw Exception("User email not found in profile data.");
      }

      // Fetch user profile from UserDetails table
      final userProfile = await dbHelper.getLoggedUserByEmail(userEmail);

      // Fetch username and password from LoggedUser table
      final loggedUser = await dbHelper.getLoggedUserByEmail(userEmail);

      if (userProfile != null && loggedUser != null) {
        _currentProfile = userProfile;
        _username = loggedUser['UserName'] as String;
        _password = loggedUser['Password'] as String;

        // _populateFields(userProfile); // This line is not needed here anymore as it's done in initState
      } else {
        throw Exception("User profile or credentials not found.");
      }
    } catch (e) {
      print("Error fetching user data: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _populateFields(Map<String, dynamic> profile) {
    _fullNameController.text = profile['Name']?.toString() ?? '';
    _ageController.text = profile['Age']?.toString() ?? '';
    _dobController.text = profile['DOB']?.toString() ?? '';
    _emailController.text = profile['Email']?.toString() ?? '';
    _cityController.text = profile['City']?.toString() ?? '';
    _casteController.text = profile['Caste']?.toString() ?? '';
    _subCasteController.text = profile['SubCaste']?.toString() ?? '';
    _heightController.text = profile['Height']?.toString() ?? '';
    _occupationController.text = profile['Occupation']?.toString() ?? '';
    _educationController.text = profile['Education']?.toString() ?? '';
    _bioController.text = profile['Bio']?.toString() ?? '';
    _selectedGender = profile['Gender']?.toString();
    _selectedReligion = profile['Religion']?.toString();
    _selectedIncome = profile['Income']?.toString();
    _selectedFamilyType = profile['FamilyType']?.toString();
    _selectedMaritalStatus = profile['MaritalStatus']?.toString();
    _selectedMarryOutside = profile['MarryOutside']?.toString();

    final imagePath = profile['Complexion']?.toString();
    if (imagePath != null && imagePath.isNotEmpty && !imagePath.startsWith('http')) {
      _pickedImage = File(imagePath);
    }
  }

  void _updateAgeFromDob() {
    try {
      if (_dobController.text.isNotEmpty) {
        final parts = _dobController.text.split('/');
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);

        final dob = DateTime(year, month, day);
        final today = DateTime.now();

        int age = today.year - dob.year;
        if (today.month < dob.month || (today.month == dob.month && today.day < dob.day)) {
          age--;
        }
        _ageController.text = age.toString();
      }
    } catch (e) {
      print("Error parsing date: $e");
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  }

  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: ColorScheme.light(
            primary: primaryColor,
            onPrimary: Colors.white,
            onSurface: Colors.black,
          ),
        ),
        child: child!,
      ),
    );
    if (pickedDate != null) {
      _dobController.text = "${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}";
      _updateAgeFromDob();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: primaryColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile Picture Section
              _buildImageHeader(),

              // Form Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(_fullNameController, "Full Name", Icons.person),
                    const SizedBox(height: 20),
                    _buildTextField(_ageController, "Age", Icons.calendar_today,
                        keyboardType: TextInputType.number, readOnly: true),
                    const SizedBox(height: 20),
                    _buildTextField(_dobController, "Date of Birth (dd/mm/yyyy)", Icons.date_range,
                        readOnly: true, onTap: _pickDate),
                    const SizedBox(height: 20),
                    _buildTextField(_emailController, "Email", Icons.email,
                        keyboardType: TextInputType.emailAddress, readOnly: true),
                    const SizedBox(height: 20),

                    // Gender Selection
                    const Text("Gender", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _buildGenderButton("Male", Icons.male)),
                        const SizedBox(width: 15),
                        Expanded(child: _buildGenderButton("Female", Icons.female)),
                      ],
                    ),
                    const SizedBox(height: 30),

                    _buildDropdown("Religion", _selectedReligion,
                        ["Hindu", "Muslim", "Christian", "Sikh", "Other"],
                            (val) => setState(() => _selectedReligion = val)),
                    const SizedBox(height: 20),

                    _buildTextField(_casteController, "Caste", Icons.account_balance),
                    const SizedBox(height: 20),
                    _buildTextField(_subCasteController, "Sub Caste", Icons.people),
                    const SizedBox(height: 20),

                    _buildDropdown("Marry Outside", _selectedMarryOutside,
                        ["Yes", "No"],
                            (val) => setState(() => _selectedMarryOutside = val)),
                    const SizedBox(height: 20),

                    _buildDropdown("Income", _selectedIncome, [
                      "Up to ₹2 Lakh",
                      "₹2-5 Lakh",
                      "₹5-10 Lakh",
                      "₹10-20 Lakh",
                      "₹20 Lakh+"
                    ], (val) => setState(() => _selectedIncome = val)),
                    const SizedBox(height: 20),

                    _buildDropdown("Family Type", _selectedFamilyType,
                        ["Joint Family", "Nuclear Family"],
                            (val) => setState(() => _selectedFamilyType = val)),
                    const SizedBox(height: 20),

                    _buildDropdown("Marital Status", _selectedMaritalStatus,
                        ["Never Married", "Divorced", "Widowed"],
                            (val) => setState(() => _selectedMaritalStatus = val)),
                    const SizedBox(height: 20),

                    _buildTextField(_heightController, "Height (cm)", Icons.height,
                        keyboardType: TextInputType.number),
                    const SizedBox(height: 20),

                    _buildTextField(_occupationController, "Occupation", Icons.work),
                    const SizedBox(height: 20),
                    _buildTextField(_educationController, "Education", Icons.school),
                    const SizedBox(height: 20),
                    _buildTextField(_cityController, "City", Icons.location_city),
                    const SizedBox(height: 20),
                    _buildTextField(_bioController, "Bio", Icons.description, maxLines: 3),
                    const SizedBox(height: 40),

                    // Save button
                    _buildSaveButton(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageHeader() {
    String? imagePath = widget.profileData['Complexion'] as String?;
    ImageProvider? imageProvider;
    if (_pickedImage != null) {
      imageProvider = FileImage(_pickedImage!);
    } else if (imagePath != null && imagePath.isNotEmpty) {
      imageProvider = imagePath.startsWith('http')
          ? NetworkImage(imagePath) as ImageProvider
          : FileImage(File(imagePath)) as ImageProvider;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30),
      color: Colors.white,
      child: Center(
        child: GestureDetector(
          onTap: _pickImage,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[200],
                  border: Border.all(
                    color: primaryColor,
                    width: 4,
                  ),
                ),
                child: imageProvider != null
                    ? ClipOval(
                  child: Image(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                )
                    : Icon(Icons.person, size: 80, color: Colors.grey[400]),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon,
      {TextInputType keyboardType = TextInputType.text,
        bool readOnly = false,
        VoidCallback? onTap,
        int maxLines = 1}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: primaryColor),
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
    );
  }

  Widget _buildGenderButton(String gender, IconData icon) {
    bool isSelected = _selectedGender == gender;
    return GestureDetector(
      onTap: () => setState(() => _selectedGender = gender),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? secondaryColor.withOpacity(0.4) : Colors.white,
          border: Border.all(
            color: isSelected ? primaryColor : Colors.grey[400]!,
            width: 1.2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: isSelected ? primaryColor : Colors.grey[600]),
              const SizedBox(width: 8),
              Text(
                gender,
                style: TextStyle(
                  color: isSelected ? primaryColor : Colors.black,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, String? value, List<String> items, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(Icons.arrow_drop_down_circle, color: primaryColor),
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
      items: items.map((item) => DropdownMenuItem(value: item, child: Text(item, style: const TextStyle(color: Color(0xFF6B4226))))).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          colors: [primaryColor, secondaryColor],
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
        onPressed: () async {
          final profileData = {
            "Id": widget.profileData['Id'],
            "Name": _fullNameController.text,
            "Age": int.tryParse(_ageController.text) ?? 0,
            "DOB": _dobController.text,
            "Email": _emailController.text,
            "Gender": _selectedGender ?? "",
            "Religion": _selectedReligion ?? "",
            "Caste": _casteController.text,
            "SubCaste": _subCasteController.text,
            "MarryOutside": _selectedMarryOutside ?? "",
            "Income": _selectedIncome ?? "",
            "FamilyType": _selectedFamilyType ?? "",
            "MaritalStatus": _selectedMaritalStatus ?? "",
            "Height": double.tryParse(_heightController.text) ?? 0.0,
            "Complexion": _pickedImage?.path ?? widget.profileData['Complexion'],
            "Occupation": _occupationController.text,
            "Education": _educationController.text,
            "City": _cityController.text,
            "Bio": _bioController.text,
          };

          // Use the updateProfile method
          final rowsAffected = await MyDataBase.instance.updateProfile(profileData['Id'], profileData);

          if (rowsAffected > 0) {
            // After successful update, fetch the updated profile data from the database
            final updatedProfile = await MyDataBase.instance.getProfileById(profileData['Id']);
            final allUsers = await MyDataBase.instance.getAllProfiles();

            if (updatedProfile != null) {
              // Get the username and password to pass to the DashboardScreen
              final loggedUser = await MyDataBase.instance.getLoggedUserByEmail(updatedProfile['Email']);
              if (loggedUser != null && mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => Dashboardscreen(
                      users: allUsers,
                      username: loggedUser['UserName'],
                      password: loggedUser['Password'],
                      profileData: updatedProfile,
                    ),
                  ),
                );
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Failed to get updated profile data.')),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to update profile.')),
            );
          }
        },
        child: const Text("Save & Continue",
            style: TextStyle(fontSize: 18, color: Colors.white)),
      ),
    );
  }
}