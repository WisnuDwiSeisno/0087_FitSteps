import 'dart:convert';
import 'package:http/http.dart' as http;

class StepsService {
  final String baseUrl = 'http://10.0.2.2:8000/api';

  Future<void> submitSteps(String token, int steps, String date) async {
    final response = await http.post(
      Uri.parse('$baseUrl/steps'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      body: {'steps': steps.toString(), 'date': date},
    );

    if (response.statusCode != 200) {
      final data = json.decode(response.body);
      throw Exception(data['message'] ?? 'Gagal menambahkan langkah');
    }
  }

}
