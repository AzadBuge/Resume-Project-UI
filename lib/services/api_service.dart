import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:resume_generator_project/models/resume_model.dart';

class ApiService {
  final String baseUrl = "http://localhost:8080/api/resume";

  Future<void> createResume(Resume resume) async {
    await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(resume.toJson()), // ✅ FIX
    );
  }

  Future<List<Resume>> getResumes() async {
    final res = await http.get(Uri.parse(baseUrl));

    if (res.statusCode == 200) {
      List data = jsonDecode(res.body);

      return data.map((e) => Resume.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load resumes");
    }
  }

  Future<void> deleteResume(int id) async {
    await http.delete(Uri.parse("$baseUrl/$id"));
  }
}