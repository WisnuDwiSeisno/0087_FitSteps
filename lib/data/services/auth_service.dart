import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl =
      'http://10.0.2.2:8000/api'; // ganti jika pakai device fisik

  Future<String> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Accept': 'application/json'},
      body: {'email': email, 'password': password},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['token'];
    } else {
      final data = json.decode(response.body);
      throw Exception(data['error'] ?? 'Login failed');
    }
  }

  Future<Map<String, dynamic>> getProfile(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/auth/me'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Gagal mengambil data profil');
    }
  }

  Future<void> logout(String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/logout'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal logout');
    }
  }

  Future<void> register(
    String name,
    String email,
    String password,
    String confirmPassword,
    String role,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Accept': 'application/json'},
      body: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': confirmPassword,
        'role': role, // 🔥 WAJIB SESUAI DENGAN BACKEND
      },
    );

    if (response.statusCode != 200) {
      final data = json.decode(response.body);
      throw Exception(data['message'] ?? 'Registrasi gagal');
    }
  }

  Future<void> updateProfile(String token, String name) async {
    final response = await http.put(
      Uri.parse('$baseUrl/profile'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      body: {'name': name},
    );

    if (response.statusCode != 200) {
      final data = json.decode(response.body);
      throw Exception(data['message'] ?? 'Gagal update profil');
    }
  }
}
