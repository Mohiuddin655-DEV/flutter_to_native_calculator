import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:js' as js show context;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Native Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final TextEditingController _number1Controller = TextEditingController();
  final TextEditingController _number2Controller = TextEditingController();
  String _result = 'Result: ';

  // Method channel for native communication
  static const platform = MethodChannel('com.example.calculator/math');

  Future<void> _performOperation(String operation) async {
    try {
      final double num1 = double.parse(_number1Controller.text);
      final double num2 = double.parse(_number2Controller.text);

      // Check if running on web
      if (identical(0, 0.0)) {
        // Web implementation
        final result = js.context.callMethod('calculate', [operation, num1, num2]);

        if (result['success'] == true) {
          setState(() {
            _result = 'Result: ${result['result']}';
          });
        } else {
          setState(() {
            _result = 'Error: ${result['error']}';
          });
        }
      } else {
        // Mobile implementation
        final Map<String, dynamic> arguments = {
          'number1': num1,
          'number2': num2,
          'operation': operation,
        };

        final double result = await platform.invokeMethod('calculate', arguments);
        setState(() {
          _result = 'Result: $result';
        });
      }
    } on PlatformException catch (e) {
      setState(() {
        _result = 'Error: ${e.message}';
      });
    } catch (e) {
      setState(() {
        _result = 'Error: Invalid input';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Native Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _number1Controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter the first number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _number2Controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter the second number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _performOperation('add'),
                  child: const Text('Add'),
                ),
                ElevatedButton(
                  onPressed: () => _performOperation('subtract'),
                  child: const Text('Subtract'),
                ),
                ElevatedButton(
                  onPressed: () => _performOperation('multiply'),
                  child: const Text('Multiply'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _performOperation('divide'),
                  child: const Text('Divide'),
                ),
                ElevatedButton(
                  onPressed: () => _performOperation('modulo'),
                  child: const Text('Modulus'),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              _result,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}