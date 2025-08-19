enum WebViewBridgeFeatureType {
  appStateChange,
  pushToken,
  deviceInfo,
  cameraAccess,
  photoLibraryAccess,
  setClipboard,
  getClipboard,
  openInAppBrowser,
  openExternalBrowser,
  openAppSettings,
  exitApp,
}

extension WebViewBridgeFeatureTypeValue on WebViewBridgeFeatureType {
  String get value {
    switch (this) {
      case WebViewBridgeFeatureType.appStateChange:
        return 'APP_STATE_CHANGE';
      case WebViewBridgeFeatureType.pushToken:
        return 'PUSH_TOKEN';
      case WebViewBridgeFeatureType.deviceInfo:
        return 'DEVICE_INFO';
      case WebViewBridgeFeatureType.cameraAccess:
        return 'CAMERA_ACCESS';
      case WebViewBridgeFeatureType.photoLibraryAccess:
        return 'PHOTO_LIBRARY_ACCESS';
      case WebViewBridgeFeatureType.setClipboard:
        return 'SET_CLIPBOARD';
      case WebViewBridgeFeatureType.getClipboard:
        return 'GET_CLIPBOARD';
      case WebViewBridgeFeatureType.openInAppBrowser:
        return 'OPEN_IN_APP_BROWSER';
      case WebViewBridgeFeatureType.openExternalBrowser:
        return 'OPEN_EXTERNAL_BROWSER';
      case WebViewBridgeFeatureType.openAppSettings:
        return 'OPEN_APP_SETTINGS';
      case WebViewBridgeFeatureType.exitApp:
        return 'EXIT_APP';
    }
  }
}

extension WebViewBridgeFeatureTypeString on String {
  WebViewBridgeFeatureType? get webViewBridgeFeatureType {
    switch (this) {
      case 'APP_STATE_CHANGE':
        return WebViewBridgeFeatureType.appStateChange;
      case 'PUSH_TOKEN':
        return WebViewBridgeFeatureType.pushToken;
      case 'DEVICE_INFO':
        return WebViewBridgeFeatureType.deviceInfo;
      case 'CAMERA_ACCESS':
        return WebViewBridgeFeatureType.cameraAccess;
      case 'PHOTO_LIBRARY_ACCESS':
        return WebViewBridgeFeatureType.photoLibraryAccess;
      case 'SET_CLIPBOARD':
        return WebViewBridgeFeatureType.setClipboard;
      case 'GET_CLIPBOARD':
        return WebViewBridgeFeatureType.getClipboard;
      case 'OPEN_IN_APP_BROWSER':
        return WebViewBridgeFeatureType.openInAppBrowser;
      case 'OPEN_EXTERNAL_BROWSER':
        return WebViewBridgeFeatureType.openExternalBrowser;
      case 'OPEN_APP_SETTINGS':
        return WebViewBridgeFeatureType.openAppSettings;
      case 'EXIT_APP':
        return WebViewBridgeFeatureType.exitApp;
    }
    return null;
  }
}
