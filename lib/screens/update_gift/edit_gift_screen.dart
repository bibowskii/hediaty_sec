import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hediaty_sec/models/data/Gifts.dart';
import 'package:hediaty_sec/models/domain/gift_methods.dart';
import 'package:hediaty_sec/screens/pledged_gifts/my_gifts.dart';
import 'package:hediaty_sec/services/image_to_stringVV.dart';
import 'package:hediaty_sec/services/user_manager.dart';
import 'package:hediaty_sec/widgets/textField.dart';
import 'package:uuid/uuid.dart';

class EditGift extends StatefulWidget {
  String EventID;
  Gift myGift;
  EditGift({super.key, required this.EventID, required this.myGift});

  @override
  State<EditGift> createState() => _EditGiftState();
}

class _EditGiftState extends State<EditGift> {
  @override
  Widget build(BuildContext context) {
    TextEditingController giftName = TextEditingController();
    TextEditingController priceController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController categoryController = TextEditingController();
    categoryController.text = widget.myGift.description;
    priceController.text = widget.myGift.price.toString();
    giftName.text = widget.myGift.name;
    descriptionController.text = widget.myGift.description!;
    var GiftImage = ImageConverterr().stringToImage(widget.myGift.imgURl!);
    var selectedImage = widget.myGift.imgURl!;
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
                      : AssetImage('lib/assets/icons/logo.png'),
                  radius: 70,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: IconButton(
                    icon: Icon(
                      CupertinoIcons.add_circled_solid,
                      size: 30,
                    ),
                    color: Colors.white,
                    onPressed: () async {
                      setState(() async {
                        selectedImage = (await ImageConverterr()
                            .pickAndCompressImageToString())!;
                        GiftImage =
                            ImageConverterr().stringToImage(selectedImage!);
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            CustomTextField(
                hintText: 'Gift name',
                icon: CupertinoIcons.gift_alt,
                isObsecure: false,
                controller: giftName),
            SizedBox(
              height: 8,
            ),
            CustomTextField(
                hintText: 'price',
                icon: CupertinoIcons.money_dollar_circle,
                isObsecure: false,
                controller: priceController),
            SizedBox(
              height: 8,
            ),
            CustomTextField(
                hintText: 'description',
                icon: Icons.description,
                isObsecure: false,
                controller: descriptionController),
            SizedBox(
              height: 8,
            ),
            CustomTextField(
                hintText: 'category',
                icon: Icons.category,
                isObsecure: false,
                controller: categoryController),
            SizedBox(
              height: 8,
            ),
            ElevatedButton(
                onPressed: () async {
                  Gift myGift = Gift(
                      Uuid().v1(),
                      giftName.text,
                      descriptionController.text,
                      categoryController.text,
                      false,
                      priceController.text as double,
                      widget.EventID,
                      UserManager().getUserId()!,
                      selectedImage,
                      '');
                  await giftMethods().createGift(myGift);
                  Navigator.pop(context);
                },
                child: Text('Edit gift')),
          ],
        ),
      ),
    );
  }
}
