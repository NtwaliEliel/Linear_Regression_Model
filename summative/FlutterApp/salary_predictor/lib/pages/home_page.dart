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

  // Dropdown values
  String? experienceLevel;
  String? employmentType;
  String? jobTitle;
  String? employeeResidence;
  String? companyLocation;
  String? companySize;
  int remoteRatio = 0;

  String? error;

  final jobTitles = [
    "Data Scientist", "Data Engineer", "ML Engineer", // ...add more as needed
  ];
  final locations = ["US", "GB", "IN", "DE", "CA"]; // Example country codes
  final companySizes = ["S", "M", "L"];
  final experienceLevels = ["EN", "MI", "SE", "EX"];
  final employmentTypes = ["FT", "PT", "CT", "FL"];

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
              DropdownButtonFormField<String>(
                value: experienceLevel,
                items: experienceLevels
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => experienceLevel = val),
                decoration: InputDecoration(labelText: "Experience Level"),
                validator: (val) => val == null ? "Required" : null,
              ),
              DropdownButtonFormField<String>(
                value: employmentType,
                items: employmentTypes
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => employmentType = val),
                decoration: InputDecoration(labelText: "Employment Type"),
                validator: (val) => val == null ? "Required" : null,
              ),
              DropdownButtonFormField<String>(
                value: jobTitle,
                items: jobTitles
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => jobTitle = val),
                decoration: InputDecoration(labelText: "Job Title"),
                validator: (val) => val == null ? "Required" : null,
              ),
              DropdownButtonFormField<String>(
                value: employeeResidence,
                items: locations
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => employeeResidence = val),
                decoration: InputDecoration(labelText: "Employee Residence"),
                validator: (val) => val == null ? "Required" : null,
              ),
              DropdownButtonFormField<String>(
                value: companyLocation,
                items: locations
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => companyLocation = val),
                decoration: InputDecoration(labelText: "Company Location"),
                validator: (val) => val == null ? "Required" : null,
              ),
              DropdownButtonFormField<String>(
                value: companySize,
                items: companySizes
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => companySize = val),
                decoration: InputDecoration(labelText: "Company Size"),
                validator: (val) => val == null ? "Required" : null,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Remote Ratio: $remoteRatio"),
                    Slider(
                      value: remoteRatio.toDouble(),
                      min: 0,
                      max: 100,
                      divisions: 100,
                      label: "$remoteRatio",
                      onChanged: (val) => setState(() => remoteRatio = val.toInt()),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final prediction = await ApiService.predict({
                      "experience_level": experienceLevel,
                      "employment_type": employmentType,
                      "job_title": jobTitle,
                      "employee_residence": employeeResidence,
                      "remote_ratio": remoteRatio,
                      "company_location": companyLocation,
                      "company_size": companySize,
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
}
