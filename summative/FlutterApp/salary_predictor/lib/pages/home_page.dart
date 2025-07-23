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
  final companySizes = {
    "S": "SMALL",
    "M": "MEDIUM",
    "L": "LARGE"
  };
  final experienceLevels = {
    "EN": "Entry level",
    "MI": "Mid/Intermediate level",
    "SE": "Senior",
    "EX": "Executive level"
  };
  final employmentTypes = {
    "FT": "Full-time",
    "PT": "Part-time",
    "CT": "Contractor",
    "FL": "Freelancer"
  };
  final remoteRatios = {
    0: "On-Site",
    50: "Half-Remote",
    100: "Full-Remote"
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Salary Predictor", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: experienceLevel,
                items: experienceLevels.entries
                    .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value)))
                    .toList(),
                onChanged: (val) => setState(() => experienceLevel = val),
                decoration: InputDecoration(labelText: "Experience Level"),
                validator: (val) => val == null ? "Required" : null,
              ),
              DropdownButtonFormField<String>(
                value: employmentType,
                items: employmentTypes.entries
                    .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value)))
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
                items: companySizes.entries
                    .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value)))
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
                    Text("Remote Ratio: ${remoteRatios[remoteRatio]!}"),
                    DropdownButtonFormField<int>(
                      value: remoteRatio,
                      items: remoteRatios.entries
                          .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value)))
                          .toList(),
                      onChanged: (val) => setState(() => remoteRatio = val!),
                      decoration: InputDecoration(labelText: "Remote Ratio"),
                      validator: (val) => val == null ? "Required" : null,
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 2,
                ),
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
                child: const Text("Predict", style: TextStyle(fontWeight: FontWeight.bold)),
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
