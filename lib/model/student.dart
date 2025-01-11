import 'package:exam_dart/model/subject.dart';

class Student {
  final int id;
  String name;
  List<Subject> subjects;

  Student(this.id, this.name, this.subjects);

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'subjects': subjects.map((subject) => subject.toJson()).toList(),
  };
}