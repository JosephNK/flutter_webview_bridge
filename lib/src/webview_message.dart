import 'package:equatable/equatable.dart';

import 'webview_types.dart';

class WebViewMessage extends Equatable {
  final WebViewBridgeFeatureType type;
  final Object data;

  const WebViewMessage({required this.type, required this.data});

  @override
  List<Object?> get props => [type, data];
}
