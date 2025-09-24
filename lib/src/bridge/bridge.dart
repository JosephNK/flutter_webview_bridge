import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_webview_bridge/src/utils/utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../models/types.dart';
import 'events/app_state_change.dart';
import 'events/camera_access.dart';
import 'events/device_info.dart';
import 'events/exit_app.dart';
import 'events/get_clipboard.dart';
import 'events/google_analytics.dart';
import 'events/open_app_settings.dart';
import 'events/open_external_browser.dart';
import 'events/open_in_app_browser.dart';
import 'events/photo_library_access.dart';
import 'events/push_token.dart';
import 'events/refresh_token.dart';
import 'events/set_clipboard.dart';
import 'events/social_google_sign_in.dart';

class FlutterWebViewBridgeJavaScriptChannel {
  final BuildContext context;
  final WebViewController webViewController;
  final String channelName;
  final String? googleServerClientId;

  FlutterWebViewBridgeJavaScriptChannel({
    required this.context,
    required this.webViewController,
    this.channelName = 'IN_APP_WEBVIEW_BRIDGE_CHANNEL',
    required this.googleServerClientId,
  }) {
    SocialGoogleSignIn.shared.initialize(
      googleServerClientId: googleServerClientId,
    );
  }

  Future<void> addJavaScriptChannel() {
    return webViewController.addJavaScriptChannel(
      channelName,
      onMessageReceived: onMessageReceived,
    );
  }

  Future<void> removeJavaScriptChannel() {
    return webViewController.removeJavaScriptChannel(channelName);
  }

  Future<void> onMessageReceived(JavaScriptMessage message) async {
    final json = jsonDecode(message.message);
    final type = json['type'] as String?;
    final data = json['data'];
    if (type != null) {
      final webViewBridgeFeatureType = type.webViewBridgeFeatureType;
      if (webViewBridgeFeatureType != null) {
        late Map<String, Object?> sendData;

        try {
          switch (webViewBridgeFeatureType) {
            case WebViewBridgeFeatureType.appStateChange:
              sendData = await AppStateChangeEvent().process(context);
              break;
            case WebViewBridgeFeatureType.pushToken:
              sendData = await PushTokenEvent().process(context);
              break;
            case WebViewBridgeFeatureType.deviceInfo:
              sendData = await DeviceInfoEvent().process(context);
              break;
            case WebViewBridgeFeatureType.cameraAccess:
              sendData = await CameraAccessEvent().process(context);
              break;
            case WebViewBridgeFeatureType.photoLibraryAccess:
              sendData = await PhotoLibraryAccessEvent().process(context);
              break;
            case WebViewBridgeFeatureType.setClipboard:
              sendData = await SetClipboardEvent().process(context, data);
              break;
            case WebViewBridgeFeatureType.getClipboard:
              sendData = await GetClipboardEvent().process(context);
              break;
            case WebViewBridgeFeatureType.openInAppBrowser:
              sendData = await OpenInAppBrowserEvent().process(context, data);
              break;
            case WebViewBridgeFeatureType.openExternalBrowser:
              sendData = await OpenExternalBrowserEvent().process(
                context,
                data,
              );
              break;
            case WebViewBridgeFeatureType.openAppSettings:
              sendData = await OpenAppSettingsEvent().process(context);
              return;
            case WebViewBridgeFeatureType.googleAnalytics:
              sendData = await GoogleAnalyticsEvent().process(context, data);
              break;
            case WebViewBridgeFeatureType.appsFlyerAnalytics:
              // TODO: Handle this case.
              throw UnimplementedError();
            case WebViewBridgeFeatureType.exitApp:
              sendData = await ExitAppEvent().process(context);
              break;
            case WebViewBridgeFeatureType.googleSignInLogin:
              sendData = await SocialGoogleSignIn.shared.process(
                context,
                action: 'login',
              );
              break;
            case WebViewBridgeFeatureType.googleSignInLogout:
              sendData = await SocialGoogleSignIn.shared.process(
                context,
                action: 'logout',
              );
              break;
            case WebViewBridgeFeatureType.appleSignInLogin:
              // TODO: Handle this case.
              throw UnimplementedError();
            case WebViewBridgeFeatureType.appleSignInLogout:
              // TODO: Handle this case.
              throw UnimplementedError();
            case WebViewBridgeFeatureType.refreshTokenRead:
              sendData = await RefreshTokenEvent().process(
                context,
                action: 'read',
              );
              break;
            case WebViewBridgeFeatureType.refreshTokenWrite:
              sendData = await RefreshTokenEvent().process(
                context,
                action: 'write',
                data: data,
              );
              break;
            case WebViewBridgeFeatureType.refreshTokenDelete:
              sendData = await RefreshTokenEvent().process(
                context,
                action: 'delete',
              );
              break;
          }
        } catch (e) {
          if (context.mounted) {
            WebViewUtils.showErrorSnackBar(context, e.toString());
          }
          return;
        }

        // Send Data to WebView
        await runJavaScriptReturningResultPostMessage(jsonEncode(sendData));
      }
    }
  }

  Future<void> runJavaScriptSetPushToken(String token) async {
    await webViewController.runJavaScript('navigator.deviceToken="$token"');
  }

  Future<Object> runJavaScriptReturningResultAppState(String jsonData) async {
    // JSON 문자열에서 특수문자 이스케이프 처리
    final escapedData = jsonData.replaceAll("'", "\\'").replaceAll('\n', '\\n');

    return webViewController.runJavaScriptReturningResult('''
        (function() {
          if (typeof window.callbackAppState === 'function') {
            window.callbackAppState('$escapedData');
            return 'success';
          } else if (typeof document.callbackAppState === 'function') {
            document.callbackAppState('$escapedData');
            return 'success';
          }
          throw new Error('callbackAppState function not available');
        })()
      ''');
  }

  Future<Object> runJavaScriptReturningResultPostMessage(
    String jsonData,
  ) async {
    // JSON 문자열에서 특수문자 이스케이프 처리
    final escapedData = jsonData.replaceAll("'", "\\'").replaceAll('\n', '\\n');

    return webViewController.runJavaScriptReturningResult('''
        (function() {
          if (typeof window.callbackPostMessage === 'function') {
            window.callbackPostMessage('$escapedData');
            return 'success';
          } else if (typeof document.callbackPostMessage === 'function') {
            document.callbackPostMessage('$escapedData');
            return 'success';
          }
          throw new Error('callbackPostMessage function not available');
        })()
      ''');
  }
}
