import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String apiUrl = "https://linear-regression-model-b50s.onrender.com/predict"; 

  static Future<double?> predict(Map<String, dynamic> inputData) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode(inputData),
      );

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        return body['prediction'] * 1.0;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
