import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app/screens/home_page.dart';
import 'package:app/screens/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/screens/student_course_list.dart';
import 'package:app/screens/teacher_course_list.dart';

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      // home: StudentCourseList(),
      // home: TeacherCourseList(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late SharedPreferences _sharedPreferences;

  @override
  void initState() {
    super.initState();

    isLogin();
  }

  void isLogin() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    Timer(const Duration(seconds: 3), () {
      if (_sharedPreferences.getInt('userid') == null &&
          _sharedPreferences.getString('usermail') == null) {
        Route route = MaterialPageRoute(builder: (_) => const LoginPage());
        Navigator.pushReplacement(context, route);
      } else {
        Route route = MaterialPageRoute(builder: (_) => const StudentCourseList());
        Navigator.pushReplacement(context, route);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.grey, Colors.black87],
              begin: FractionalOffset(0.0, 1.0),
              end: FractionalOffset(0.0, 1.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.repeated)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/logo.png"),
          ],
        ),
      ),
    ));
  }
}
