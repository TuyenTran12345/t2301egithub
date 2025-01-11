import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../model/score.dart';
import '../model/student.dart';
import '../model/subject.dart';

class StudentManager {
  List<Student> students = [];

  final String initialJson = '''
  [
    {
      "id": 1,
      "name": "Truong Gia Binh",
      "subjects": [
        {
          "name": "Math",
          "scores": [
            {"value": 7},
            {"value": 9},
            {"value": 8}
          ]
        },
        {
          "name": "Physics",
          "scores": [
            {"value": 7},
            {"value": 8},
            {"value": 9}
          ]
        }
      ]
    },
    {
      "id": 2,
      "name": "Le Truong Tung",
      "subjects": [
        {
          "name": "Chemistry",
          "scores": [
            {"value": 6},
            {"value": 8},
            {"value": 7}
          ]
        },
        {
          "name": "Biology",
          "scores": [
            {"value": 5},
            {"value": 6},
            {"value": 7}
          ]
        }
      ]
    }
  ]
  ''';

  Future<void> loadStudents() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/Student.json');

    if (await file.exists()) {
      final jsonString = await file.readAsString();
      final List<dynamic> jsonList = json.decode(jsonString);
      students = jsonList.map((json) {
        final subjects = (json['subjects'] as List)
            .map((subjectJson) => Subject(
          subjectJson['name'],
          (subjectJson['scores'] as List)
              .map((scoreJson) => Score(scoreJson['value']))
              .toList(),
        ))
            .toList();
        return Student(json['id'], json['name'], subjects);
      }).toList();
    } else {
      final List<dynamic> jsonList = json.decode(initialJson);
      students = jsonList.map((json) {
        final subjects = (json['subjects'] as List)
            .map((subjectJson) => Subject(
          subjectJson['name'],
          (subjectJson['scores'] as List)
              .map((scoreJson) => Score(scoreJson['value']))
              .toList(),
        ))
            .toList();
        return Student(json['id'], json['name'], subjects);
      }).toList();
      await saveStudents();
    }
  }

  Future<void> saveStudents() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/Student.json');
    final jsonString = json.encode(students.map((student) => student.toJson()).toList());
    await file.writeAsString(jsonString);
  }
}