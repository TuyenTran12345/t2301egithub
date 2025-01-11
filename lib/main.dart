import 'package:exam_dart/model/student.dart';
import 'package:flutter/material.dart';
import 'model/score.dart';
import 'model/subject.dart';
import 'service/student_management.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Management',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Student Management Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final StudentManagement studentManagement = StudentManagement();
  List<Student> _students = [];

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    await studentManagement.loadStudents();
    setState(() {
      _students = studentManagement.getStudents();
    });
  }

  void _addStudent() {
    showDialog(
      context: context,
      builder: (context) {
        String name = '';
        List<Subject> subjects = [];
        return AlertDialog(
          title: const Text('Add Student'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  name = value;
                },
                decoration: const InputDecoration(hintText: 'Enter student name'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Add a new subject
                  String subjectName = '';
                  List<Score> scores = [];
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Add Subject'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              onChanged: (value) {
                                subjectName = value;
                              },
                              decoration: const InputDecoration(hintText: 'Enter subject name'),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  scores.add(Score(int.parse(value)));
                                }
                              },
                              decoration: const InputDecoration(hintText: 'Enter score'),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              if (subjectName.isNotEmpty) {
                                setState(() {
                                  subjects.add(Subject(subjectName, scores));
                                });
                                Navigator.of(context).pop();
                              }
                            },
                            child: const Text('Add Subject'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('Add Subject'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (name.isNotEmpty) {
                  await studentManagement.addStudent(name, subjects);
                  _loadStudents();
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _editStudent(int id) {
    Student? student = _students.firstWhere((s) => s.id == id);
    String newName = student.name;
    List<Subject> newSubjects = List.from(student.subjects);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: const Text('Edit Student'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (value) {
                    newName = value;
                  },
                  decoration: const InputDecoration(hintText: 'Enter new name'),
                  controller: TextEditingController(text: student.name),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // Add a new subject
                    String subjectName = '';
                    List<Score> scores = [];
                    showDialog(
                        context: context, builder: (context) {
                      return AlertDialog(
                        title: const Text('Add Subject'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              onChanged: (value) {
                                subjectName = value;
                              },
                              decoration: const InputDecoration(hintText: 'Enter subject name'),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  scores.add(Score(int.parse(value)));
                                }
                              },
                              decoration: const InputDecoration(hintText: 'Enter score'),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              if (subjectName.isNotEmpty) {
                                setState(() {
                                  newSubjects.add(Subject(subjectName, scores));
                                });
                                Navigator.of(context).pop();
                              }
                            },
                            child: const Text('Add Subject'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                        ],
                      );
                    },
                    );
                  },
                  child: const Text('Add Subject'),
                ),
              ],
            ),
            actions: [
            TextButton(
            onPressed: () async {
          await studentManagement.editStudent(student.id, newName, newSubjects);
          _loadStudents(); // Refresh the student list
          Navigator.of(context).pop();
        },
        child: const Text('Save'),
        ),
        TextButton(
        onPressed: () {
        Navigator.of(context).pop();
        },
        child: const Text('Cancel'),
        )
      ],
    );
  },
  );
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(widget.title),
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: _addStudent,
        ),
      ],
    ),
    body: ListView.builder(
      itemCount: _students.length,
      itemBuilder: (context, index) {
        final student = _students[index];
        return ListTile(
          title: Text(student.name),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: student.subjects.map((subject) {
              return Text('${subject.name}: ${subject.scores.map((score) => score.value).join(', ')}');
            }).toList(),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _editStudent(student.id),
          ),
        );
      },
    ),
  );
}
}