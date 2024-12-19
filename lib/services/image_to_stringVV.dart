// done and working perfectly

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

class ImageConverterr {
  final ImagePicker _picker = ImagePicker();

  /// Picks an image from the gallery, compresses it, and converts it to a Base64 string
  Future<String?> pickAndCompressImageToString() async {
    var selectedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (selectedImage != null) {
      try {

        var imageBytes = await File(selectedImage.path).readAsBytes();


        img.Image? image = img.decodeImage(imageBytes);

        if (image != null) {

          img.Image resizedImage = img.copyResize(image, width: 800); // You can change the width here


          List<int> compressedBytes = img.encodeJpg(resizedImage, quality: 80);


          var imageString = base64Encode(compressedBytes);
          return imageString;
        }
      } catch (e) {

        print("Error while picking, compressing, or converting image: $e");
        return null;
      }
    }
    return null;
  }

  /// Converts a Base64 string to an image widget display with memory image
  Uint8List? stringToImage(String base64String) {
    try {

      Uint8List bytes = base64Decode(base64String);
      // Return an Image widget from the bytes
      return bytes;
    } catch (e) {

      print("Error while converting string to image: $e");
      return null;
    }
  }
}
