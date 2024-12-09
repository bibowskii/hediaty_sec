import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hediaty_sec/models/data/Event.dart';
import 'package:hediaty_sec/providers/theme_provider.dart';
import 'package:hediaty_sec/screens/Event_details/edit_event_screen.dart';
import 'package:hediaty_sec/screens/Event_details/event_details_controller.dart';
import 'package:provider/provider.dart';

class EventDetailsScreen extends StatefulWidget {
  final Event event;
  const EventDetailsScreen({super.key, required this.event});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  @override
  void initState(){
    super.initState();
    _fetchGifts();
  }

  Future<void> _fetchGifts() async{
    await EventDetailsController.instance.getGifts(widget.event);
    setState(() {});
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(widget.event.name),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditEventScreen(
                              myEvent: widget.event,
                            )));
              },
              icon: Icon(Icons.edit)),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              //mainAxisSize: MainAxisSize.min,
              children: [
                Row(),
                Text('Description:'),
                Text('${widget.event.description}'),
                Text("location:"),
                Text(widget.event.location),
                Text('Date:'),
                Text(widget.event.date.toString()),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 200,
            height: MediaQuery.of(context).size.height * 0.7,
            child: Container(
              decoration: BoxDecoration(
                color: context.watch<theme>().dark
                    ? CupertinoColors.darkBackgroundGray
                    : CupertinoColors.extraLightBackgroundGray,
                borderRadius: BorderRadius.circular(40.0),
              ),
              child: EventDetailsController.instance.gifts.isEmpty
                  ? Center(
                      child: Text('No Gifts'),
                    )
                  : Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: EventDetailsController.instance.gifts
                          .map((gift) => Chip(
                                label: Text(gift.name),
                                avatar: Icon(CupertinoIcons.gift),
                              ))
                          .toList(), // This ensures a flat list of widgets
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
