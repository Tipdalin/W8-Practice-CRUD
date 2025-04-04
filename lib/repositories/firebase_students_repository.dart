import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../dto/student_dto.dart';
import '../models/student.dart';
import 'student_repository.dart';

class FirebaseStudentsRepository extends StudentRepository {
  static const String baseUrl = 'https://w8-practice-crud-4366f-default-rtdb.asia-southeast1.firebasedatabase.app/';
  static const String stuUrl = '$baseUrl/student.json';

  @override
  Future<Student> addStudent({
    required String firstName,
    required String gender,
    required String lastName,
  }) async {
    Uri uri = Uri.parse(stuUrl);
    final newStudentData = {
      'firstName': firstName,
      'gender': gender,
      'lastName': lastName,
    };

    final http.Response response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(newStudentData),
    );

    if (response.statusCode != HttpStatus.ok &&
        response.statusCode != HttpStatus.created) {
      throw Exception('Failed to add student');
    }

    final newId = json.decode(response.body)['name'];
    return Student(
      id: newId,
      firstName: firstName,
      gender: gender,
      lastName: lastName,
    );
  }

  @override
  Future<List<Student>> getStudent() async {
    Uri uri = Uri.parse(stuUrl);
    final http.Response response = await http.get(uri);

    if (response.statusCode != HttpStatus.ok) {
      throw Exception('Failed to load students');
    }

    final decoded = json.decode(response.body);
    if (decoded == null || decoded is! Map<String, dynamic>) {
      return [];
    }

    return decoded.entries
        .map((entry) => StudentDto.fromJson(entry.key, entry.value))
        .toList();
  }

  @override
  Future<Student> updateStudent({required Student student}) async {
    final updateUrl = '$baseUrl/student/${student.id}.json';
    final uri = Uri.parse(updateUrl);
    final http.Response response = await http.patch(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(student.toJson()),
    );

    if (response.statusCode != HttpStatus.ok) {
      throw Exception('Failed to update student');
    }

    return student;
  }

  @override
  Future<void> deleteStudent({required String id}) async {
    final deleteUrl = '$baseUrl/student/$id.json';
    final uri = Uri.parse(deleteUrl);
    final http.Response response = await http.delete(uri);

    if (response.statusCode != HttpStatus.ok) {
      throw Exception('Failed to delete student');
    }
  }
}
