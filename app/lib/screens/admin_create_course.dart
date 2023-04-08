import 'dart:convert';

import 'package:app/screens/admin_course_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:app/screens/functions.dart';
import "package:http/http.dart" as http;

class AdminCreateCourse extends StatefulWidget {
  const AdminCreateCourse({Key? key}) : super(key: key);

  @override
  State<AdminCreateCourse> createState() => _AdminCreateCourseState();
}

class _AdminCreateCourseState extends State<AdminCreateCourse> {
  final TextEditingController _cidcontroller = TextEditingController();
  final TextEditingController _cnamecontroller = TextEditingController();
  final TextEditingController _tidcontroller = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Create Course'),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(children: <Widget>[
            const SizedBox(height: 25),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.all(5),
              child: Column(children: <Widget>[
                TextFormField(
                  controller: _cidcontroller,
                  obscureText: false,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                      hintText: 'Enter New Course ID'),
                ),
                SizedBox(height:25),
                TextFormField(
                  controller: _cnamecontroller,
                  obscureText: false,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                      hintText: 'Enter New Course Name'),
                ),
                SizedBox(height:25),
                TextFormField(
                  controller: _tidcontroller,
                  obscureText: false,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                      hintText: 'Enter Teacher ID [\',\' separated if multiple]'),
                ),
                SizedBox(height:25),
              ]),
            ),
            ElevatedButton(
              onPressed: () async {
                List<String> teachers = _tidcontroller.text.split(',');
                for (int i = 0; i < teachers.length; i++) {
                  teachers[i] = teachers[i].trim();
                }
                http.Response res = await CreateNewCourse(_cidcontroller.text,_cnamecontroller.text,teachers);
                String returnmsg = (res.statusCode == 200)? "New Course Created": json.decode(res.body)['message'];
                Color returncolor = (res.statusCode == 200)? Colors.green : Colors.red.shade900;
                if(_cidcontroller.text.isNotEmpty &&  _cnamecontroller.text.isNotEmpty && _tidcontroller.text.isNotEmpty){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdminCoursePage(cid: _cidcontroller.text, cname: _cnamecontroller.text)),
                  );
                };
                Fluttertoast.showToast(
                    msg: returnmsg,
                    textColor: Colors.white,
                    backgroundColor: returncolor);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text(
                "Create Course",
                style: TextStyle(color: Colors.white),
              ),
            ),

          ]),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
