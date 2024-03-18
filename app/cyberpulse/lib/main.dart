import 'package:cyberpulse/model/subject.dart';
import 'package:cyberpulse/model/submission.dart';
import 'package:cyberpulse/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

import 'controller/app_controller.dart';
GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  LocalStorage store = LocalStorage('cyberpulse');
  await store.ready;
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(SubmissionAdapter());
  Hive.registerAdapter(SubjectAdapter());
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => AppController(store)),
    ],
    child: const MyApp(), // Don't need to wrap with MaterialApp here
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      builder: FToastBuilder(),
      title: 'Cyberpulse University',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
