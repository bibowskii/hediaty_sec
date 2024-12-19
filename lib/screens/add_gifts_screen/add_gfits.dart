import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hediaty_sec/models/data/Gifts.dart';
import 'package:hediaty_sec/models/domain/gift_methods.dart';
import 'package:hediaty_sec/services/image_to_stringVV.dart';
import 'package:hediaty_sec/services/user_manager.dart';
import 'package:hediaty_sec/widgets/textField.dart';
import 'package:uuid/uuid.dart';

class AddGfits extends StatefulWidget {
  String EventID;
   AddGfits({super.key, required this.EventID});

  @override
  State<AddGfits> createState() => _AddGfitsState();
}
String? _selectedCategory;
class _AddGfitsState extends State<AddGfits> {
  late TextEditingController giftName;
  late TextEditingController priceController;
  late TextEditingController descriptionController;
  late TextEditingController categoryController;
  var selectedImage;
  var GiftImage;
  final List<String> _giftCategories = [
    'Electronics',
    'Books',
    'Clothing',
    'Toys',
    'Home & Kitchen',
    'Sports & Outdoors',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    giftName = TextEditingController();
    priceController = TextEditingController();
    descriptionController = TextEditingController();
    categoryController = TextEditingController();
  }

  @override
  void dispose() {
    giftName.dispose();
    priceController.dispose();
    descriptionController.dispose();
    categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Add a gift to your wishlist'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  backgroundImage: GiftImage != null
                      ? MemoryImage(GiftImage!)
                      : AssetImage('lib/assets/icons/logo.png') as ImageProvider,
                  radius: 70,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: IconButton(
                    icon: Icon(CupertinoIcons.add_circled_solid, size: 30),
                    color: Colors.white,
                    onPressed: () async {
                      selectedImage =
                      await ImageConverterr().pickAndCompressImageToString();
                      setState(() {
                        GiftImage =
                            ImageConverterr().stringToImage(selectedImage!);
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            CustomTextField(
                hintText: 'Gift name',
                icon: CupertinoIcons.gift_alt,
                isObsecure: false,
                controller: giftName),
            SizedBox(height: 8),
            CustomTextField(
                hintText: 'price',
                icon: CupertinoIcons.money_dollar_circle,
                isObsecure: false,
                controller: priceController),
            SizedBox(height: 8),
            CustomTextField(
                hintText: 'description',
                icon: Icons.description,
                isObsecure: false,
                controller: descriptionController),
            SizedBox(height: 8),
            DropdownButton<String>(
              value: _selectedCategory,
              hint: Text('Select a category'),
              isExpanded: true,
              items: _giftCategories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategory = newValue;
                });
              },
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                Gift myGift = Gift(
                  Uuid().v1(),
                  giftName.text,
                  descriptionController.text,
                  _selectedCategory.toString(),
                  false,
                  double.tryParse(priceController.text) ?? 0.0,
                  widget.EventID,
                  UserManager().getUserId()!,
                  selectedImage,
                  '',
                );
                await giftMethods().createGift(myGift);
                Navigator.pop(context);
              },
              child: Text('Add gift'),
            ),
          ],
        ),
      ),
    );
  }
}
