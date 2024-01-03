// ignore_for_file: prefer_const_constructors, prefer_final_fields, library_private_types_in_public_api, avoid_print, prefer_const_constructors_in_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cognihive_version1/models/user_data.dart';
import 'package:cognihive_version1/screens/home/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileUI extends StatefulWidget {
  final UserData? initialData;

  ProfileUI({Key? key, this.initialData}) : super(key: key);

  @override
  _ProfileUIState createState() => _ProfileUIState();
}

class _ProfileUIState extends State<ProfileUI> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  String _selectedGender = 'Male'; // Default value
  String _selectedCollege = 'BTH'; // Default value

  bool _isChanged = false;
  bool _isLoadingData = true;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    fetchUserProfile();
    if (widget.initialData != null) {
      _firstNameController.text = widget.initialData!.firstName;
      _lastNameController.text = widget.initialData!.lastName;
      _phoneController.text = widget.initialData!.phoneNumber;
      _dobController.text = widget.initialData!.dateOfBirth;
      _selectedGender = widget.initialData!.gender;
      _selectedCollege = widget.initialData!.college;
    }
  }

  @override
  void dispose() {
    // Dispose controllers and remove listeners
    _firstNameController.removeListener(_onFieldChanged);
    _lastNameController.removeListener(_onFieldChanged);
    _phoneController.removeListener(_onFieldChanged);
    _dobController.removeListener(_onFieldChanged);
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  void _initializeControllers() {
    _firstNameController.addListener(_onFieldChanged);
    _lastNameController.addListener(_onFieldChanged);
    _phoneController.addListener(_onFieldChanged);
    _dobController.addListener(_onFieldChanged);
    // No need to add listeners to dropdowns as onChanged will handle it
  }

  void _onFieldChanged() {
    if (!_isLoadingData && !_isChanged) {
      setState(() {
        _isChanged = true;
      });
    }
  }

  Future<void> fetchUserProfile() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        DocumentSnapshot userDocument = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();
        if (userDocument.exists) {
          Map<String, dynamic> userData =
              userDocument.data() as Map<String, dynamic>;
          _firstNameController.text = userData['firstName'] ?? '';
          _lastNameController.text = userData['lastName'] ?? '';
          _phoneController.text = userData['phoneNumber'] ?? '';
          _dobController.text = userData['dateOfBirth'] ?? '';
          _selectedGender = userData['gender'] ?? 'Male';
          _selectedCollege = userData['college'] ?? 'BTH';
          setState(() {
            _isLoadingData = false; // Data loading complete
          });
        }
      } catch (e) {
        print('Error fetching user data: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(27.0), // Adjust the height as needed
        child: AppBar(
          title: const Text(''), // Empty text to remove the app bar text
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : const Color(0xFF1E2832),
          ), // Menu icon color
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: 0.0),
              Text(
                'User Profile',
                style: TextStyle(fontSize: 35.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              buildForm('First Name', _firstNameController),
              buildForm('Last Name', _lastNameController),
              buildForm('Phone Number', _phoneController),
              buildDatePickerForm('Date of Birth', _dobController),
              buildGenderDropdown(),
              buildCollegeDropdown(),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _isChanged
                    ? _saveProfile
                    : null, // Enable button if changes are detected
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  backgroundColor: Color(0xFFE46831),
                ),
                child: Text('Save Profile',
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Other buildForm, buildDatePickerForm, and buildGenderDropdown methods remain the same

  Widget buildCollegeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('College', style: TextStyle(fontSize: 14.0)),
        SizedBox(height: 4.0),
        DropdownButtonFormField<String>(
          value: _selectedCollege,
          items: [
            'BTH',
            'KTH',
            'Chalmers University of Technology',
            'Uppsala University'
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedCollege = newValue!;
            });
          },
          validator: (value) =>
              value == null ? 'Please select a college' : null,
        ),
        SizedBox(height: 10.0),
      ],
    );
  }

  Widget buildGenderDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender',
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        DropdownButtonFormField<String>(
          value: _selectedGender,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          items: <String>['Male', 'Female', 'Prefer not to say']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedGender = newValue!;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a gender';
            }
            return null;
          },
        ),
        SizedBox(height: 10.0),
      ],
    );
  }

  Widget buildDatePickerForm(
      String labelText, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        InkWell(
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (pickedDate != null) {
              String formattedDate =
                  "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
              setState(() {
                controller.text =
                    formattedDate; // Update the text of the controller
              });
            }
          },
          child: IgnorePointer(
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Select your date of birth',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select your date of birth';
                }
                return null;
              },
            ),
          ),
        ),
        SizedBox(height: 10.0),
      ],
    );
  }

  Widget buildForm(String labelText, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: labelText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter $labelText';
            }
            return null;
          },
        ),
        SizedBox(height: 10.0),
      ],
    );
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // Print values
      print('First Name: ${_firstNameController.text}');
      print('Last Name: ${_lastNameController.text}');
      print('Phone Number: ${_phoneController.text}');
      print('Date of Birth: ${_dobController.text}');
      print('Gender: $_selectedGender');
      print('College: $_selectedCollege');
      if (_formKey.currentState!.validate()) {
        User? currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser == null || currentUser.uid.isEmpty) {
          print('Error: No user is currently signed in.');
          return;
        }

        FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .update({
          'displayName': _firstNameController.text,
          'firstName': _firstNameController.text,
          'lastName': _lastNameController.text,
          'phoneNumber': _phoneController.text,
          'dateOfBirth': _dobController.text,
          'gender': _selectedGender,
          'college': _selectedCollege,
          'profile_complete': true,
        }).then((value) {
          print('User profile updated.');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                  "Profile Updated!",
                  style: TextStyle(color: Colors.white),
                ),
                duration: Duration(seconds: 10),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                margin: EdgeInsets.all(10.0),
                padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
                elevation: 6.0,
                backgroundColor: Colors.green[400]),
          );
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePage()));
          // Optionally navigate the user away from the profile page
        }).catchError((error) {
          print('Error updating user profile: $error');
        });
      }
    }
  }
}
