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
  googleAnalytics,
  appsFlyerAnalytics,
  googleSignInLogin,
  googleSignInLogout,
  appleSignInLogin,
  appleSignInLogout,
  refreshTokenRead,
  refreshTokenWrite,
  refreshTokenDelete,
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
      case WebViewBridgeFeatureType.googleAnalytics:
        return 'GOOGLE_ANALYTICS';
      case WebViewBridgeFeatureType.appsFlyerAnalytics:
        return 'APPS_FLYER_ANALYTICS';
      case WebViewBridgeFeatureType.googleSignInLogin:
        return 'GOOGLE_SIGN_IN_LOGIN';
      case WebViewBridgeFeatureType.googleSignInLogout:
        return 'GOOGLE_SIGN_IN_LOGOUT';
      case WebViewBridgeFeatureType.appleSignInLogin:
        return 'APPLE_SIGN_IN_LOGIN';
      case WebViewBridgeFeatureType.appleSignInLogout:
        return 'APPLE_SIGN_IN_LOGOUT';
      case WebViewBridgeFeatureType.refreshTokenRead:
        return 'REFRESH_TOKEN_READ';
      case WebViewBridgeFeatureType.refreshTokenWrite:
        return 'REFRESH_TOKEN_WRITE';
      case WebViewBridgeFeatureType.refreshTokenDelete:
        return 'REFRESH_TOKEN_DELETE';
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
      case 'GOOGLE_ANALYTICS':
        return WebViewBridgeFeatureType.googleAnalytics;
      case 'APPS_FLYER_ANALYTICS':
        return WebViewBridgeFeatureType.appsFlyerAnalytics;
      case 'GOOGLE_SIGN_IN_LOGIN':
        return WebViewBridgeFeatureType.googleSignInLogin;
      case 'GOOGLE_SIGN_IN_LOGOUT':
        return WebViewBridgeFeatureType.googleSignInLogout;
      case 'APPLE_SIGN_IN_LOGIN':
        return WebViewBridgeFeatureType.appleSignInLogin;
      case 'APPLE_SIGN_IN_LOGOUT':
        return WebViewBridgeFeatureType.appleSignInLogout;
      case 'REFRESH_TOKEN_READ':
        return WebViewBridgeFeatureType.refreshTokenRead;
      case 'REFRESH_TOKEN_WRITE':
        return WebViewBridgeFeatureType.refreshTokenWrite;
      case 'REFRESH_TOKEN_DELETE':
        return WebViewBridgeFeatureType.refreshTokenDelete;
    }
    return null;
  }
}

////////////////////////////////////////////////////////////////////////////////

enum GoogleAnalyticsEventType { setUserId, sendLogEvent, sendLogPurchaseEvent }

extension GoogleAnalyticsEventTypeValue on GoogleAnalyticsEventType {
  String get value {
    switch (this) {
      case GoogleAnalyticsEventType.setUserId:
        return 'SET_USER_ID';
      case GoogleAnalyticsEventType.sendLogEvent:
        return 'SEND_LOG_EVENT';
      case GoogleAnalyticsEventType.sendLogPurchaseEvent:
        return 'SEND_LOG_PURCHASE_EVENT';
    }
  }
}

extension GoogleAnalyticsEventTypeString on String {
  GoogleAnalyticsEventType? get googleAnalyticsEventType {
    switch (this) {
      case 'SET_USER_ID':
        return GoogleAnalyticsEventType.setUserId;
      case 'SEND_LOG_EVENT':
        return GoogleAnalyticsEventType.sendLogEvent;
      case 'SEND_LOG_PURCHASE_EVENT':
        return GoogleAnalyticsEventType.sendLogPurchaseEvent;
    }
    return null;
  }
}
