import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hediaty_sec/models/data/Event.dart';
import 'package:hediaty_sec/models/domain/event_methods.dart';
import 'package:hediaty_sec/models/domain/gift_methods.dart';
import 'package:hediaty_sec/providers/theme_provider.dart';
import 'package:hediaty_sec/screens/Event_details/edit_event_screen.dart';
import 'package:hediaty_sec/screens/Event_details/event_details_controller.dart';
import 'package:hediaty_sec/screens/Event_details/widgets/gift_card.dart';
import 'package:hediaty_sec/screens/add_gifts_screen/add_gfits.dart';
import 'package:hediaty_sec/screens/gift_details/gift_details.dart';
import 'package:hediaty_sec/services/user_manager.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class EventDetailsScreen extends StatefulWidget {
  final Event event;
  const EventDetailsScreen({super.key, required this.event});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  @override
  void initState() {
    super.initState();
    _fetchGifts();
  }

  Future<void> _fetchGifts() async {
    await EventDetailsController.instance.getGifts(widget.event);
    setState(() {});
  }

  Widget _myGift() {
    if (widget.event.userID == UserManager().getUserId()!) {
      return FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddGfits(EventID: widget.event.id)));
        },
        child: Row(
          children: [Icon(Iconsax.add), Icon(Iconsax.gift)],
        ),
      );
    } else {
      return Container();
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          context.watch<theme>().dark ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor:
            context.watch<theme>().dark ? Colors.black : Colors.white,
        title: Text(widget.event.name),
        actions: [
          widget.event.userID == UserManager().getUserId()
              ? IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditEventScreen(
                                  myEvent: widget.event,
                                )));
                  },
                  icon: const Icon(Icons.edit))
              : Container(),
          widget.event.userID == UserManager().getUserId()
              ? IconButton(
              onPressed: () {
                giftMethods().deleteALLGiftsByEventID(widget.event.id);
                eventMethods().deleteEvent(widget.event);
                Navigator.pop(context);
              },
              icon: const Icon(Icons.delete))
              : Container()
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: context.watch<theme>().dark ? Colors.black : Colors.white,
              borderRadius: BorderRadius.circular(40.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                //mainAxisSize: MainAxisSize.min,
                children: [
                  const Row(),
                  const Text(
                    'Description:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${widget.event.description}',
                    style: const TextStyle(
                      fontSize: 20,
                      //fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "location:",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.event.location,
                    style: const TextStyle(
                      fontSize: 20,
                      //fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Date:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.event.date.toString(),
                    style: const TextStyle(
                      fontSize: 20,
                      //fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Category:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.event.category != null
                        ? '${widget.event.category}'
                        : 'uncategorized',
                    style: const TextStyle(
                      fontSize: 20,
                      //fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
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
                  ? const Center(
                      child: Text('No Gifts'),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(16),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        //temp till is pledged and images are done
                        children: EventDetailsController.instance.gifts
                            .map(
                              (gift) => GestureDetector(
                                child: GiftCard(
                                  name: gift.name,
                                  PledgedBy: gift.pledgedBy,
                                  id: gift.id,
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => GiftDetails(
                                        myGift: gift,
                                        eventName: widget.event.name,
                                      ),
                                    ),
                                  ).then((value) {
                                    setState(() {});
                                  });
                                },
                              ),
                            )
                            .toList(),
                      ),
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: _myGift(),
    );
  }
}
