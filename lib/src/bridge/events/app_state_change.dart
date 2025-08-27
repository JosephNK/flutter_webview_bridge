import 'package:flutter/material.dart';

import '../../models/types.dart';

class AppStateChangeEvent {
  Future<Map<String, Object?>> process(BuildContext context) async {
    Map<String, Object?> sendData = {
      'type': WebViewBridgeFeatureType.appStateChange.value,
      'error': 'This request is not supported',
    };
    return sendData;
  }
}
