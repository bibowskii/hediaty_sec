import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final IconData icon;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.greenAccent),
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.black38),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 3, color: Colors.greenAccent),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 3, color: Colors.greenAccent),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }
}
