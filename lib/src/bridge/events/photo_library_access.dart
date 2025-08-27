import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

import '../../models/types.dart';
import '../../utils/utils.dart';

class PhotoLibraryAccessEvent {
  Future<Map<String, Object?>> process(BuildContext context) async {
    Map<String, Object?> sendData = {
      'type': WebViewBridgeFeatureType.photoLibraryAccess.value,
    };
    final isGranted = await WebViewUtils().requestPermission(
      ph.Permission.photos,
    );
    if (isGranted) {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      final Map<String, dynamic>? imageData = await WebViewUtils()
          .convertImageToBase64(image);
      if (imageData != null) {
        sendData['data'] = [imageData];
      } else {
        sendData['error'] = 'Failed to convert image to base64';
      }
    } else {
      sendData['error'] = 'Permission is not granted';
    }
    return sendData;
  }
}
