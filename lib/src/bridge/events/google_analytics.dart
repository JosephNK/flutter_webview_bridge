import 'package:flutter/material.dart';

import '../../firebase/firebase_google_analytics.dart';
import '../../models/types.dart';
import '../../utils/utils.dart';

class GoogleAnalyticsEvent {
  Future<Map<String, Object?>> process(
    BuildContext context,
    dynamic data,
  ) async {
    final eventType = data['eventType'] as String?;
    final item = data['item'] as Map?;
    final googleAnalyticsEventType = eventType?.googleAnalyticsEventType;

    Map<String, Object?> sendData = {
      'type': WebViewBridgeFeatureType.googleAnalytics.value,
    };

    if (item == null) {
      sendData['error'] = 'Item data is required for sendLogEvent';
      return sendData;
    }

    if (googleAnalyticsEventType == null) {
      sendData['error'] = 'Event type is required for Google Analytics';
      return sendData;
    }

    switch (googleAnalyticsEventType) {
      case GoogleAnalyticsEventType.setUserId:
        try {
          final userId = item['userId'] as String?;
          if (userId == null) {
            sendData['error'] = 'User ID is required for setUserId';
            return sendData;
          }
          await FirebaseGoogleAnalytics.shared.setUserId(userId: userId);
        } catch (e) {
          rethrow;
        }
        break;
      case GoogleAnalyticsEventType.sendLogEvent:
        try {
          final eventName = item['eventName'] as String?;
          final parameters = item['parameters'] as Map?;
          if (eventName == null) {
            sendData['error'] = 'Event name is required';
            return sendData;
          } else if (parameters == null) {
            sendData['error'] = 'Parameters are required';
            return sendData;
          }
          Map<String, Object>? sendParameters;
          if (parameters is Map<String, dynamic>) {
            sendParameters = WebViewUtils().cleanParameters(parameters);
          } else if (parameters is Map<String, Object>) {
            sendParameters = parameters;
          }
          await FirebaseGoogleAnalytics.shared.sendLogEvent(
            eventName,
            parameters: sendParameters,
          );
        } catch (e) {
          rethrow;
        }
        break;
      case GoogleAnalyticsEventType.sendLogPurchaseEvent:
        try {
          final eventName = item['eventName'] as String?;
          final parameters = item['parameters'] as Map?;
          if (eventName == null) {
            sendData['error'] = 'Event name is required';
            return sendData;
          } else if (parameters == null) {
            sendData['error'] = 'Parameters are required';
            return sendData;
          }
          Map<String, Object>? sendParameters;
          if (parameters is Map<String, dynamic>) {
            sendParameters = WebViewUtils().cleanParameters(parameters);
          } else if (parameters is Map<String, Object>) {
            sendParameters = parameters;
          }
          if (sendParameters != null) {
            final ecommerce =
                sendParameters['ecommerce'] as Map<String, Object>;
            await FirebaseGoogleAnalytics.shared.sendLogPurchaseEvent(
              ecommerce: ecommerce,
            );
          } else {
            sendData['error'] = 'Ecommerce parameters are required';
          }
        } catch (e) {
          rethrow;
        }
        break;
    }

    return sendData;
  }
}
