import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

class WebViewUtils {
  static Future<void> showErrorSnackBar(
    BuildContext context,
    String message,
  ) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.pink),
    );
  }

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

  Future<Map<String, dynamic>?> convertImageToBase64(XFile? file) async {
    if (file == null) return null;
    // Convert image to base64
    final File imageFile = File(file.path);
    final List<int> imageBytes = await imageFile.readAsBytes();
    final String base64Image = base64Encode(imageBytes);
    final Map<String, dynamic> imageData = {
      'fileName': file.name,
      'mimeType': _getMimeType(file.path),
      'base64Data': base64Image,
      'size': imageBytes.length,
    };
    return imageData;
  }

  String _getMimeType(String filePath) {
    final String extension = filePath.split('.').last.toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      default:
        return 'image/jpeg';
    }
  }

  Map<String, Object> cleanParameters(Map<String, dynamic>? parameters) {
    if (parameters == null) return {};
    final result = <String, Object>{};
    parameters.forEach((key, value) {
      final cleaned = _cleanValue(value);
      if (cleaned != null) {
        result[key] = cleaned;
      }
    });
    return result;
  }

  Object? _cleanValue(dynamic value, {bool removeEmptyStrings = true}) {
    if (value == null) return null;
    if (value is String) {
      if (removeEmptyStrings && value.isEmpty) return null;
      if (value.trim().isEmpty) return null; // 공백만 있는 경우도 제거
      return value;
    }
    if (value is Map) {
      final cleanedMap = <String, Object>{};
      value.forEach((key, val) {
        final cleanedVal = _cleanValue(val);
        if (cleanedVal != null) {
          cleanedMap[key.toString()] = cleanedVal;
        }
      });
      return cleanedMap.isEmpty ? null : cleanedMap;
    }
    if (value is List) {
      final cleanedList = <Object>[];
      for (final item in value) {
        final cleanedItem = _cleanValue(item);
        if (cleanedItem != null) {
          cleanedList.add(cleanedItem);
        }
      }
      return cleanedList.isEmpty ? null : cleanedList;
    }
    return value;
  }

  T? convertTo<T>(dynamic value) {
    if (value == null) return null;

    try {
      // String 타입 변환
      if (T == String) {
        return value.toString() as T;
      }

      // int 타입 변환
      if (T == int) {
        if (value is int) return value as T;
        if (value is double) return value.toInt() as T;
        if (value is String) return int.parse(value) as T;
        if (value is bool) return (value ? 1 : 0) as T;
      }

      // double 타입 변환
      if (T == double) {
        if (value is double) return value as T;
        if (value is int) return value.toDouble() as T;
        if (value is String) return double.parse(value) as T;
        if (value is bool) return (value ? 1.0 : 0.0) as T;
      }

      // bool 타입 변환
      if (T == bool) {
        if (value is bool) return value as T;
        if (value is int) return (value != 0) as T;
        if (value is double) return (value != 0.0) as T;
        if (value is String) {
          String lower = value.toLowerCase();
          return (lower == 'true' || lower == '1' || lower == 'yes') as T;
        }
      }

      // num 타입 변환
      if (T == num) {
        if (value is num) return value as T;
        if (value is String) {
          // 정수로 파싱ㄴ 먼저 시도
          if (value.contains('.')) {
            return double.parse(value) as T;
          } else {
            return int.parse(value) as T;
          }
        }
        if (value is bool) return (value ? 1 : 0) as T;
      }

      // List 타입 변환
      if (T.toString().startsWith('List')) {
        if (value is List) return value as T;
        return [value] as T;
      }

      // 직접 캐스팅 시도
      if (value is T) return value;
    } catch (e) {
      return null;
    }
    return null;
  }
}
