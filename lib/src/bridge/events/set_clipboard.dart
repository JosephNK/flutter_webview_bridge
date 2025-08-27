import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/types.dart';

class SetClipboardEvent {
  Future<Map<String, Object?>> process(
    BuildContext context,
    dynamic data,
  ) async {
    Map<String, Object?> sendData = {
      'type': WebViewBridgeFeatureType.setClipboard.value,
    };
    try {
      if (data is Map) {
        final text = data['text'] as String?;
        if (text != null) {
          await Clipboard.setData(ClipboardData(text: text));
        } else {
          sendData['error'] = 'Text data is required for clipboard';
        }
      } else {
        sendData['error'] = 'Invalid data type for clipboard';
      }
    } catch (e) {
      sendData['error'] = e.toString();
    }
    return sendData;
  }
}
