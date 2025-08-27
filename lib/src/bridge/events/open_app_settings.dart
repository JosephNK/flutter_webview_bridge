import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

import '../../models/types.dart';

class OpenAppSettingsEvent {
  Future<Map<String, Object?>> process(BuildContext context) async {
    Map<String, Object?> sendData = {
      'type': WebViewBridgeFeatureType.openAppSettings.value,
    };
    ph.openAppSettings();
    return sendData;
  }
}
