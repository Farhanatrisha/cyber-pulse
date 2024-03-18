import 'dart:convert';
import 'package:cyberpulse/model/subject.dart';
import 'package:cyberpulse/model/submission.dart';
import 'package:cyberpulse/repository/local_repository.dart';
import 'package:cyberpulse/repository/remote_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:localstorage/localstorage.dart';
import 'package:location/location.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:logger/logger.dart';

import '../main.dart';
import '../model/api_response.dart';
import '../widgets/toast.dart';

class AppController extends ChangeNotifier {
  FToast fToast = FToast();
  final LocalStorage store;
  List<Submission> localSubmissions = List.empty();
  List<Subject> localSubjects = List.empty();
  List<Subject> remoteSubjects = List.empty();
  List<Submission> remoteSubmissions = List.empty();

  late RemoteRepository apiService;
  late LocalRepository localRepository;

  late PermissionStatus _permissionGranted;
  bool _serviceEnabled = false;
  bool addFormLoading = false;


  Map<String?, int?> taskMap = {};
  var log = Logger();

  AppController(this.store) {
    apiService = RemoteRepository(store);
    localRepository = LocalRepository();
  }


  Future<void> saveFormToLocal(Submission form) async {
    addFormLoading = true;
    notifyListeners();
    Location? location = await getLocation();
    if (location != null) {
      LocationData currentPosition = await location.getLocation();
      await localRepository.addForm(form.copyWith(
          latitude: currentPosition.latitude,
          longitude: currentPosition.longitude));
      addFormLoading = false;
      notifyListeners();
      fToast.init(navigatorKey.currentContext!);
      fToast.showToast(
        child: showSuccessToast("Submission Added "),
        gravity: ToastGravity.TOP_RIGHT,
        toastDuration: const Duration(seconds: 2),
      );// Access the response data
    }
  }

  Future<void> getAllLocalSubmission() async {
    localSubmissions = await localRepository.getAllForms();
    notifyListeners();
  }

  Future<void> getAllLocalSubject() async {
    localSubjects = await localRepository.getAllSubject();
    notifyListeners();
  }

  Future<void> getFromRemote()async{
    var response = await apiService.getAllSubmission();
    if (response.status == ApiResponseStatus.success) {
      remoteSubmissions = submissionListJson(json.encode(response.data));
      localSubmissions.clear();
      localSubmissions.addAll(remoteSubmissions);
      notifyListeners();
    } else if (response.status == ApiResponseStatus.error) {
      log.e('error');
      log.d(response.data);
      fToast.init(navigatorKey.currentContext!);
      fToast.showToast(
        child: showErrorToast(response.data['message']),
        gravity: ToastGravity.TOP_RIGHT,
        toastDuration: const Duration(seconds: 3),
      ); // Access the error data
    }

  }

  Future<bool> login(String email, String password) async {
    ApiResponse response = await apiService.login(email, password);
    if (response.status == ApiResponseStatus.success) {
      log.i('success');
      saveToken(response.data['token']);
      notifyListeners();
      // Access the response data
      return true;
    } else {
      log.e('error');
      fToast.init(navigatorKey.currentContext!);
      fToast.showToast(
        child: showErrorToast(response.data['message']),
        gravity: ToastGravity.TOP_RIGHT,
        toastDuration: const Duration(seconds: 2),
      );
    }
    return false;
  }

  bool saveToken(String token) {
    log.i("token saved");
    store.setItem("JwtToken", token);
    return true;
  }

  Future<Location?> getLocation() async {
    Location location = Location();
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        fToast.init(navigatorKey.currentContext!);
        fToast.showToast(
          child: showErrorToast("location service disabled"),
          gravity: ToastGravity.TOP_RIGHT,
          toastDuration: const Duration(seconds: 3),
        );
        return null;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        fToast.init(navigatorKey.currentContext!);
        fToast.showToast(
          child: showErrorToast("location permission denied"),
          gravity: ToastGravity.TOP_RIGHT,
          toastDuration: const Duration(seconds: 3),
        );
        return null;
      }
    }
    return location;
  }

  void syncAll() async {
    await syncSubject();
    await  sendLocal();
    await getFromRemote();
    await addAllToLocal();
  }

  Future<void> syncSubject() async {
    var response = await apiService.getAllSubjects();
      if (response.status == ApiResponseStatus.success) {
        remoteSubjects = subjectListJson(json.encode(response.data));
        localSubjects = remoteSubjects;
        notifyListeners();
      } else if (response.status == ApiResponseStatus.error) {
        log.e('error');
        log.d(response.data);
        fToast.init(navigatorKey.currentContext!);
        fToast.showToast(
          child: showErrorToast(response.data['message']),
          gravity: ToastGravity.TOP_RIGHT,
          toastDuration: const Duration(seconds: 3),
        );
      }
      await localRepository.saveAllSubjects(remoteSubjects);
  }


  Future<void> sendLocal() async {
    List<Future<void>> futures = localSubmissions.map((submission) => sendSubmission(submission)).toList();
    await Future.wait(futures);
  }

  Future<void> sendSubmission(Submission submission) async{
    await apiService.addSubmission(submission);
  }
  Future<void> addAllToLocal() async{
    await localRepository.saveAllSubmissions(localSubmissions);
  }


}
