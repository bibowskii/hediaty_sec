import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class friendCard extends StatelessWidget {
  final String uName;
  const friendCard({super.key, required this.uName});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          const CircleAvatar(
            child: Icon(Iconsax.user),
          ),
          Text(uName),
        ],
      ),
    );
  }
}
