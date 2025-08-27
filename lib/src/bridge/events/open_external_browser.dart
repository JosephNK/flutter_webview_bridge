import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/types.dart';

class OpenExternalBrowserEvent {
  Future<Map<String, Object?>> process(
    BuildContext context,
    dynamic data,
  ) async {
    Map<String, Object?> sendData = {
      'type': WebViewBridgeFeatureType.openExternalBrowser.value,
    };
    if (data is Map) {
      final url = data['url'] as String?;
      if (url != null) {
        try {
          final uri = Uri.parse(url);
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } catch (e) {
          rethrow;
        }
      } else {
        sendData['error'] = 'Url data is required for open external browser';
      }
    } else {
      sendData['error'] = 'Invalid data type for open external browser';
    }
    return sendData;
  }
}
