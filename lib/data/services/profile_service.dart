import 'dart:convert';
import 'package:fitsteps_app/data/models/user_model.dart';
import 'package:http/http.dart' as http;

class ProfileService {
  final String baseUrl =
      'http://10.0.2.2:8000/api'; // Ganti jika pakai device lain

  Future<UserModel> getProfile(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/profile'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Gagal mengambil data profil: ${response.statusCode}');
    }
  }
}
