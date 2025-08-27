import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/types.dart';

class ExitAppEvent {
  Future<Map<String, Object?>> process(BuildContext context) async {
    Map<String, Object?> sendData = {
      'type': WebViewBridgeFeatureType.exitApp.value,
    };
    Future.delayed(const Duration(milliseconds: 250), () {
      if (Platform.isIOS) {
        exit(0);
      } else if (Platform.isAndroid) {
        SystemNavigator.pop();
      }
    });
    return sendData;
  }
}
