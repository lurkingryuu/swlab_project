import 'package:app/screens/student_course_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:app/screens/functions.dart';

class StudentCourseList extends StatefulWidget {
  const StudentCourseList({Key? key}) : super(key: key);

  @override
  State<StudentCourseList> createState() => _StudentCourseListState();
}

class _StudentCourseListState extends State<StudentCourseList> {
  final TextEditingController _controller = TextEditingController();
  String userInput = "";
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
          child: Text('Your Courses'),
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
              child: TextFormField(
                controller: _controller,
                obscureText: false,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                    hintText: 'Enter Course ID'),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                String returnmsg = await EnrolCourse(_controller.text);
                Color returncolor = (returnmsg.contains("success"))? Colors.green: Colors.red;
                bool enrolstate = false;
                if(_controller.text.isNotEmpty){
                  enrolstate = (returnmsg.contains("success"))? true: false;
                }
                Fluttertoast.showToast(
                    msg: returnmsg,
                    textColor: Colors.white,
                    backgroundColor: returncolor);
                if(enrolstate){
                  setState(() {});
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text(
                "Enrol",
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(
              height: 80.0 * courseListLength,
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
                                  builder: (context) => StudentCoursePage(
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
