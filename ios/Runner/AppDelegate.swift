import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
    // MARK: - Calculator Operations
    private func add(_ number1: Double, _ number2: Double) -> Double {
        return number1 + number2
    }

    private func subtract(_ number1: Double, _ number2: Double) -> Double {
        return number1 - number2
    }

    private func multiply(_ number1: Double, _ number2: Double) -> Double {
        return number1 * number2
    }

    private func divide(_ number1: Double, _ number2: Double) throws -> Double {
        guard number2 != 0 else {
            throw CalculatorError.divideByZero
        }
        return number1 / number2
    }

    private func modulo(_ number1: Double, _ number2: Double) throws -> Double {
        guard number2 != 0 else {
            throw CalculatorError.moduloByZero
        }
        return number1.truncatingRemainder(dividingBy: number2)
    }

    // MARK: - Error Handling
    private enum CalculatorError: Error {
        case divideByZero
        case moduloByZero
        case invalidOperation
        case invalidArguments
    }

    // MARK: - Method Channel Setup
    private func setupCalculatorChannel(_ controller: FlutterViewController) {
        let calculatorChannel = FlutterMethodChannel(
            name: "com.example.calculator/math",
            binaryMessenger: controller.binaryMessenger)

        calculatorChannel.setMethodCallHandler { [weak self] call, result in
            self?.handleCalculatorMethod(call, result: result)
        }
    }

    // MARK: - Method Handler
    private func handleCalculatorMethod(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let number1 = args["number1"] as? Double,
              let number2 = args["number2"] as? Double,
              let operation = args["operation"] as? String else {
            result(FlutterError(code: "INVALID_ARGUMENTS",
                              message: "Arguments are invalid or missing",
                              details: nil))
            return
        }

        do {
            let calculationResult = try self.performOperation(operation, number1, number2)
            result(calculationResult)
        } catch let error as CalculatorError {
            let errorMessage = self.getErrorMessage(for: error)
            result(FlutterError(code: String(describing: error),
                              message: errorMessage,
                              details: nil))
        } catch {
            result(FlutterError(code: "UNKNOWN_ERROR",
                              message: "An unexpected error occurred",
                              details: nil))
        }
    }

    // MARK: - Operation Handler
    private func performOperation(_ operation: String, _ number1: Double, _ number2: Double) throws -> Double {
        switch operation {
        case "add":
            return add(number1, number2)
        case "subtract":
            return subtract(number1, number2)
        case "multiply":
            return multiply(number1, number2)
        case "divide":
            return try divide(number1, number2)
        case "modulo":
            return try modulo(number1, number2)
        default:
            throw CalculatorError.invalidOperation
        }
    }

    // MARK: - Error Message Handler
    private func getErrorMessage(for error: CalculatorError) -> String {
        switch error {
        case .divideByZero:
            return "Cannot divide by zero"
        case .moduloByZero:
            return "Cannot calculate modulo with zero"
        case .invalidOperation:
            return "Operation not supported"
        case .invalidArguments:
            return "Arguments are invalid or missing"
        }
    }

    // MARK: - Application Launch
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller = window?.rootViewController as! FlutterViewController
        setupCalculatorChannel(controller)

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}