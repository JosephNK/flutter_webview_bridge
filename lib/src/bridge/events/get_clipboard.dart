import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/types.dart';

class GetClipboardEvent {
  Future<Map<String, Object?>> process(BuildContext context) async {
    Map<String, Object?> sendData = {
      'type': WebViewBridgeFeatureType.getClipboard.value,
    };
    try {
      final text = (await Clipboard.getData(Clipboard.kTextPlain))?.text ?? '';
      if (text.isNotEmpty) {
        sendData['data'] = {'text': text};
      } else {
        sendData['error'] = 'Clipboard is empty';
      }
    } catch (e) {
      sendData['error'] = e.toString();
    }
    return sendData;
  }
}
