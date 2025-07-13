import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/tip_model.dart';

class TipService {
  final String baseUrl = 'http://10.0.2.2:8000/api';

  // Ambil semua tips
  Future<List<TipModel>> getTips(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/tips'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => TipModel.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat tips');
    }
  }

  // Tambah tip (mentor only)
  Future<void> addTip(String token, String title, String content) async {
    final response = await http.post(
      Uri.parse('$baseUrl/tips'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      body: {'title': title, 'content': content},
    );

    if (response.statusCode != 200) {
      final data = json.decode(response.body);
      throw Exception(data['error'] ?? 'Gagal menambahkan tip');
    }
  }

  Future<void> updateTip(
    String token,
    int id,
    String title,
    String content,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/tips/$id'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      body: {'title': title, 'content': content},
    );

    if (response.statusCode != 200) {
      final data = json.decode(response.body);
      throw Exception(data['error'] ?? 'Gagal mengedit tip');
    }
  }

  Future<void> deleteTip(String token, int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/tips/$id'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode != 200) {
      final data = json.decode(response.body);
      throw Exception(data['error'] ?? 'Gagal menghapus tip');
    }
  }
}
