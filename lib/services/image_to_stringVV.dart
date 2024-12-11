import 'dart:convert';
import 'dart:io';
//import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';

import 'package:flutter/material.dart';
// import 'dart:convert';


class ImageConverter {
  Future<String> convertImageToString(File imageFile) async {
    List<int> imageBytes = await imageFile.readAsBytes();
    String base64String = base64Encode(imageBytes);
    return base64String;
  }

  Image convertStringToImage(String base64String) {
    Uint8List imageBytes = base64Decode(base64String);
    return Image.memory(imageBytes);
  }
}
