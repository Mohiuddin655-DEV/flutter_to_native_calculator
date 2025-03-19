import 'package:flutter/material.dart';

import 'platform_interface.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _number1Controller = TextEditingController();
  final TextEditingController _number2Controller = TextEditingController();
  String _result = 'Result: ';

  Future<void> _performOperation(String operation) async {
    try {
      final double num1 = double.parse(_number1Controller.text);
      final double num2 = double.parse(_number2Controller.text);

      final double result = await CalculatorPlatform.instance.calculate(
        operation: operation,
        number1: num1,
        number2: num2,
      );

      setState(() {
        _result = 'Result: $result';
      });
    } catch (e) {
      setState(() {
        _result = 'Error: ${e.toString()}';
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
