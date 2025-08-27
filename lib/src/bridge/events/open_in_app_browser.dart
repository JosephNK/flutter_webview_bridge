import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/types.dart';

class OpenInAppBrowserEvent {
  Future<Map<String, Object?>> process(
    BuildContext context,
    dynamic data,
  ) async {
    Map<String, Object?> sendData = {
      'type': WebViewBridgeFeatureType.openInAppBrowser.value,
    };
    if (data is Map) {
      final url = data['url'] as String?;
      if (url != null) {
        try {
          final uri = Uri.parse(url);
          await launchUrl(uri, mode: LaunchMode.platformDefault);
        } catch (e) {
          rethrow;
        }
      } else {
        sendData['error'] = 'Url data is required for open in-app browser';
      }
    } else {
      sendData['error'] = 'Invalid data type for open in-app browser';
    }
    return sendData;
  }
}
