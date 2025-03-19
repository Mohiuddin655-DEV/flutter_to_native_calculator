import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'platform_interface.dart';

class MethodChannelCalculator extends CalculatorPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('com.example.calculator/math');

  @override
  Future<double> calculate({
    required String operation,
    required double number1,
    required double number2,
  }) async {
    final Map<String, dynamic> arguments = {
      'operation': operation,
      'number1': number1,
      'number2': number2,
    };

    try {
      final result = await methodChannel.invokeMethod<double>(
        'calculate',
        arguments,
      );
      return result ?? 0.0;
    } catch (e) {
      if (e is PlatformException) {
        throw Exception(e.message);
      }
      throw Exception('Failed to perform calculation');
    }
  }
}
