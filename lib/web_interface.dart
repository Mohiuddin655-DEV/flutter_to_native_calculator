import 'dart:async';

import 'platform_interface.dart';

class CalculatorWeb extends CalculatorPlatform {
  @override
  Future<double> calculate({
    required String operation,
    required double number1,
    required double number2,
  }) async {
    switch (operation) {
      case 'add':
        return number1 + number2;
      case 'subtract':
        return number1 - number2;
      case 'multiply':
        return number1 * number2;
      case 'divide':
        if (number2 == 0) {
          throw Exception('Cannot divide by zero');
        }
        return number1 / number2;
      case 'modulo':
        if (number2 == 0) {
          throw Exception('Cannot calculate modulo with zero');
        }
        return number1 % number2;
      default:
        throw Exception('Invalid operation');
    }
  }
}
