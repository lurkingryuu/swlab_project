import 'package:app/screens/admin_course_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:app/screens/functions.dart';
import 'package:app/screens/admin_create_course.dart';

class AdminCourseList extends StatefulWidget {
  const AdminCourseList({Key? key}) : super(key: key);

  @override
  State<AdminCourseList> createState() => _AdminCourseListState();
}

class _AdminCourseListState extends State<AdminCourseList> {
  final TextEditingController _controller = TextEditingController();
  List? courseList;
  int courseListLength = 0;

  @override
  Widget build(BuildContext context) {
    _getCourseList().then((value) {
      courseList = value;
      courseListLength = courseList!.length;
    });
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Admin Home'),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(children: <Widget>[
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AdminCreateCourse(),
                    ));
                setState(() {});
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text(
                "Create Course",
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(
              height: (courseListLength) * 80.0,
              child: ListView.builder(
                itemCount: courseListLength,
                itemBuilder: (context, index) {
                  return SizedBox(
                      height: 80,
                      child: ListTile(
                        title: Text(courseList?[index]['Name']),
                        subtitle: Text(courseList?[index]['Id']),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AdminCoursePage(
                                      cid: courseList?[index]['Id'],
                                      cname: courseList?[index]['Name'])));
                          setState(() {});
                        },
                      ));
                },
              ),
            ),
          ]),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _getCourseList() async {
    courseList = await getCourseList();
    return courseList;
  }
}
