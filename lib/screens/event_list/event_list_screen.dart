import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hediaty_sec/models/local_db/event_local_db.dart';
import 'package:hediaty_sec/providers/theme_provider.dart';
import 'package:hediaty_sec/screens/Event_details/event_details_screen.dart';
import 'package:hediaty_sec/screens/event_list/draft_event_list_controller.dart';
import 'package:hediaty_sec/screens/event_list/event_list_controller.dart';
import 'package:provider/provider.dart';

import 'package:hediaty_sec/models/data/Event.dart';


class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}
class _EventListScreenState extends State<EventListScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  // Fetch events
  Future<void> _fetchEvents() async {
    await EventListController.instance.getEventList();  // Fetch events from remote or local DB
    setState(() {
      isLoading = false;
    });
  }

  // Refresh events
  Future<void> _onRefresh() async {
    setState(() {
      isLoading = true;
    });
    await _fetchEvents();
  }

  // Show drafts in a bottom sheet
  void _showDraftsBottomSheet() async {
    final draftEvents = await DraftEventListController.instance.fetchLocalDraftEvents();

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Drafts',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: draftEvents.length,
                itemBuilder: (context, index) {
                  final draftEvent = draftEvents[index];
                  return ListTile(
                    title: Text(draftEvent.name),
                  );
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  List<Map<String, dynamic>> draftEventsMap = [];
                  for (var event in draftEvents) {
                    draftEventsMap.add(event.toMap());
                  }
                  EventMethodsLocal().pushEventsToRemoteDB(draftEventsMap);
                },
                child: Text('Push to remote'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final events = EventListController.instance.eventList;

    return Scaffold(
      backgroundColor: context.watch<theme>().dark
          ? CupertinoColors.darkBackgroundGray
          : CupertinoColors.extraLightBackgroundGray,
      appBar: AppBar(
        title: Text('Events'),
        actions: [
          IconButton(
            icon: Icon(Icons.drafts),
            onPressed: _showDraftsBottomSheet,
          ),
        ],
      ),
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
                    builder: (context) => EventDetailsScreen(event: event),
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
