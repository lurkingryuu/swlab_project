import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:app/screens/student_course_analysis.dart';
import 'package:app/screens/functions.dart';

class StudentCoursePage extends StatefulWidget {
  const StudentCoursePage({super.key, required this.id, required this.name});
  final String id;
  final String name;
  @override
  State<StudentCoursePage> createState() => _StudentCoursePageState();
}

class _StudentCoursePageState extends State<StudentCoursePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          // child: the name passed from the previous page
          child: Text(widget.name),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
              children: <Widget>[
                const SizedBox(height:25),
                ElevatedButton(
                  onPressed: () {
                    String returnmsg = "Attendance not Started";
                    Color returncolor = Colors.red;
                    if(AttendanceMarker('sid',widget.id)){
                      returnmsg = 'Attendance Marked';
                      returncolor = Colors.green;
                    };
                    Fluttertoast.showToast(
                        msg: returnmsg,
                        backgroundColor: returncolor,
                        textColor: Colors.white,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text(
                    "Mark Attendance",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StudentCourseAnalysis(
                                sid: "21CS30051",
                                cid: widget.id,
                                name: widget.name
                            )
                        )
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text(
                    "Show Attendance",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ]
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
