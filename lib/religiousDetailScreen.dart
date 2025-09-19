// lib/religious_details_screen.dart
import 'package:flutter/material.dart';
import 'package:login_screen/personalDetailScreen.dart';

// Assuming you'll create these later, for now they are placeholders.
// import 'package:your_app_name/personal_details_screen.dart';

class ReligiousDetailsScreen extends StatefulWidget {
  const ReligiousDetailsScreen({super.key});

  @override
  State<ReligiousDetailsScreen> createState() => _ReligiousDetailsScreenState();
}

class _ReligiousDetailsScreenState extends State<ReligiousDetailsScreen> {
  String? _selectedReligion;
  bool _marryOutsideCaste = false; // State for the tick box
  final TextEditingController _casteController = TextEditingController();
  final TextEditingController _subCasteController = TextEditingController();

  @override
  void dispose() {
    _casteController.dispose();
    _subCasteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
        backgroundColor: Color(0xFFD9A299),
        elevation: 0,
      ),
      body: Builder(
        builder: (BuildContext context) {
          return SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top header section
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                  decoration: BoxDecoration(
                    color: Color(0xFFD9A299),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '2 of 5', // Updated progress
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Religion Details', // Updated title
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Next Step: Personal Details', // Updated next step
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),

                // Form content
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Please provide your religion details:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Religion Dropdown
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: _buildReligionDropdown(),
                ),
                SizedBox(height: 16),

                // Will you want to marry outside caste tick box
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0), // Adjust padding for checkbox
                  child: Row(
                    children: [
                      Checkbox(
                        value: _marryOutsideCaste,
                        onChanged: (bool? newValue) {
                          setState(() {
                            _marryOutsideCaste = newValue ?? false;
                          });
                        },
                        activeColor: Color(0xFFE53935), // Red color when checked
                      ),
                      Expanded(
                        child: Text(
                          'Willing to marry from other caste also',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),

                // Caste Text Field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: _buildTextField('Caste:', _casteController),
                ),
                SizedBox(height: 16),

                // Sub Caste Text Field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: _buildTextField('Sub Caste:', _subCasteController),
                ),
                SizedBox(height: 40),

                // Continue Button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Collect data from this page
                      print('Selected Religion: $_selectedReligion');
                      print('Willing to marry outside caste: $_marryOutsideCaste');
                      print('Caste: ${_casteController.text}');
                      print('Sub Caste: ${_subCasteController.text}');


                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Personaldetailscreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFD9A299),
                      padding: EdgeInsets.symmetric(horizontal: 80, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  // --- Helper Widgets (copied from Basicdetailscreen for consistency) ---
  Widget _buildTextField(String labelText, TextEditingController controller, {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.grey[700]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Color(0xFFE53935), width: 1.5),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
      style: TextStyle(fontSize: 16),
    );
  }

  Widget _buildReligionDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedReligion,
      hint: Text('Select Religion'), // Added a hint
      decoration: InputDecoration(
        labelText: 'Religion',
        labelStyle: TextStyle(color: Colors.grey[700]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Color(0xFFE53935), width: 1.5),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
      items: <String>['Hindu', 'Muslim', 'Christian', 'Sikh', 'Jain', 'Buddhist', 'Other']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedReligion = newValue;
        });
      },
    );
  }
}