import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'drawer_item.dart';
import 'package:url_launcher/url_launcher.dart';

class CreateEventPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Event', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.black87,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: EventForm(),
      ),
      endDrawer: CustomDrawer(
        onThemeChanged: (themeMode) {},
      ),
    );
  }
}

class EventForm extends StatefulWidget {
  get eventData => null;

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
          if (errorMessage != null)
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
              backgroundColor: Colors.orange[800],
              padding: EdgeInsets.symmetric(vertical: 12),
            ),
            child: Text('Create Event',
                style: TextStyle(color: Colors.white, fontSize: 18)),
          ),
        ],
      ),
    );
  }

  void _submitForm() async {
    setState(() {
      errorMessage = null;
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

    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      print("No user logged in");
      return;
    }

    String eventUID =
        "${selectedDateTime.millisecondsSinceEpoch}${Random().nextInt(999)}";
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
      'eventNameLower': eventNameController.text.toLowerCase(),
    }).then((_) async {
      print("Event successfully created");
      await launchGoogleCalendar();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
              "Your event has been created successfully!",
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
            backgroundColor: Colors.orange[800],
          ),
          child: Text(
            selectedDate == null
                ? 'Select Date'
                : 'Selected Date: ${_formatDate(selectedDate!)}',
            style: TextStyle(color: Colors.white),
          ),
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
            backgroundColor: Colors.orange[800],
          ),
          child: Text(
            selectedTime == null
                ? 'Select Time'
                : 'Selected Time: ${_formatTime(selectedTime!)}',
            style: TextStyle(color: Colors.white),
          ),
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

  String _formatGoogleCalendarDate(DateTime dateTime) {
    String year = dateTime.year.toString();
    String month = dateTime.month.toString().padLeft(2, '0');
    String day = dateTime.day.toString().padLeft(2, '0');

    return '$year$month$day';
  }

  String _formatGoogleCalendarTime(TimeOfDay time) {
    String hour = time.hour.toString().padLeft(2, '0');
    String minute = time.minute.toString().padLeft(2, '0');

    return '$hour$minute';
  }

  Future <void> launchGoogleCalendar() async {
    String eventName = eventNameController.text ?? 'Your Event Name';
    String eventDescription = descriptionController.text ?? 'Your Event Description';
    String eventDate = _formatDate(selectedDate!) ?? '';
    String eventTime = _formatTime(selectedTime!) ?? '';
    String eventLocation = locationController.text ?? ''; // Add this line

    print('Event Date: $eventDate');
    print('Event Time: $eventTime');
    print('Event Location: $eventLocation');

    if (eventDate.isEmpty || eventTime.isEmpty) {
      print('Invalid date or time format.');
      return;
    }

    DateTime eventDateTime = DateFormat('d/M/yyyy h:mm a').parse('$eventDate $eventTime');

    String formattedDate = DateFormat('yyyyMMddTHHmmss').format(eventDateTime);

    String googleCalendarUrl =
        'https://www.google.com/calendar/render?action=TEMPLATE&text=$eventName&details=$eventDescription&location=$eventLocation&dates=$formattedDate/$formattedDate';

    try {
      await launch(googleCalendarUrl);
    } catch (e) {
      print('Could not launch Google Calendar: $e');
    }
  }
}

void launchUrl(Uri parse) {}
