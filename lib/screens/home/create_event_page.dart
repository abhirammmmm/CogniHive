// ignore_for_file: prefer_const_constructors, prefer_final_fields, library_private_types_in_public_api, avoid_print, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, deprecated_member_use

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateEventPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Event'),
        centerTitle: true,
        backgroundColor: Colors.black87,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: EventForm(),
      ),
      endDrawer: buildDrawer(context),
    );
  }

  Widget buildDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        color: Color(0xFFD9D9D9),
        child: Column(
          children: [
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.orange,
                  ),
                  onPressed: () {
                    Navigator.pop(context); // Close the drawer
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.transparent, // Transparent to create space
                  ),
                  onPressed: () {}, // Dummy onPressed
                ),
              ],
            ),
            SizedBox(height: 100),
            buildDrawerItem(context, 'Profile', '/profilePage'),
            SizedBox(height: 50),
            buildDrawerItem(context, 'Your Events', '/yourEventsPage'),
            SizedBox(height: 380),
            buildDrawerItem(context, 'Logout', '/logoutPage'),
          ],
        ),
      ),
    );
  }

  Widget buildDrawerItem(BuildContext context, String title, String route) {
    return SizedBox(
      height: 40,
      width: 180, // Set a fixed height for all buttons
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, route);
        },
        style: ElevatedButton.styleFrom(
          primary: title == 'Logout' ? Colors.red : Color(0xFF1E2832),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ),
    );
  }
}

class EventForm extends StatefulWidget {
  @override
  _EventFormState createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController eventNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildTextFormField('Name of the Event', eventNameController),
          buildTextFormField('Description', descriptionController),
          if (errorMessage != null) // Display error message if not null
            Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Text(
                errorMessage!,
                style: TextStyle(color: Colors.red, fontSize: 14),
              ),
            ),
          buildDateField(),
          buildTimeField(),
          buildTextFormField('Event Location', locationController),
          SizedBox(height: 25),
          ElevatedButton(
            onPressed: _submitForm,
            style: ElevatedButton.styleFrom(
              primary: Colors.orange[800],
              padding: EdgeInsets.symmetric(vertical: 12),
            ),
            child: Text('Create Event', style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }

  void _submitForm() {
    setState(() {
      errorMessage = null; // Reset error message
    });

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (selectedDate == null || selectedTime == null) {
      setState(() {
        errorMessage = 'Please select date and time';
      });
      return;
    }

    DateTime now = DateTime.now();
    DateTime selectedDateTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );

    if (selectedDateTime.isBefore(now)) {
      setState(() {
        errorMessage = 'Cannot select a past date and time';
      });
      return;
    }

    if (selectedDateTime.difference(now).inHours < 1) {
      setState(() {
        errorMessage = 'Event must be at least 1 hour ahead';
      });
      return;
    }

    // Rest of the code for Firestore submission
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      print("No user logged in");
      return;
    }

    String eventUID =
        "${selectedDateTime.millisecondsSinceEpoch}${Random().nextInt(999)}"; // Generate a unique event UID
    String formattedDate = _formatDate(selectedDateTime);
    String formattedTime = _formatTime(selectedTime!);

    FirebaseFirestore.instance.collection('events').doc(eventUID).set({
      'createdBy': currentUser.uid,
      'date': formattedDate,
      'description': descriptionController.text,
      'eventName': eventNameController.text,
      'eventUID': eventUID,
      'location': locationController.text,
      'time': formattedTime,
    }).then((_) {
      print("Event successfully created");
      Navigator.pushNamed(context, '/homepage');
    }).catchError((error) {
      print("Failed to create event: $error");
    });
  }

  Widget buildTextFormField(String label, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  Widget buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Date',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        ElevatedButton(
          onPressed: () => _selectDate(context),
          style: ElevatedButton.styleFrom(
            primary: Colors.orange[800],
          ),
          child: Text(selectedDate == null
              ? 'Select Date'
              : 'Selected Date: ${_formatDate(selectedDate!)}'),
        ),
        if (selectedDate == null)
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text('Please select a date',
                style: TextStyle(color: Colors.red)),
          ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget buildTimeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Time',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        ElevatedButton(
          onPressed: () => _selectTime(context),
          style: ElevatedButton.styleFrom(
            primary: Colors.orange[800],
          ),
          child: Text(selectedTime == null
              ? 'Select Time'
              : 'Selected Time: ${_formatTime(selectedTime!)}'),
        ),
        if (selectedTime == null)
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text('Please select a time',
                style: TextStyle(color: Colors.red)),
          ),
      ],
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  String _formatTime(TimeOfDay time) {
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '${time.hourOfPeriod}:${time.minute.toString().padLeft(2, '0')} $period';
  }
}