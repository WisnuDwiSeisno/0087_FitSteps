import 'dart:convert';
import 'package:http/http.dart' as http;

class StepsStatService {
  final String baseUrl = 'http://10.0.2.2:8000/api';

  Future<Map<String, int>> getWeeklyStats(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/steps/weekly'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      return {
        for (var item in data)
          item['date'] as String: int.parse(item['steps'].toString()),
      };
    } else {
      throw Exception('Gagal memuat data statistik');
    }
  }

}
