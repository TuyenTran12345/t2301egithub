import 'package:exam_dart/service/student_manager.dart';
import '../model/student.dart';
import '../model/subject.dart';

class StudentManagement {
  final StudentManager studentManager = StudentManager();

  Future<void> loadStudents() async {
    await studentManager.loadStudents();
  }

  Future<void> addStudent(String name, List<Subject> subjects) async {
    int id = studentManager.students.length + 1;
    studentManager.students.add(Student(id, name,subjects));
    await studentManager.saveStudents();
  }

  Future<void> editStudent(int id, String newName, List<Subject> newSubjects) async {
    Student? student = studentManager.students.firstWhere((s) => s.id == id);
    if (student != null) {
      student.name = newName;
      student.subjects = newSubjects;
      await studentManager.saveStudents();
    }
  }

  List<Student> getStudents() {
    return studentManager.students;
  }
}