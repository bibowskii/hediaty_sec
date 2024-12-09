import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hediaty_sec/models/data/Event.dart';
import 'package:hediaty_sec/models/domain/event_methods.dart';
import 'package:hediaty_sec/providers/theme_provider.dart';
import 'package:hediaty_sec/services/user_manager.dart';
import 'package:hediaty_sec/widgets/textField.dart';
import 'package:provider/provider.dart';

class addEventScreen extends StatefulWidget {
  const addEventScreen({super.key});

  @override
  State<addEventScreen> createState() => _addEventScreenState();
}

class _addEventScreenState extends State<addEventScreen> {
  DateTime _selectedDate = DateTime.now();
  TextEditingController eventNameController = TextEditingController();
  TextEditingController eventDescriptionController = TextEditingController();
  TextEditingController eventLocationController = TextEditingController();
  TextEditingController eventTimeController = TextEditingController();

  @override
  void dispose() {
    eventNameController.dispose();
    eventDescriptionController.dispose();
    eventLocationController.dispose();
    eventTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Ensures the screen resizes when the keyboard opens
      backgroundColor: context.watch<theme>().dark
          ? CupertinoColors.darkBackgroundGray
          : CupertinoColors.extraLightBackgroundGray,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: CalendarDatePicker(
                  initialDate: _selectedDate,
                  firstDate: DateTime(_selectedDate.year, _selectedDate.month),
                  lastDate: DateTime(9999, 12, 31),
                  //lastDate: DateTime(_selectedDate.year, _selectedDate.month + 1, 0),
                  onDateChanged: (DateTime newDate) {
                    setState(() {
                      _selectedDate = newDate;
                    });
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    CustomTextField(
                      hintText: 'Name of the Event',
                      icon: Icons.event,
                      isObsecure: false,
                      controller: eventNameController,
                    ),
                    CustomTextField(
                      hintText: 'Description',
                      icon: Icons.description_outlined,
                      isObsecure: false,
                      controller: eventDescriptionController,
                    ),
                    CustomTextField(
                      hintText: 'Location',
                      icon: CupertinoIcons.location_solid,
                      isObsecure: false,
                      controller: eventLocationController,
                    ),
                    CustomTextField(
                      hintText: 'Time',
                      icon: CupertinoIcons.clock,
                      isObsecure: false,
                      controller: eventTimeController,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        Event event = Event(
                          eventNameController.text,
                          eventDescriptionController.text,
                          _selectedDate,
                          '1',
                          eventLocationController.text,

                            // user manager removed for testing methods, it works when u sign in from the beginning
                          UserManager().getUserId()!,
                        );
                        await eventMethods().createEvent(event);
                        SnackBar snackBar = SnackBar(
                          content: Text('Event Created Successfully!'),
                          backgroundColor: Colors.green,


                        );
                        // Navigate to event page details later
                      },
                      child: Text('Add Event'),
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
}
