import 'package:cyberpulse/model/subject.dart';
import 'package:hive/hive.dart';

import '../model/submission.dart';

class LocalRepository {
  static const String _boxName = 'submissions';
  static const String _boxNameSubject = 'subjects';

  Future<Box<Submission>> _openBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox<Submission>(_boxName);
    }
    return Hive.box<Submission>(_boxName);
  }

  Future<Box<Subject>> _openBoxSubject() async {
    if (!Hive.isBoxOpen(_boxNameSubject)) {
      return await Hive.openBox<Subject>(_boxNameSubject);
    }
    return Hive.box<Subject>(_boxNameSubject);
  }

  Future<void> addForm(Submission form) async {
    final box = await _openBox();
    await box.put(form.email, form);
  }

  Future<void> addSubject(Subject subject) async {
    final box = await _openBoxSubject();
    await box.put(subject.id, subject);
  }

  Future<void> removeFormById(String formId) async {
    final box = await _openBox();
    await box.delete(formId);
  }

  Future<List<Submission>> getAllForms() async {
    final box = await _openBox();
    return box.values.toList();
  }

  Future<List<Subject>> getAllSubject() async {
    final box = await _openBoxSubject();
    return box.values.toList();
  }

  Future<Submission?> getFormById(String formId) async {
    final box = await _openBox();
    return box.get(formId);
  }

  Future<void> removeAllForms() async {
    final box = await _openBox();
    await box.clear();
  }

  Future<void> saveAllSubmissions(List<Submission> submissions) async {
    final box = await _openBox();
    await box.clear(); // Clear the existing data
    for (var submission in submissions) {
      await box.put(submission.email, submission); // Use email as the key
    }
  }

  Future<void> saveAllSubjects(List<Subject> subjects) async {
    final box = await _openBoxSubject();
    await box.clear(); // Clear the existing data
    for (var subject in subjects) {
      await box.put(subject.id, subject); // Use id as the key
    }
  }
}