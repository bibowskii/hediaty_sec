import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hediaty_sec/providers/theme_provider.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
// until images logic is implemented
class GiftCard extends StatelessWidget {
  final String name;
  String? PledgedBy;
  final String? ImageURl;
  GiftCard({super.key, required this.name, required this.PledgedBy, this.ImageURl});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      shadowColor: const Color(0XFF000000),
      borderRadius: BorderRadius.circular(20.0),
      child: Container(
        decoration: BoxDecoration(
          color: context.watch<theme>().dark? Colors.black: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        width: 190,
        height: 190,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                //temp till images are done
                child: Icon(Iconsax.gift),
              ),
              SizedBox(height: 4,),
              Text(name, style: TextStyle(fontSize: 20),),
              Row(
                children: [
                  Text("Status: "),
                  PledgedBy != null? Text(' Pledged by ${PledgedBy}'): Text(' Not Pledged'),
          
                ],
              )
          
            ],
          ),
        ),
      ),




    );
  }
}
