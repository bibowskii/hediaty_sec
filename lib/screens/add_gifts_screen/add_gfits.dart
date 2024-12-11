import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hediaty_sec/widgets/textField.dart';

class AddGfits extends StatelessWidget {
  String EventID;
   AddGfits({super.key, required this.EventID});

  @override
  Widget build(BuildContext context) {
    TextEditingController giftName = TextEditingController();
    TextEditingController priceController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController categoryController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a gift to your wishlist'),
      ),
      body: Column(
        children: [
          CustomTextField(hintText: 'Gift name', icon: CupertinoIcons.gift_alt, isObsecure: false, controller: giftName),
          SizedBox(height: 8,),
          CustomTextField(hintText: 'price', icon: CupertinoIcons.money_dollar_circle, isObsecure: false, controller: priceController),
          SizedBox(height: 8,),
          CustomTextField(hintText: 'description', icon: Icons.description, isObsecure: false, controller: descriptionController),
          SizedBox(height: 8,),
          CustomTextField(hintText: 'category', icon: Icons.category, isObsecure: false, controller: categoryController),
          SizedBox(height: 8,),
          ElevatedButton(onPressed: (){}, child: Text('Add gift')),


        ],
      ),
    );
  }
}
