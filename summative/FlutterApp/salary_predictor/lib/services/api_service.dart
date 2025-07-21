import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://linear-regression-model-b50s.onrender.com";

  static Future<double?> predict(Map<String, dynamic> inputData) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/predict"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(inputData),
      );

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        return body['predicted_salary_usd'] * 1.0;
      } else {
        print('Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}
