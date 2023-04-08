import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class StudentCourseAnalysis extends StatefulWidget {
  const StudentCourseAnalysis({super.key, required this.sid,required this.cid, required this.name});
  final String sid;
  final String cid;
  final String name;
  @override
  State<StudentCourseAnalysis> createState() => _StudentCourseAnalysisState();
}

class _StudentCourseAnalysisState extends State<StudentCourseAnalysis> {
  final TextEditingController _controller = TextEditingController();
  List<Map> AttendanceList = [
    {'Date': '01042023', 'Id': 'P'},
    {'Date': '02042023', 'Id': 'P'},
    {'Date': '03042023', 'Id': 'Absent'}
  ];
  int presentCount=0,totalCount=0;
  void attendanceCounter(){
    for(var i=0; i< AttendanceList.length;i++){
      totalCount++;
      if(AttendanceList[i]['Id']=='P'){
        presentCount++;
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    attendanceCounter();
    return Scaffold(
      appBar: AppBar(
        title: Center(
          // child: the name passed from the previous page
          child: Text("${widget.name} Analysis"),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
              children: <Widget>[
                const SizedBox(height:25),
                SizedBox(
                  height : 80,
                  child: ListTile(
                    title: const Text("Total Classes"),
                    subtitle: Text('$totalCount'),
                  ),
                ),
                SizedBox(
                  height : 80,
                  child: ListTile(
                    title: const Text("Attended Classes"),
                    subtitle: Text('$presentCount'),
                  ),
                ),
                SizedBox(
                  height : (AttendanceList.length)*80.0,
                  child:ListView.builder(
                    itemCount: AttendanceList.length,
                    itemBuilder: (context, index) {
                      return SizedBox(
                          height : 80,
                          child : ListTile(
                            title: Text(AttendanceList[index]['Date']),
                            subtitle: Text(AttendanceList[index]['Id']),
                            onTap: (){},
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
}
