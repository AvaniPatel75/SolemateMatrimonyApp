import 'package:flutter/material.dart';

class Personaldetailscreen extends StatefulWidget {
  const Personaldetailscreen({super.key});

  @override
  State<Personaldetailscreen> createState() => _PersonaldetailscreenState();
}

class _PersonaldetailscreenState extends State<Personaldetailscreen> {
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
                    'Please provide your personal details:',
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
                  child: _buildMaritalStatusDropdown(),
                ),
                SizedBox(height: 16),

                // Will you want to marry outside caste tick box
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0), // Adjust padding for checkbox
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'no of children',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),

                // Caste Text Field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text("is children living with you"),
                ),
                SizedBox(height: 40),

                // Sub Caste Text Field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text("Height"),
                ),
                SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text("Family Status"),
                ),
                SizedBox(height: 40.0,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text("Family Type"),
                ),
                // Continue Button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Collect data from this page
                      // print('Selected Religion: $_selectedReligion');
                      // print('Willing to marry outside caste: $_marryOutsideCaste');
                      // print('Caste: ${_casteController.text}');
                      // print('Sub Caste: ${_subCasteController.text}');


                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => const PersonalDetailsScreen()),
                      // );
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
}
Widget _buildMaritalStatusDropdown(){
  return Text("Marital");
}