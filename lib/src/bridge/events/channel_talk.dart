import 'package:channel_talk_flutter/channel_talk_flutter.dart';
import 'package:flutter/material.dart';

import '../../models/types.dart';

class ChannelTalkEvent {
  Future<Map<String, Object?>> processBoot(
    BuildContext context,
    dynamic data,
  ) async {
    Map<String, Object?> sendData = {
      'type': WebViewBridgeFeatureType.channelTalkBoot.value,
    };
    if (data is Map) {
      final pluginKey = data['pluginKey'] as String?;
      final userId = data['userId'] as String?;
      final email = data['email'] as String?;
      final name = data['name'] as String?;
      if (pluginKey != null &&
          userId != null &&
          email != null &&
          name != null) {
        try {
          await ChannelTalk.boot(
            pluginKey: pluginKey,
            memberId: userId,
            email: email,
            name: name,
          );
        } catch (e) {
          sendData['error'] = e.toString();
          return sendData;
        }
      } else {
        sendData['error'] =
            'pluginKey, userId, email, name is required for ChannelTalk';
      }
    } else {
      sendData['error'] = 'Invalid data type for ChannelTalk';
    }
    return sendData;
  }

  Future<Map<String, Object?>> processShowMessenger(
    BuildContext context,
  ) async {
    Map<String, Object?> sendData = {
      'type': WebViewBridgeFeatureType.channelTalkShowMessenger.value,
    };
    try {
      await ChannelTalk.showMessenger();
    } catch (e) {
      sendData['error'] = e.toString();
    }
    return sendData;
  }

  Future<Map<String, Object?>> processShutdown(BuildContext context) async {
    Map<String, Object?> sendData = {
      'type': WebViewBridgeFeatureType.channelTalkShutdown.value,
    };
    try {
      await ChannelTalk.shutdown();
    } catch (e) {
      sendData['error'] = e.toString();
    }
    return sendData;
  }
}
