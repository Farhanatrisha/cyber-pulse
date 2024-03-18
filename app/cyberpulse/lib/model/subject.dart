import 'dart:convert';

import 'package:hive/hive.dart';

part 'subject.g.dart';

List<Subject> subjectListJson(String str) =>
    List<Subject>.from(json.decode(str).map((x) => Subject.fromJson(x)));

@HiveType(typeId: 1, adapterName: 'SubjectAdapter')
class Subject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String subjectName;

  Subject({
    required this.id,
    required this.subjectName,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['id'],
      subjectName: json['subject_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject_name': subjectName,
    };
  }
}