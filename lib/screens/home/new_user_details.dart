import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cognihive_version1/models/user_data.dart';
import 'package:cognihive_version1/screens/home/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewUserDetails extends StatefulWidget {
  final UserData? initialData;

  NewUserDetails({Key? key, this.initialData}) : super(key: key);

  @override
  _NewUserDetailsState createState() => _NewUserDetailsState();
}

class _NewUserDetailsState extends State<NewUserDetails> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  String _selectedGender = 'Male'; // Default value
  String _selectedCollege = 'BTH'; // Default value

  @override
  void initState() {
    super.initState();
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: 30.0),
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
                onPressed: _finishProfile,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  backgroundColor: Color(0xFFE46831),
                ),
                child:
                    Text('Finish My Profile', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }


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
        SizedBox(height: 16.0),
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
        SizedBox(height: 16.0),
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
                    formattedDate;
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
        SizedBox(height: 16.0),
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
        SizedBox(height: 16.0),
      ],
    );
  }

  void _finishProfile() {
    if (_formKey.currentState!.validate()) {
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

      FirebaseFirestore.instance.collection('users').doc(currentUser.uid).update({
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
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
      }).catchError((error) {
        print('Error updating user profile: $error');
      });
    }
    }
  }
}




