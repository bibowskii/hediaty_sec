import 'package:flutter/material.dart';
import 'package:hediaty_sec/models/data/Event.dart';
import 'package:hediaty_sec/screens/Event_details/event_details_controller.dart';

class EventDetailsScreen extends StatelessWidget {
  final Event event;
  const EventDetailsScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event.name),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/editEvent', arguments: event);
            },
            icon: Icon(Icons.edit),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            child: Column(
              children: [
                Container(
                  child: Text(event.description),
                ),
                Container(
                  child: Text(event.date.toString()),
                ),
                Container(
                  child: Text(event.location),
                ),
              ],
            ),
          ),
          Positioned(
            top: 300,
            child: Wrap(
              children: [
                ...EventDetailsController.instance.gifts
                    .map(
                      (gift) => Chip(
                        label: Text(gift.name),
                      ),
                    )
                    .toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
