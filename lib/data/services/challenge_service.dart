import 'dart:convert';
import 'package:fitsteps_app/data/models/challenge_history_model.dart';
import 'package:http/http.dart' as http;
import '../models/challenge_model.dart';

class ChallengeService {
  final String baseUrl = 'http://10.0.2.2:8000/api';

  Future<List<Challenge>> fetchChallenges(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/challenges'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => Challenge.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat challenge');
    }
  }

  Future<void> addChallenge({
    required String token,
    required String title,
    required String description,
    required int targetSteps,
    required int durationDays,
  }) async {
    final url = Uri.parse('$baseUrl/challenges');
    final response = await http.post(
      url,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      body: {
        'title': title,
        'description': description,
        'target_steps': targetSteps.toString(),
        'duration_days': durationDays.toString(),
      },
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Gagal tambah challenge');
    }
  }

  Future<void> updateChallenge({
    required String token,
    required int id,
    required String title,
    required String description,
    required int targetSteps,
    required int durationDays,
  }) async {
    final url = Uri.parse('$baseUrl/challenges/$id');
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json', // <== Tambahkan ini
      },
      body: jsonEncode({
        'title': title,
        'description': description,
        'target_steps': targetSteps,
        'duration_days': durationDays,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal update challenge: ${response.body}');
    }
  }

  Future<void> deleteChallenge({required String token, required int id}) async {
    final url = Uri.parse('$baseUrl/challenges/$id');
    final response = await http.delete(
      url,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal hapus challenge');
    }
  }

  Future<List<Map<String, dynamic>>> getParticipants(
    String token,
    int id,
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/challenges/$id/participants'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(jsonData['participants']);
    } else {
      throw Exception('Gagal mengambil peserta');
    }
  }

  Future<void> joinChallenge({
    required String token,
    required int challengeId,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/challenges/$challengeId/join'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal mengikuti challenge');
    }
  }

  Future<List<Challenge>> getMyChallenges(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/challenges/my'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => Challenge.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat challenge saya');
    }
  }

  Future<List<Challenge>> fetchMyChallenges(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/challenges/my'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);

      final ongoing = jsonData['ongoing'] as List<dynamic>;
      final completed = jsonData['completed'] as List<dynamic>;

      final combined = [...ongoing, ...completed];

      return combined.map((e) => Challenge.fromJson(e['challenge'])).toList();
    } else {
      throw Exception('Gagal memuat my challenges');
    }
  }

  Future<List<ChallengeHistoryModel>> getHistory(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/challenges/history'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((item) => ChallengeHistoryModel.fromJson(item)).toList();
    } else {
      throw Exception('Gagal memuat riwayat tantangan');
    }
  }
}
