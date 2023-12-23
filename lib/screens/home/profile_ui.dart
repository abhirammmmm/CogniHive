import 'package:flutter/material.dart';

class ProfileUI extends StatefulWidget {
  @override
  _ProfileUIState createState() => _ProfileUIState();
}

class _ProfileUIState extends State<ProfileUI> {
  bool isEditing = false;
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  TextEditingController _collegeController = TextEditingController();
  String _selectedGender = 'Male'; // Default value

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30.0),
            Text(
              'User Profile',
              style: TextStyle(
                fontSize: 35.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            buildForm('First Name', _firstNameController),
            buildForm('Last Name', _lastNameController),
            buildForm('Phone Number', _phoneController),
            buildDatePickerForm('Date of Birth', _dobController),
            buildForm('College', _collegeController),
            buildGenderDropdown(),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isEditing = !isEditing;
                });
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 125), // Adjust the horizontal padding
                backgroundColor: Color(0xFFE46831), // Use the orange color
              ),
              child: Text(
                isEditing ? 'Save Profile' : 'Edit Profile',
                style: TextStyle(fontSize: 16), // Adjust the font size
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildForm(String labelText, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(fontSize: 14.0),
        ),
        SizedBox(height: 4.0),
        TextFormField(
          controller: controller,
          enabled: isEditing,
        ),
        SizedBox(height: 16.0),
      ],
    );
  }

  Widget buildDatePickerForm(String labelText, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(fontSize: 14.0),
        ),
        SizedBox(height: 4.0),
        InkWell(
          onTap: isEditing
              ? () async {
            DateTime? date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );

            if (date != null && date != DateTime.now()) {
              // Format the date as per your requirement
              String formattedDate = "${date.day}-${date.month}-${date.year}";
              controller.text = formattedDate;
            }
          }
              : null,
          child: IgnorePointer(
            ignoring: true,
            child: TextFormField(
              controller: controller,
            ),
          ),
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
          style: TextStyle(fontSize: 14.0),
        ),
        SizedBox(height: 4.0),
        DropdownButton<String>(
          value: _selectedGender,
          items: ['Male', 'Female', 'Prefer not to say'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: isEditing
              ? (String? value) {
            setState(() {
              _selectedGender = value!;
            });
          }
              : null,
        ),
        SizedBox(height: 16.0),
      ],
    );
  }
}
