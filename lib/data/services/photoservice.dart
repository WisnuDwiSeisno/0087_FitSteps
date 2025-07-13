import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class PhotoService {
  final String baseUrl = 'http://10.0.2.2:8000/api';

  Future<void> uploadPhoto(String token, File photo) async {
    final uri = Uri.parse('$baseUrl/photos');

    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..headers['Accept'] = 'application/json'
      ..files.add(
        await http.MultipartFile.fromPath(
          'photo', // ganti sesuai nama field di backend
          photo.path,
          filename: basename(photo.path),
        ),
      );

    final response = await request.send();

    if (response.statusCode != 200) {
      throw Exception('Gagal upload foto');
    }
  }
}
