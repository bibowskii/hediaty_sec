import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hediaty_sec/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  DateTime _selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.watch<theme>().dark
          ? CupertinoColors.darkBackgroundGray
          : CupertinoColors.extraLightBackgroundGray,
      body: Column(
        children: [
          CalendarDatePicker(
              initialDate: _selectedDate,
              firstDate: DateTime(_selectedDate.year, _selectedDate.month),
              lastDate:
                  DateTime(_selectedDate.year, _selectedDate.month + 1, 0),
              onDateChanged: (DateTime newDate) {
                setState(() {
                  _selectedDate = newDate;
                });
              }),
        ],
      ),
    );
  }
}
