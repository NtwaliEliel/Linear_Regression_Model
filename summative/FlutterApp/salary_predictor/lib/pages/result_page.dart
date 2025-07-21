import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final double result;

  const ResultPage({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Prediction Result")),
      body: Center(
        child: Text(
          "Predicted Salary: \$${result.toStringAsFixed(2)}",
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
