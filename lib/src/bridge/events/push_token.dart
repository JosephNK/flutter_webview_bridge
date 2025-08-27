import 'package:flutter/material.dart';

import '../../models/token.dart';
import '../../models/types.dart';

class PushTokenEvent {
  Future<Map<String, Object?>> process(BuildContext context) async {
    Map<String, Object?> sendData = {
      'type': WebViewBridgeFeatureType.pushToken.value,
      'data': {'token': WebViewToken.fcmToken},
    };
    return sendData;
  }
}
