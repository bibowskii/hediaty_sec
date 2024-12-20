import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hediaty_sec/models/domain/gift_methods.dart';
import 'package:hediaty_sec/screens/gift_details/gift_details_controller.dart';
import 'package:hediaty_sec/screens/gift_details/pledge_button.dart';
import 'package:hediaty_sec/screens/update_gift/edit_gift_screen.dart';
import 'package:hediaty_sec/services/image_to_stringVV.dart';
import 'package:hediaty_sec/services/user_manager.dart';

import '../../models/data/Gifts.dart';

class GiftDetails extends StatefulWidget {
  final Gift myGift;
  final String? eventName;

  const GiftDetails({Key? key, required this.myGift, this.eventName})
      : super(key: key);

  @override
  State<GiftDetails> createState() => _GiftDetailsState();
}

class _GiftDetailsState extends State<GiftDetails> {
  bool isPledged = false;
  bool isPledgedByUser = false;

  @override
  void initState() {
    super.initState();
    _initGiftDetails();
  }

  Future<void> _initGiftDetails() async {
    try {
      isPledged =
      await GiftDetailsController.instance.checkIfPledged(widget.myGift);
      isPledgedByUser = await GiftDetailsController.instance
          .checkIfPledgedByUser(widget.myGift);
    } catch (error) {
      debugPrint("Error initializing gift details: $error");
    }
    setState(() {});
  }

  Future<void> _refreshGiftDetails() async {
    await _initGiftDetails();
  }

  @override
  Widget build(BuildContext context) {
    final bool isGiftOwner = widget.myGift.userID == UserManager().getUserId();
    final dynamic giftImage = _getGiftImage();

    return Scaffold(
      appBar: _buildAppBar(context, isGiftOwner),
      body: RefreshIndicator(
        onRefresh: _refreshGiftDetails,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildGiftImage(giftImage),
              const SizedBox(height: 16),
              _buildGiftDetails(),
              const SizedBox(height: 16),
              if (widget.eventName != null) _buildEventName(),
              const SizedBox(height: 16),
              if (!isGiftOwner) _buildPledgeButton(),
              const SizedBox(height: 40),
              if (isPledgedByUser) _buildBuyOrUnbuyButton(),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, bool isGiftOwner) {
    return AppBar(
      backgroundColor: Colors.transparent,
      actions: [
        if (widget.myGift.pledgedBy == null ||
            widget.myGift.pledgedBy == '') ...[
          if (isGiftOwner)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditGift(
                      EventID: widget.myGift.eventID,
                      myGift: widget.myGift,
                    ),
                  ),
                );
              },
            ),
          if (isGiftOwner)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                giftMethods().deleteGift(widget.myGift);
                Navigator.pop(context);
              },
            ),
        ],
      ],
    );
  }

  Widget _buildGiftImage(dynamic giftImage) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.3,
      child: Hero(
        tag: widget.myGift.id,
        child: giftImage != null
            ? Image.memory(giftImage)
            : Image.asset('lib/assets/icons/logo.png'),
      ),
    );
  }

  Widget _buildGiftDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.myGift.name,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          widget.myGift.description ?? 'No description available',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        Text(
          'Category: ${widget.myGift.category ?? 'No category'}',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Text("Status: "),
            CircleAvatar(
              backgroundColor: _getStatusColor(),
              radius: 5,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Price: \$${widget.myGift.price}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildEventName() {
    return Text(
      'Event name: ${widget.eventName}',
      style: const TextStyle(fontSize: 16),
    );
  }

  Widget _buildPledgeButton() {
    return Center(
      child: GestureDetector(
        child: PledgeButton(myGift: widget.myGift),
        onTap: () async {
          setState(() async{
            widget.myGift.pledgedBy =
            widget.myGift.pledgedBy == null || widget.myGift.pledgedBy == ''
                ? UserManager().getUserId()
                : '';
            await _refreshGiftDetails();
          });


        },
      ),
    );
  }

  Widget _buildBuyOrUnbuyButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (widget.myGift.status == false) {
            giftMethods().buyGift(widget.myGift);
          } else {
            giftMethods().unBuyGift(widget.myGift);
          }
          widget.myGift.status = !widget.myGift.status;
        });
      },
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 200,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: widget.myGift.status == false ? Colors.red : Colors.green,
          ),
          child: Center(
            child: Text(
              widget.myGift.status == false ? 'Buy Gift' : 'Gift Bought',
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }

  dynamic _getGiftImage() {
    if (widget.myGift.imgURl != null && widget.myGift.imgURl!.isNotEmpty) {
      return ImageConverterr().stringToImage(widget.myGift.imgURl!);
    }
    return null;
  }

  Color _getStatusColor() {
    if (widget.myGift.pledgedBy == null || widget.myGift.pledgedBy == '') {
      return CupertinoColors.inactiveGray;
    }
    return widget.myGift.status == false ? Colors.green : Colors.red;
  }
}
