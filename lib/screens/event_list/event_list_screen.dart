import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hediaty_sec/providers/theme_provider.dart';
import 'package:hediaty_sec/screens/Event_details/event_details_screen.dart';
import 'package:hediaty_sec/screens/event_list/event_list_controller.dart';
import 'package:provider/provider.dart';

class EventListScreen extends StatefulWidget {
  @override
  _EventListScreenState createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    await EventListController.instance.getEventList();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _onRefresh() async {
    setState(() {
      isLoading = true;
    });
    await _fetchEvents();
  }

  @override
  Widget build(BuildContext context) {
    final events = EventListController.instance.eventList;

    return Scaffold(
      backgroundColor: context.watch<theme>().dark
          ? CupertinoColors.darkBackgroundGray
          : CupertinoColors.extraLightBackgroundGray,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : events.isEmpty
          ? Center(child: Text('No events found'))
          : RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            return ListTile(
              leading: CircleAvatar(
                child: Icon(CupertinoIcons.gift),
              ),
              title: Text(event.name!),
              subtitle: Text(event.date!.toString()),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        EventDetailsScreen(event: event),
                  ),
                ).then((onValue) {
                  setState(() {});
                });
              },
            );
          },
        ),
      ),
    );
  }
}
