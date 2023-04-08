import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:app/screens/Admin_course_analysis.dart';
import 'package:app/screens/functions.dart';

class AdminCoursePage extends StatefulWidget {
  const AdminCoursePage({super.key, required this.cid, required this.cname});
  final String cid;
  final String cname;
  @override
  State<AdminCoursePage> createState() => _AdminCoursePageState();
}

class _AdminCoursePageState extends State<AdminCoursePage> {
  String tid = "" ;
  String tname = "" ;


  @override
  Widget build(BuildContext context) {
    String cname = widget.cname;
    String cid = widget.cid;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          // child: the name passed from the previous page
          child: Text('$cname - $cid'),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
              children: <Widget>[
                const SizedBox(height:25),
                ElevatedButton(
                  onPressed: () async{
                    String message = await DeleteCourse(widget.cid);
                    Fluttertoast.showToast(
                      msg: message,
                      backgroundColor: (message.contains('success'))? Colors.green : Colors.red.shade800,
                      textColor: Colors.white,
                    );
                    if (message.contains('success')) {
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text(
                    "Remove Course",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(height:25),
                SizedBox(
                  height : 80,
                  child: ListTile(
                    title: Text(tname),
                    subtitle: Text(tid),
                  )
                )
              ]
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
