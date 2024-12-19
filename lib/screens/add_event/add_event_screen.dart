import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hediaty_sec/models/data/Event.dart';
import 'package:hediaty_sec/models/domain/event_methods.dart';
import 'package:hediaty_sec/models/local_db/db_helper.dart';
import 'package:hediaty_sec/models/local_db/event_local_db.dart';
import 'package:hediaty_sec/providers/theme_provider.dart';
import 'package:hediaty_sec/screens/Event_details/event_details_screen.dart';
import 'package:hediaty_sec/services/user_manager.dart';
import 'package:hediaty_sec/widgets/textField.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../models/data/collections.dart';

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
  String? _selectedEventCategory;

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
    final List<String> _eventCategories = [
      'Conference',
      'Workshop',
      'Birthday Party',
      'Wedding',
      'Concert',
      'Sports Event',
      'Festival',
    ];

    // Selected category




    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                    SizedBox(height: 20,),

                    DropdownButton<String>(
                      value: _selectedEventCategory,
                      hint: Text('Select an event category'),
                      isExpanded: true, // Makes the dropdown fill the available width
                      items: _eventCategories.map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedEventCategory = newValue;
                        });
                      },
                    ),


                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        Event event = Event(
                          eventNameController.text,
                          eventDescriptionController.text,
                          _selectedDate,
                          Uuid().v1(),
                          eventLocationController.text,
                          UserManager().getUserId()!,
                            _selectedEventCategory.toString(),
                        );
                        await eventMethods().createEvent(event);
                        SnackBar snackBar = SnackBar(
                          content: Text('Event Created Successfully!'),
                          backgroundColor: Colors.green,
                        );
                        Navigator.push(context, MaterialPageRoute(builder: (context) => EventDetailsScreen(event: event)));
                        // Navigate to event page details later
                      },
                      child: Text('Add Event'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        Event event = Event(
                          eventNameController.text,
                          eventDescriptionController.text,
                          _selectedDate,
                          Uuid().v1(),
                          eventLocationController.text,
                          UserManager().getUserId()!,
                          _selectedEventCategory.toString(),
                        );
                        await EventMethodsLocal().createEvent(event);
                        SnackBar snackBar = SnackBar(
                          content: Text('Event Saved Successfully!'),
                          backgroundColor: Colors.green,
                        );
                      },
                      child: Text('Save Event as a draft'),
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
