import Flutter
import UIKit

public class SmartTextFlutterPlugin: NSObject, FlutterPlugin {
  let textClassifier : TextClassifier = AppleTextClassifier();

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "smart_text_flutter", binaryMessenger: registrar.messenger())
    let instance = SmartTextFlutterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "classifyText":
      guard let args = call.arguments as? String else {return}
                
      let smartTexts = textClassifier.classifyText(text: args)
      result(smartTexts.map { $0.toMap() })
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
