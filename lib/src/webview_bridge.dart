import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'webview_device_info.dart';
import 'webview_token.dart';
import 'webview_types.dart';

class FlutterWebViewBridgeJavaScriptChannel {
  final WebViewController webViewController;
  final String channelName;

  FlutterWebViewBridgeJavaScriptChannel({
    required this.webViewController,
    this.channelName = 'IN_APP_WEBVIEW_BRIDGE_CHANNEL',
  });

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
        // Create SendData
        Map<String, Object?> sendData = {
          'type': webViewBridgeFeatureType.value,
        };

        // Switch on the feature type
        switch (webViewBridgeFeatureType) {
          case WebViewBridgeFeatureType.appStateChange:
            sendData['error'] = 'This request is not supported';
            break;
          case WebViewBridgeFeatureType.pushToken:
            sendData['data'] = {'token': WebViewToken.fcmToken};
            break;
          case WebViewBridgeFeatureType.deviceInfo:
            sendData['data'] = (await WebViewDeviceInfo.fromData())?.toMap();
            break;
          case WebViewBridgeFeatureType.cameraAccess:
            final isGranted = await requestPermission(ph.Permission.camera);
            if (!isGranted) return;
            // TODO: Open Camera
            break;
          case WebViewBridgeFeatureType.photoLibraryAccess:
            final isGranted = await requestPermission(ph.Permission.photos);
            if (!isGranted) return;
            // TODO: Open Photo Library
            break;
          case WebViewBridgeFeatureType.setClipboard:
            try {
              if (data is Map) {
                final text = data['text'] as String?;
                if (text != null) {
                  await Clipboard.setData(ClipboardData(text: text));
                  return;
                } else {
                  sendData['error'] = 'Text data is required for clipboard';
                }
              } else {
                sendData['error'] = 'Invalid data type for clipboard';
              }
            } catch (e) {
              sendData['error'] = e.toString();
            }
            break;
          case WebViewBridgeFeatureType.getClipboard:
            try {
              final text =
                  (await Clipboard.getData(Clipboard.kTextPlain))?.text ?? '';
              if (text.isNotEmpty) {
                sendData['data'] = {'text': text};
              } else {
                sendData['error'] = 'Clipboard is empty';
              }
            } catch (e) {
              sendData['error'] = e.toString();
            }
            break;
          case WebViewBridgeFeatureType.openInAppBrowser:
            if (data is Map) {
              final url = data['url'] as String?;
              if (url != null) {
                try {
                  final uri = Uri.parse(url);
                  await launchUrl(uri, mode: LaunchMode.platformDefault);
                  return;
                } catch (e) {
                  sendData['error'] = e.toString();
                }
              } else {
                sendData['error'] =
                    'Url data is required for open in-app browser';
              }
            } else {
              sendData['error'] = 'Invalid data type for open in-app browser';
            }
            break;
          case WebViewBridgeFeatureType.openExternalBrowser:
            if (data is Map) {
              final url = data['url'] as String?;
              if (url != null) {
                try {
                  final uri = Uri.parse(url);
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                  return;
                } catch (e) {
                  sendData['error'] = e.toString();
                }
              } else {
                sendData['error'] =
                    'Url data is required for open external browser';
              }
            } else {
              sendData['error'] = 'Invalid data type for open external browser';
            }
            break;
          case WebViewBridgeFeatureType.openAppSettings:
            ph.openAppSettings();
            return;
          case WebViewBridgeFeatureType.exitApp:
            Future.delayed(const Duration(milliseconds: 250), () {
              if (Platform.isIOS) {
                exit(0);
              } else if (Platform.isAndroid) {
                SystemNavigator.pop();
              }
            });
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
    return webViewController.runJavaScriptReturningResult('''
        (function() {
          if (typeof window.callbackAppState === 'function') {
            window.callbackAppState('$jsonData');
            return 'success';
          } else if (typeof document.callbackAppState === 'function') {
            document.callbackAppState('$jsonData');
            return 'success';
          }
          throw new Error('callbackAppState function not available');
        })()
      ''');
  }

  Future<Object> runJavaScriptReturningResultPostMessage(
    String jsonData,
  ) async {
    return webViewController.runJavaScriptReturningResult('''
        (function() {
          if (typeof window.callbackPostMessage === 'function') {
            window.callbackPostMessage('$jsonData');
            return 'success';
          } else if (typeof document.callbackPostMessage === 'function') {
            document.callbackPostMessage('$jsonData');
            return 'success';
          }
          throw new Error('callbackPostMessage function not available');
        })()
      ''');
  }
}

extension FlutterWebViewBridgeJavaScriptChannelPermistion
    on FlutterWebViewBridgeJavaScriptChannel {
  Future<bool> requestPermission(ph.Permission permission) async {
    final isGranted = await permission.isGranted;
    if (!isGranted) {
      try {
        ph.PermissionStatus status = await permission.request();
        if (status == ph.PermissionStatus.permanentlyDenied) {
          ph.openAppSettings();
          return false;
        }
        if (status != ph.PermissionStatus.granted) {
          return false;
        }
      } catch (e) {
        return false;
      }
    }
    return true;
  }
}
