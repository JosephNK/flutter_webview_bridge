import 'package:flutter/material.dart';

import '../../device/device_info.dart';
import '../../models/types.dart';

class DeviceInfoEvent {
  Future<Map<String, Object?>> process(BuildContext context) async {
    Map<String, Object?> sendData = {
      'type': WebViewBridgeFeatureType.deviceInfo.value,
      'data': (await WebViewDeviceInfo.fromData())?.toMap(),
    };
    return sendData;
  }
}
