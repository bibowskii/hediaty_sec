import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Custombutton extends StatelessWidget {
  final String ss;
  final String URL;
  const Custombutton({super.key, required this.ss, required this.URL});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: Colors.white,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          // border: Border.all(
          //   color: Colors.black54,
          //   //width: 1.0,
          // ),
        ),
        height: 40,
        width: 160,
        child: Center(
          child: Row(
            children: [
              SvgPicture.asset(
                URL,
                width: 20,
                height: 20,
              ),
              Text(
                ss,
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
