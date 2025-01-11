import 'package:exam_dart/model/score.dart';

class Subject {
  final String name;
  final List<Score> scores;

  Subject(this.name, this.scores);

  Map<String, dynamic> toJson() => {
    'name': name,
    'scores': scores.map((score) => score.toJson()).toList(),
  };
}