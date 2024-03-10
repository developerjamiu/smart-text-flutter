import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'smart_text_flutter_platform_interface.dart';

/// An implementation of [SmartTextFlutterPlatform] that uses method channels.
class MethodChannelSmartTextFlutter extends SmartTextFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('smart_text_flutter');

  @override
  Future<List?> classifyText(String text) async {
    return await methodChannel.invokeMethod<List>(
      'classifyText',
      text,
    );
  }
}
