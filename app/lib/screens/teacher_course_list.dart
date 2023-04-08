import 'package:app/screens/functions.dart';
import 'package:app/screens/teacher_course_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TeacherCourseList extends StatefulWidget {
  const TeacherCourseList({Key? key}) : super(key: key);

  @override
  State<TeacherCourseList> createState() => _TeacherCourseListState();
}

class _TeacherCourseListState extends State<TeacherCourseList> {
  final TextEditingController _controller = TextEditingController();
  List? courseList;
  int courseListLength = 0;

  @override
  Widget build(BuildContext context) {
    _getCourseList().then((value) {
      courseList = value;
      courseListLength = courseList!.length;
    });
    print(courseList);
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Your Courses'),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(children: <Widget>[
            const SizedBox(height: 25),
            SizedBox(
              height: courseListLength * 80.0,
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
                                  builder: (context) => TeacherCoursePage(
                                      id: courseList?[index]['Id'],
                                      name: courseList?[index]['Name'])));
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
