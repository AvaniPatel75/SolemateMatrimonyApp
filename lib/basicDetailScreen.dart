import 'dart:io';

import 'package:flutter/material.dart';
import 'package:login_screen/dashboardScreen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:login_screen/database.dart';
import '../database.dart';

class Basicdetailscreen extends StatefulWidget {
  final String username;
  final String password;
  // ⭐ NEW: Add email parameter
  final String email;

  const Basicdetailscreen({
    Key? key,
    required this.username,
    required this.password,
    required this.email, // Add this line
  }) : super(key: key);

  @override
  _BasicdetailscreenState createState() => _BasicdetailscreenState();
}

class _BasicdetailscreenState extends State<Basicdetailscreen> {
  final List<Map<String, dynamic>> users = [];

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

  final Color primaryColor = const Color(0xFFFB6F92);
  final Color secondaryColor = const Color(0xFFFF8FAB);
  final Color textColor = const Color(0xFF6B4226);

  // ⭐ MODIFIED: Initialize state with email and DOB listener
  @override
  void initState() {
    super.initState();
    _emailController.text = widget.email; // Autopopulate email
    _dobController.addListener(_updateAgeFromDob); // Add listener for DOB
  }

  // ⭐ NEW: Dispose controllers
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

  // ⭐ NEW: Function to update age
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
      // Handle parsing errors
      print("Error parsing date: $e");
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    final MyDataBase db = MyDataBase.instance;

    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // 🔝 Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: const [
                    SizedBox(height: 40),
                    Text("All Details",
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFFFB6F92))),
                    Text("Please provide all your information",
                        style: TextStyle(fontSize: 16, color: Colors.grey)),
                    SizedBox(height: 30),
                  ],
                ),
              ),

              // 🔽 Form Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(_fullNameController, "Full Name", Icons.person),
                    const SizedBox(height: 20),
                    // ⭐ MODIFIED: Make Age field read-only
                    _buildTextField(_ageController, "Age", Icons.calendar_today,
                        keyboardType: TextInputType.number, readOnly: true),
                    const SizedBox(height: 20),
                    _buildTextField(_dobController, "Date of Birth (dd/mm/yyyy)", Icons.date_range,
                        readOnly: true, onTap: _pickDate),
                    const SizedBox(height: 20),
                    // ⭐ MODIFIED: Make Email field read-only
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

                    _buildImagePickerField(),
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
                    Container(
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
                            "Complexion": _pickedImage?.path ?? "https://i.pravatar.cc/150",
                            "Occupation": _occupationController.text,
                            "Education": _educationController.text,
                            "City": _cityController.text,
                            "Bio": _bioController.text,
                          };

                          await MyDataBase.instance.insertUserInUserDetails(profileData);

                          final users = await MyDataBase.instance.getAllProfiles();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Dashboardscreen(
                                users: users,
                                username: widget.username,
                                password: widget.password,
                                profileData: profileData,
                              ),
                            ),
                          );
                        },
                        child: const Text("Save & Continue",
                            style: TextStyle(fontSize: 18, color: Colors.white)),
                      ),
                    ),
                  ],
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
      items: items.map((item) => DropdownMenuItem(value: item, child: Text(item, style: TextStyle(color: textColor)))).toList(),
      onChanged: onChanged,
    );
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
      _dobController.text =
      "${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}";
      // ⭐ MODIFIED: Manually trigger age update after setting DOB
      _updateAgeFromDob();
    }
  }

  Widget _buildImagePickerField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Profile Picture",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        Center(
          child: Column(
            children: [
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: primaryColor,
                    width: 2,
                  ),
                ),
                child: _pickedImage != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    _pickedImage!,
                    fit: BoxFit.cover,
                  ),
                )
                    : Icon(Icons.person, size: 80, color: Colors.grey[400]),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.add_a_photo, color: Colors.white),
                label: const Text("Upload Profile Photo", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}