import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hediaty_sec/providers/theme_provider.dart';
import 'package:hediaty_sec/services/image_to_stringVV.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

// until images logic is implemented
class GiftCard extends StatelessWidget {
  final String name;
  String? PledgedBy;
  final String? ImageURl;
  final bool? Status;
  final String id;
  GiftCard(
      {super.key,
      required this.name,
      required this.PledgedBy,
      this.ImageURl,
      this.Status, required this.id});

  @override
  Widget build(BuildContext context) {
    var giftImage;
    if (ImageURl != null && ImageURl != '') {
      giftImage = ImageConverterr().stringToImage(ImageURl!);
    }
    return Material(
      elevation: 5,
      shadowColor: const Color(0XFF000000),
      borderRadius: BorderRadius.circular(20.0),
      child: Container(
        decoration: BoxDecoration(
          color: context.watch<theme>().dark ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        width: 190,
        height: 190,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                //color: CupertinoColors.activeBlue, was just used as a placeholder at first
                width: 120,
                height: 120,
                child: Hero(
                  tag: id,

                  child: giftImage != null
                      ? Image.memory(giftImage)
                      : Image.asset('lib/assets/icons/logo.png'),
                ),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                name,
                style: TextStyle(fontSize: 20),
              ),
              Row(
                children: [
                  Text("Status: "),
                  PledgedBy != ''
                      ? Status != false || Status !=''
                          ? CircleAvatar(
                              backgroundColor: Colors.green,
                              radius: 5
                            )
                          : CircleAvatar(
                              backgroundColor: Colors.red,
                              radius: 5
                            )
                      : CircleAvatar(
                          backgroundColor: CupertinoColors.inactiveGray,
                          radius: 5
                        ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
