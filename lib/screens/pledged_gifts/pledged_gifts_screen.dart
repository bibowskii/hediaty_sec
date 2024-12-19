import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hediaty_sec/providers/theme_provider.dart';
import 'package:hediaty_sec/screens/Event_details/widgets/gift_card.dart';
import 'package:hediaty_sec/screens/gift_details/gift_details.dart';
import 'package:hediaty_sec/screens/pledged_gifts/pledgd_gifts_screen_controller.dart';
import 'package:hediaty_sec/services/user_manager.dart';
import 'package:provider/provider.dart';

class PledgedGiftsScreen extends StatefulWidget {
  const PledgedGiftsScreen({super.key});

  @override
  State<PledgedGiftsScreen> createState() => _PledgedGiftsScreenState();
}

class _PledgedGiftsScreenState extends State<PledgedGiftsScreen> {
  String selectedCategory = 'All'; // Default category to show all gifts

  final List<String> categories = [
    'All', 'Electronics', 'Books', 'Clothing', 'Toys',
    'Home & Kitchen', 'Sports & Outdoors', 'Other'
  ];

  @override
  void initState() {
    super.initState();
    _fetchGifts();
  }

  Future<void> _fetchGifts() async {
    await PledgdGiftsScreenController.instance.GetMyPledgedGifts(UserManager().getUserId()!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _fetchGifts,
      child: Scaffold(
        backgroundColor: context.watch<theme>().dark
            ? CupertinoColors.darkBackgroundGray
            : CupertinoColors.extraLightBackgroundGray,
        appBar: AppBar(
          title: Text('Pledged Gifts'),
          actions: [
            DropdownButton<String>(
              value: selectedCategory,
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                });
              },
              items: categories.map((category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: PledgdGiftsScreenController.instance.pledgedGifts
                  .where((gift) {
                // If 'All' is selected, show all gifts
                if (selectedCategory == 'All') return true;
                // Filter gifts by category
                return gift.category == selectedCategory;
              })
                  .map(
                    (gift) => GestureDetector(
                  child: GiftCard(
                    name: gift.name,
                    PledgedBy: gift.pledgedBy,
                    Status: gift.status,
                    id: gift.id,
                    ImageURl: gift.imgURl,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GiftDetails(myGift: gift),
                      ),
                    ).then((value) {
                      setState(() {
                        _fetchGifts();
                      });
                    });
                  },
                ),
              )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}
