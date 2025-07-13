import 'package:http/http.dart' as http;
import 'dart:convert';

class TrackingService {
  final String baseUrl = 'http://10.0.2.2:8000/api';

  Future<void> saveSteps(
    String token,
    int steps,
    String date,
    double? distance, int durationMin,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/steps'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'date': date,
        'steps': steps,
        'distance_km': distance ?? 0.0,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal menyimpan langkah: ${response.body}');
    }
  }

  Future<void> saveRoute(
    String token,
    List<Map<String, dynamic>> coordinates,
    String date,
    double distanceKm,
    int durationMin,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/routes'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'date': date,
        'path': coordinates,
        'distance_km': distanceKm,
        'duration_min': durationMin,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal menyimpan rute: ${response.body}');
    }
  }
}
