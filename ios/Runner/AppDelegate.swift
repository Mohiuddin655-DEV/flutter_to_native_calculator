import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    handleChannel(controller: controller)
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
  private func handleChannel(controller: FlutterViewController){
    let channel = FlutterMethodChannel(
        name: "com.example.calculator/math",
        binaryMessenger: controller.binaryMessenger
    )

    channel.setMethodCallHandler({
        [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
        guard let args = call.arguments as? [String: Any],
              let number1 = args["number1"] as? Double,
              let number2 = args["number2"] as? Double,
              let operation = args["operation"] as? String else {
                result(
                FlutterError(
                    code: "INVALID_ARGUMENTS",
                    message: "Arguments are invalid or missing",
                    details: nil
                )
            )
            return
        }
        
        switch operation {
        case "add":
            result(number1 + number2)
            
        case "subtract":
            result(number1 - number2)
            
        case "multiply":
            result(number1 * number2)
            
        case "divide":
            if number2 == 0 {
                result(
                    FlutterError(
                        code: "DIVIDE_BY_ZERO",
                        message: "Cannot divide by zero",
                        details: nil
                    )
                )
                return
            }
            result(number1 / number2)
            
        case "modulo":
            if number2 == 0 {
                result(
                    FlutterError(
                        code: "MODULO_BY_ZERO",
                        message: "Cannot calculate modulo with zero",
                        details: nil
                    )
                )
                return
            }
            result(number1.truncatingRemainder(dividingBy: number2))
            
        default:
            result(
                FlutterError(
                    code: "INVALID_OPERATION",
                    message: "Operation not supported",
                    details: nil
                )
            )
        }
      }
    )
  }
}
