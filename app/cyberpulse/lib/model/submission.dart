import 'package:hive/hive.dart';
import 'dart:convert';

part 'submission.g.dart';


List<Submission> submissionListJson(String str) =>
    List<Submission>.from(json.decode(str).map((x) => Submission.fromJson(x)));

@HiveType(typeId: 0,adapterName: "SubmissionAdapter")
class Submission {
  @HiveField(0)
  final String? formId;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String email;
  @HiveField(3)
  final String birthDate;
  @HiveField(4)
  final String interestedArea;
  @HiveField(5)
  final String marketingUpdates;
  @HiveField(6)
  final String correspondence;
  @HiveField(7)
  final double? latitude;
  @HiveField(8)
  final double? longitude;
  @HiveField(9)
  final String submittedDate;

  Submission({
    this.formId,
    required this.name,
    required this.email,
    required this.birthDate,
    required this.interestedArea,
    required this.marketingUpdates,
    required this.correspondence,
    required this.latitude,
    required this.longitude,
    required this.submittedDate,
  });

  factory Submission.fromJson(Map<String, dynamic> json) {
    return Submission(
      formId: json['form_id'],
      name: json['name'],
      email: json['email'],
      birthDate: json['birth_date'],
      interestedArea: json['interested_area'],
      marketingUpdates: json['marketing_updates'],
      correspondence: json['correspondence'],
      latitude: double.parse(json['latitude']),
      longitude: double.parse(json['longitude']),
      submittedDate: json['submitted_date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'birth_date': birthDate,
      'interested_area': interestedArea,
      'marketing_updates': marketingUpdates,
      'correspondence': correspondence,
      'latitude': latitude,
      'longitude': longitude,
      'submitted_date': submittedDate,
    };
  }
  Submission copyWith({double? latitude, double? longitude}) {
    return Submission(
      formId: formId,
      name: name,
      email: email,
      birthDate: birthDate,
      interestedArea: interestedArea,
      marketingUpdates: marketingUpdates,
      correspondence: correspondence,
      latitude: latitude ?? latitude,
      longitude: longitude ?? longitude,
      submittedDate: submittedDate,
    );
  }
}