import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:package_info_plus/package_info_plus.dart';

class WebViewDeviceInfo {
  final String? systemName;
  final String? manufacturer;
  final String? model;
  final String? deviceId;
  final String? systemVersion;
  final String? bundleId;
  final String? buildNumber;
  final String? version;
  final String? readableVersion;
  final String? deviceName;
  final String? deviceLocale;
  final String? timezone;

  WebViewDeviceInfo({
    this.systemName,
    this.manufacturer,
    this.model,
    this.deviceId,
    this.systemVersion,
    this.bundleId,
    this.buildNumber,
    this.version,
    this.readableVersion,
    this.deviceName,
    this.deviceLocale,
    this.timezone,
  });

  static Future<WebViewDeviceInfo?> fromData() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    final String deviceLocale = Platform.localeName;

    if (Platform.isIOS) {
      IosDeviceInfo info = await deviceInfo.iosInfo;
      return WebViewDeviceInfo(
        systemName: 'iOS',
        manufacturer: info.name,
        model: info.modelName,
        deviceId: info.identifierForVendor,
        systemVersion: info.systemVersion,
        bundleId: packageInfo.packageName,
        buildNumber: packageInfo.buildNumber,
        version: packageInfo.version,
        readableVersion: '${packageInfo.version}.${packageInfo.buildNumber}',
        deviceName: info.name,
        deviceLocale: deviceLocale,
        timezone: currentTimeZone,
      );
    } else if (Platform.isAndroid) {
      AndroidDeviceInfo info = await deviceInfo.androidInfo;
      final String? androidId = await AndroidId().getId();
      return WebViewDeviceInfo(
        systemName: 'Android',
        manufacturer: info.manufacturer,
        model: info.model,
        deviceId: androidId,
        systemVersion: info.version.release,
        bundleId: packageInfo.packageName,
        buildNumber: packageInfo.buildNumber,
        version: packageInfo.version,
        readableVersion: '${packageInfo.version}.${packageInfo.buildNumber}',
        deviceName: info.device,
        deviceLocale: deviceLocale,
        timezone: currentTimeZone,
      );
    }
    return null;
  }

  Map toMap() {
    return {
      'systemName': systemName,
      'manufacturer': manufacturer,
      'model': model,
      'deviceId': deviceId,
      'systemVersion': systemVersion,
      'bundleId': bundleId,
      'buildNumber': buildNumber,
      'version': version,
      'readableVersion': readableVersion,
      'deviceName': deviceName,
      'deviceLocale': deviceLocale,
      'timezone': timezone,
    };
  }

  String toJson() {
    return '''
    {
      "systemName": "$systemName",
      "manufacturer": "$manufacturer",
      "model": "$model",
      "deviceId": "$deviceId",
      "systemVersion": "$systemVersion",
      "bundleId": "$bundleId",
      "buildNumber": "$buildNumber",
      "version": "$version",
      "readableVersion": "$readableVersion",
      "deviceName": "$deviceName",
      "deviceLocale": "$deviceLocale",
      "timezone": "$timezone"
    }
    ''';
  }
}
