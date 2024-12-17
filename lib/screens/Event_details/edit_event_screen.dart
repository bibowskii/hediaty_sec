import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hediaty_sec/models/data/Event.dart';
import 'package:hediaty_sec/models/domain/event_methods.dart';
import 'package:hediaty_sec/providers/theme_provider.dart';
import 'package:hediaty_sec/services/user_manager.dart';
import 'package:hediaty_sec/widgets/textField.dart';
import 'package:provider/provider.dart';

class EditEventScreen extends StatefulWidget {
  Event myEvent;
   EditEventScreen({super.key, required this.myEvent});

  @override
  State<EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  late DateTime _selectedDate;
  TextEditingController eventNameController = TextEditingController();
  TextEditingController eventDescriptionController = TextEditingController();
  TextEditingController eventLocationController = TextEditingController();
  TextEditingController eventTimeController = TextEditingController();
  String? _selectedEventCategory;


  @override
  void initState() {
    _selectedDate = widget.myEvent.date;
    eventNameController.text = widget.myEvent.name;
    eventDescriptionController.text = widget.myEvent.description!;
    eventLocationController.text = widget.myEvent.location!;
    _selectedEventCategory = widget.myEvent.category;
    super.initState();
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

                    SizedBox(height: 20),
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
                          '1',
                          eventLocationController.text,
                          // user manager removed for testing methods, it works when u sign in from the beginning
                          UserManager().getUserId()!,
                          _selectedEventCategory.toString(),
                        );
                        await eventMethods().editEvent(event);
                        SnackBar snackBar = SnackBar(
                          content: Text('Event Edited Successfully!'),
                          backgroundColor: Colors.green,
                        );
                        // Navigate to event page details later
                      },
                      child: Text('Update Event'),
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
