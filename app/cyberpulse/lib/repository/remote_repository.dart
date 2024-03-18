import 'dart:typed_data';

import 'package:cyberpulse/model/submission.dart';
import 'package:dio/dio.dart';
import 'package:localstorage/localstorage.dart';

import 'package:logger/logger.dart';

import '../model/api_response.dart';

class RemoteRepository {
  static const String _baseUrl = "http://10.0.2.2:80/cyber-pulse/backend/app/v1";
  static const String _loginUrl = "$_baseUrl/admin_login";
  static const String _forms = "$_baseUrl/show_all_form_data";

  static const String _subjects = "$_baseUrl/show_subject_area";
  static const String fileUrl = "$_baseUrl/file/";
  static const String _subMissionUrl = "$_baseUrl/add_form_data";
  final LocalStorage _store;
  Logger log = Logger();

  late Dio _dio;


  RemoteRepository(this._store) {
    _dio = Dio();
  }

  Options _getOptions() {
    final token = _store.getItem("JwtToken");
    return Options(
      headers: {
        'Authorization': '$token',
      },
    );
  }


  Future<ApiResponse> login(String email, String password) async {
    try {
      final response = await _dio.post(_loginUrl, data: {
        "admin_email": email,
        "admin_password": password,
      });
      return ApiResponse.success(response.data);
    } on DioException catch (ex) {
      return ApiResponse.error(ex.response?.data);
    }
  }

  Future<ApiResponse> getAllSubjects() async {
    try {
      final options = _getOptions();
      final Response response = await _dio.get("$_subjects/",options: options);
      return ApiResponse.success(response.data['data']);
    } on DioException catch (ex) {
      return ApiResponse.error(ex.response?.data);
    }
  }
  Future<ApiResponse> getAllSubmission() async {
    try {
      final options = _getOptions();
      final Response response = await _dio.get(_forms,options: options);
      return ApiResponse.success(response.data['data']);
    } on DioException catch (ex) {
      return ApiResponse.error(ex.response?.data);
    }
  }
  Future<ApiResponse> addSubmission(Submission submission) async {
    try {
      final options = _getOptions();
      final Response response =
      await _dio.post(_subMissionUrl, data: submission.toJson(), options: options);
      return ApiResponse.success(response.data);
    } on DioException catch (ex) {
      return ApiResponse.error(ex.response?.data);
    }
  }
}
