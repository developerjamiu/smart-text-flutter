import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'smart_text_flutter_method_channel.dart';

abstract class SmartTextFlutterPlatform extends PlatformInterface {
  /// Constructs a SmartTextFlutterPlatform.
  SmartTextFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static SmartTextFlutterPlatform _instance = MethodChannelSmartTextFlutter();

  /// The default instance of [SmartTextFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelSmartTextFlutter].
  static SmartTextFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SmartTextFlutterPlatform] when
  /// they register themselves.
  static set instance(SmartTextFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<List?> classifyText(String text) {
    throw UnimplementedError('classifyText() has not been implemented.');
  }
}
