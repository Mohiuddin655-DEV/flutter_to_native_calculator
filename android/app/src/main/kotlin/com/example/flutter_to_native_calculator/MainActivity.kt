package com.example.flutter_to_native_calculator

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlin.math.roundToInt

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.calculator/math"

    // MARK: - Calculator Operations
    private fun add(number1: Double, number2: Double): Double {
        return number1 + number2
    }

    private fun subtract(number1: Double, number2: Double): Double {
        return number1 - number2
    }

    private fun multiply(number1: Double, number2: Double): Double {
        return number1 * number2
    }

    private fun divide(number1: Double, number2: Double): Result<Double> {
        return if (number2 == 0.0) {
            Result.failure(CalculatorError.DivideByZero())
        } else {
            Result.success(number1 / number2)
        }
    }

    private fun modulo(number1: Double, number2: Double): Result<Double> {
        return if (number2 == 0.0) {
            Result.failure(CalculatorError.ModuloByZero())
        } else {
            Result.success(number1 % number2)
        }
    }

    // MARK: - Error Handling
    sealed class CalculatorError : Exception() {
        class DivideByZero : CalculatorError()
        class ModuloByZero : CalculatorError()
        class InvalidOperation : CalculatorError()
        class InvalidArguments : CalculatorError()

        override val message: String
            get() = when (this) {
                is DivideByZero -> "Cannot divide by zero"
                is ModuloByZero -> "Cannot calculate modulo with zero"
                is InvalidOperation -> "Operation not supported"
                is InvalidArguments -> "Arguments are invalid or missing"
            }
    }

    // MARK: - Method Channel Setup
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        setupCalculatorChannel(flutterEngine)
    }

    private fun setupCalculatorChannel(flutterEngine: FlutterEngine) {
        val channel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        )
        channel.setMethodCallHandler { call, result ->
            handleCalculatorMethod(call, result)
        }
    }

    // MARK: - Method Handler
    private fun handleCalculatorMethod(
        call: MethodCall,
        result: MethodChannel.Result
    ) {
        try {
            val number1 = call.argument<Double>("number1")
            val number2 = call.argument<Double>("number2")
            val operation = call.argument<String>("operation")

            if (number1 == null || number2 == null || operation == null) {
                throw CalculatorError.InvalidArguments()
            }

            val calculationResult = performOperation(operation, number1, number2)
            when {
                calculationResult.isSuccess -> result.success(calculationResult.getOrNull())
                calculationResult.isFailure -> {
                    val error = calculationResult.exceptionOrNull() as? CalculatorError
                    result.error(
                        error?.javaClass?.simpleName ?: "UNKNOWN_ERROR",
                        error?.message ?: "An unexpected error occurred",
                        null
                    )
                }
            }
        } catch (e: Exception) {
            when (e) {
                is CalculatorError -> result.error(
                    e.javaClass.simpleName,
                    e.message,
                    null
                )
                else -> result.error(
                    "UNKNOWN_ERROR",
                    "An unexpected error occurred",
                    null
                )
            }
        }
    }

    // MARK: - Operation Handler
    private fun performOperation(
        operation: String,
        number1: Double,
        number2: Double
    ): Result<Double> {
        return try {
            when (operation) {
                "add" -> Result.success(add(number1, number2))
                "subtract" -> Result.success(subtract(number1, number2))
                "multiply" -> Result.success(multiply(number1, number2))
                "divide" -> divide(number1, number2)
                "modulo" -> modulo(number1, number2)
                else -> Result.failure(CalculatorError.InvalidOperation())
            }
        } catch (e: Exception) {
            Result.failure(e)
        }
    }
}