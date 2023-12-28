import 'package:flutter/material.dart';

class CreateEventPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''), // Empty text to remove the app bar text
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFF1E2832)), // Menu icon color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: EventForm(),
      ),
      endDrawer: buildDrawer(context), // Drawer on the right side
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
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 35),
          Text(
            'Create an Event',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w300),
          ),
          SizedBox(height: 25),
          TextFormField(
            controller: eventNameController,
            decoration: InputDecoration(labelText: 'Name of the Event'),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter the event name';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: descriptionController,
            decoration: InputDecoration(labelText: 'Description'),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter the description';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Date'),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => _selectDate(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF696969),
                ),
                child: Text(selectedDate == null
                    ? 'Select Date'
                    : 'Selected Date: ${_formatDate(selectedDate!)}'),
              ),
              if (selectedDate == null)
                const Text(
                  'Please select a date',
                  style: TextStyle(color: Colors.red),
                ),
              SizedBox(height: 16),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Time'),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => _selectTime(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF696969),
                ),
                child: Text(selectedTime == null
                    ? 'Select Time'
                    : 'Selected Time: ${_formatTime(selectedTime!)}'),
              ),
              if (selectedTime == null)
                Text(
                  'Please select a time',
                  style: TextStyle(color: Colors.red),
                ),
              SizedBox(height: 16),
            ],
          ),
          SizedBox(height: 16),
          TextFormField(
            decoration: InputDecoration(labelText: 'Event Location'),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter event location';
              }
              return null;
            },
          ),
          SizedBox(height: 60),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate() &&
                  selectedDate != null &&
                  selectedTime != null) {
                // Form is valid, continue with your logic
                // e.g., save the event details or navigate to the next page
                // You can access form fields using eventNameController.text, descriptionController.text, etc.
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFE46821),
              minimumSize: Size(325, 45),
            ),
            child: Text(
              'Continue',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTime(TimeOfDay time) {
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '${time.hourOfPeriod}:${time.minute} $period';
  }
}
