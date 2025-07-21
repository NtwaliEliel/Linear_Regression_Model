import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'result_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final experienceController = TextEditingController();
  final employmentController = TextEditingController();
  final companySizeController = TextEditingController();
  final remoteRatioController = TextEditingController();
  final yearController = TextEditingController();

  String? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Salary Predictor")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              buildField("Experience Level (1-4)", experienceController),
              buildField("Employment Type (1-4)", employmentController),
              buildField("Company Size (1-3)", companySizeController),
              buildField("Remote Ratio (0-100)", remoteRatioController),
              buildField("Work Year", yearController),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final prediction = await ApiService.predict({
                      "experience_level": int.parse(experienceController.text),
                      "employment_type": int.parse(employmentController.text),
                      "company_size": int.parse(companySizeController.text),
                      "remote_ratio": int.parse(remoteRatioController.text),
                      "work_year": int.parse(yearController.text),
                    });

                    if (prediction != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ResultPage(result: prediction),
                        ),
                      );
                    } else {
                      setState(() {
                        error = "Failed to fetch prediction. Check input or connection.";
                      });
                    }
                  }
                },
                child: const Text("Predict"),
              ),
              if (error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(error!, style: const TextStyle(color: Colors.red)),
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Required';
          }
          return null;
        },
      ),
    );
  }
}
