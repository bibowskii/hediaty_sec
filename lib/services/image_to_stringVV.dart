import 'dart:convert';
import 'dart:io';
//import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';

import 'package:flutter/material.dart';
// import 'dart:convert';


class imageConverter {
  Future<String> convertImageToBase64(String imagePath) async {
    File imageFile = File(imagePath);
    List<int> imageBytes = await imageFile.readAsBytes();
    String base64String = base64Encode(imageBytes);
    return base64String;
  }

  Widget convertBase64ToImage(String base64String) {
    Uint8List imageBytes = base64Decode(base64String);
    return Image.memory(imageBytes);
  }
}
