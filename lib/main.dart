import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_app_with_firebase/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todo_app_with_firebase/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      statusBarColor: Colors.black45));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ToDo with Firebase',
        theme: ThemeData(
          brightness: Brightness.dark,
          appBarTheme: const AppBarTheme(color: Colors.black54),
          primarySwatch: Colors.blue,
        ),
        home: Home());
  }
}
