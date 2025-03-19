import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'method_channel.dart';

abstract class CalculatorPlatform extends PlatformInterface {
  CalculatorPlatform() : super(token: _token);

  static final Object _token = Object();
  static CalculatorPlatform _instance = MethodChannelCalculator();

  static CalculatorPlatform get instance => _instance;

  static set instance(CalculatorPlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  Future<double> calculate({
    required String operation,
    required double number1,
    required double number2,
  }) {
    throw UnimplementedError('calculate() has not been implemented.');
  }
}
