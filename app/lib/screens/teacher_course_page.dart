import 'package:app/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:app/screens/functions.dart';
import 'package:app/screens/student_course_analysis.dart';

class TeacherCoursePage extends StatefulWidget {
  const TeacherCoursePage({super.key, required this.id, required this.name});
  final String id;
  final String name;
  @override
  State<TeacherCoursePage> createState() => _TeacherCoursePageState();
}

class _TeacherCoursePageState extends State<TeacherCoursePage> {
  final TextEditingController _controller = TextEditingController();
  List? StudentList;
  List? AttendanceList; // id, date, present, absent
  int totalStudents = 0;
  int totalClasses = 0;
  @override
  Widget build(BuildContext context) {
    _getCourseDetails().then((value) {
      setState(() {
        StudentList = value['students'];
        totalStudents = value['total_students'];
        totalClasses = value['total_classes'];
      });
    });
    _getAttendance().then((value) {
      setState(() {
        AttendanceList = value;
      });
    }).catchError((error) {
      print(error);
    });
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
                  onPressed: () async {
                    Map res = await StartAttendance(widget.id);
                    Fluttertoast.showToast(
                        msg: res['message'],
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: (res['status'] == 200)? Colors.green : Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text(
                    "Start Attendance",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height:25),
                ElevatedButton(
                  onPressed: () async {
                    Map res = await EndAttendance(widget.id);
                    Fluttertoast.showToast(
                        msg: res['message'],
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: (res['status'] == 200)? Colors.green : Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text(
                    "End Attendance",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  height : 80,
                  child: ListTile(
                    title: Text("Total Registered Students"),
                    subtitle: Text("$totalStudents"),
                  ),
                ),
                SizedBox(
                  height : 80,
                  child: ListTile(
                    title: Text("Total Classes"),
                    subtitle: Text("$totalClasses"),
                  ),
                ),
                SizedBox(
                  height : totalStudents * 80.0,
                  child:ListView.builder(
                    itemCount: totalStudents,
                    itemBuilder: (context, index) {
                      return SizedBox(
                          height : 80,
                          child : ListTile(
                            title: Text(StudentList?[index]['Name']),
                            subtitle: Text(StudentList?[index]['Id']),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => StudentCourseAnalysis(
                                          sid: StudentList?[index]['Id'],
                                          cid: widget.id,
                                          name: StudentList?[index]['Name'],
                                      )
                                  )
                              );
                            },
                          )
                      );
                    },
                  ),
                ),
                SizedBox(
                  height : totalClasses * 80.0,
                  child:ListView.builder(
                    itemCount: totalClasses,
                    itemBuilder: (context, index) {
                      return SizedBox(
                          height : 80,
                          child : ListTile(
                            title: Text(AttendanceList?[index]['date']),
                            subtitle: Text("Present: ${AttendanceList?[index]['present']}, Absent: ${AttendanceList?[index]['absent']}"),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomePage(title: AttendanceList?[index]['id'],),
                                  )
                              );
                            },
                          )
                      );
                    },
                  ),
                ),
              ]
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _getCourseDetails() async {
    Map res = await GetDetails(widget.id);
    return res;
  }

  _getAttendance() async {
    Map res = await GetAttendance(widget.id);
    if (res['status'] == 200) {
      return res['attendance'];
    }
    else {
      return Future.error(res['message']);
    }
  }


}
