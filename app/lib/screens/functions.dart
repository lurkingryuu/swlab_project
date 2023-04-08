import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:app/constant/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

// ---------------------- Helper Functions ----------------------
Future<Map<String, String>> getHeaders() async{
  final storage = new FlutterSecureStorage();
  String? token = await storage.read(key: 'auth-token');

  Map<String, String> headers = {
    "Accept": "Application/json",
    "Content-Type": "Application/json",
    "Authorization": "Bearer $token"
  };
  return headers;
}


// ---------------------- API Functions ----------------------
Future login(String email,String password) async{
  final response=await http.post(Uri.parse('${Utils.baseUrl}/auth/login'),
      headers: {"Accept":"Application/json", "Content-Type":"Application/json"},
      body: json.encode({'email':email,'password':password})
  );
  return response;
}

Future getUserType() async{
  var headers = await getHeaders();

  final response=await http.get(Uri.parse('${Utils.baseUrl}/auth/usertype'),
      headers: headers
  );

  return response;
}

Future userRegister(String username, String email, String password, String phone, String user, String id, String dept) async{
  http.Response response;
  if(user == "student"){
    response=await http.post(Uri.parse('${Utils.baseUrl}/auth/signup/student'),
        headers: {"Accept":"Application/json", "Content-Type":"Application/json"},
        body: json.encode({'username':username,'email':email,'password':password,'phone':phone,'id':id,'dept':dept})
    );
  }else if(user == "teacher"){
    response=await http.post(Uri.parse('${Utils.baseUrl}/auth/signup/teacher'),
        headers: {"Accept":"Application/json", "Content-Type":"Application/json"},
        body: json.encode({'username':username,'email':email,'password':password,'phone':phone,'id':id,'dept':dept})
    );
  }
  else{
    response=await http.post(Uri.parse('${Utils.baseUrl}/auth/signup/admin'),
        headers: {"Accept":"Application/json", "Content-Type":"Application/json"},
        body: json.encode({'username':username,'email':email})
    );
  }

  var decodedData=jsonDecode(response.body);
  return decodedData;
}

Future<List>? getCourseList() async{
  List courseList = [];
  var headers = await getHeaders();
  SharedPreferences? sharedPreferences=await SharedPreferences.getInstance();
  var user = sharedPreferences.getString('usertype');
  http.Response response;
  if(user=='teacher'){
    response=await http.get(Uri.parse('${Utils.baseUrl}/teacher/courses'),
        headers: headers
    );
  }else if(user=='student'){
    response=await http.get(Uri.parse('${Utils.baseUrl}/student/courses'),
        headers: headers
    );
  }
  else{
    response=await http.get(Uri.parse('${Utils.baseUrl}/admin/courses'),
        headers: headers
    );
  }
  if (response.statusCode == 200){
    courseList = json.decode(response.body)['data'];
  }else{
    Fluttertoast.showToast(msg: json.decode(response.body)['message']);
  }

  return courseList;
}

// ---------------------- Teacher Functions ----------------------
Future<Map> StartAttendance(String cid) async{
  // http function to start a class
  var headers = await getHeaders();

  var response=await http.post(Uri.parse('${Utils.baseUrl}/teacher/startattendance'),
      headers: headers,
      body: json.encode({'courseid':cid, 'time': '15'})
  );

  var decodedData=jsonDecode(response.body);
  decodedData['status'] = response.statusCode;
  return decodedData;
}

Future<Map> EndAttendance(String cid) async{
  // http function to stop a class
  var headers = await getHeaders();

  var response=await http.post(Uri.parse('${Utils.baseUrl}/teacher/endattendance'),
      headers: headers,
      body: json.encode({'courseid':cid})
  );

  var decodedData=jsonDecode(response.body);
  decodedData['status'] = response.statusCode;
  return decodedData;
}

Future<Map> GetAttendance(String cid) async{
  // http function to get attendance of a class
  var headers = await getHeaders();

  var response=await http.get(Uri.parse('${Utils.baseUrl}/teacher/courses/$cid/attendance'),
      headers: headers
  );

  var decodedData=jsonDecode(response.body);
  decodedData['status'] = response.statusCode;
  return decodedData;
}

Future<Map> GetDetails(String cid) async{
  // http function to get attendance of a class
  var headers = await getHeaders();

  var response=await http.get(Uri.parse('${Utils.baseUrl}/teacher/courses/$cid'),
      headers: headers
  );

  var decodedData=jsonDecode(response.body);
  decodedData['status'] = response.statusCode;
  return decodedData;
}

Future<Map> GetStudentDetailsOnAttendance(String cid, String aid) async{
  // http function to get attendance of a class
  var headers = await getHeaders();

  var response=await http.get(Uri.parse('${Utils.baseUrl}/teacher/courses/$cid/attendance/$aid'),
      headers: headers
  );

  var decodedData=jsonDecode(response.body);
  decodedData['status'] = response.statusCode;
  return decodedData;
  // status = status code,
  // present = list of maps having Name, Id keys
  // absent = list of maps having Name, Id keys
}


// ---------------------- Student Functions ----------------------
Future<String> EnrolCourse(String courseid) async{
  // http function to add course to a student
  var headers = await getHeaders();

  var response=await http.post(Uri.parse('${Utils.baseUrl}/student/enroll'),
      headers: headers,
      body: json.encode({'courseid':courseid})
  );

  var decodedData=jsonDecode(response.body);
  return decodedData['message'];
}

bool AttendanceMarker(String sid,String cid){
  // http function to mark attendance
  if(true){
    return true;
  }
  return false;
}

// ---------------------- Admin Functions ----------------------
Future CreateNewCourse(String courseid,String coursename,List<String> teacherids) async{
  // http function to create a new course
  var headers = await getHeaders();

  var response=await http.post(Uri.parse('${Utils.baseUrl}/admin/addcourse'),
      headers: headers,
      body: json.encode({'courseid':courseid,'coursename':coursename,'teachers':teacherids})
  );

  return response;
}

Future<String> DeleteCourse(String cid) async{
  // http function to delete a course
  var headers = await getHeaders();

  var response=await http.delete(Uri.parse('${Utils.baseUrl}/admin/deletecourse/$cid'),
      headers: headers
  );

  return json.decode(response.body)['message'];
}