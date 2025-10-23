import 'package:flutter/material.dart';

class FlutterWebViewBridgeObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    // 이미 '/'에 있는데 또 '/'가 push되면
    if (route.settings.name == '/' && previousRoute?.settings.name == '/') {
      final args = route.settings.arguments as Map<String, String>?;
      if (args != null && args.containsKey('code')) {
        // Navigator가 unlock될 때까지 기다림
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // 여기서는 안전하게 pop 가능
          if (navigator != null && navigator!.canPop()) {
            navigator!.pop();
          }
        });
      }
    }
  }
}
