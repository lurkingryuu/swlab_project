import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:app/screens/register_page.dart';
import 'package:app/widgets/form_fields_widgets.dart';
import 'package:app/screens/functions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:app/screens/student_course_list.dart';
import 'package:app/screens/teacher_course_list.dart';
import 'package:app/screens/admin_course_list.dart';


class LoginPage extends StatefulWidget
{
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() {
   return _LoginPageState();
  }

}

class _LoginPageState extends State<LoginPage>{
  final GlobalKey<FormState> _formKey= GlobalKey<FormState>();
  final TextEditingController _emailController=TextEditingController();
  final TextEditingController _passwordController=TextEditingController();
// call shared preference object here
  SharedPreferences? _sharedPreferences;


  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.grey,Colors.black87],
                  begin: FractionalOffset(0.0, 1.0),
                  end: FractionalOffset(0.0, 1.0),
                  stops: [0.0,1.0],
                  tileMode: TileMode.repeated
              )
            // same code from main.dart we copy paste here
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(height: 60,),
              Container(
                alignment: Alignment.center,
                child: Image.asset("assets/images/logo.png",fit: BoxFit.cover,width: 150,height: 150,),
              ),
              const SizedBox(height: 10,),
              Form(
                key: _formKey,
                  child: Column(
                    children: [
                      FormFields(
                        controller: _emailController,
                        data: Icons.email,
                        txtHint: 'Email',
                        obsecure: false, // this means if field type is password then sed true for *****
                      ),

                      FormFields(
                        controller: _passwordController,
                        data: Icons.lock,
                        txtHint: 'Password',
                        obsecure: true, // this means if field type is password then sed true for *****
                      )
                    ],
                  )
              ),
              const SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 const Text('Forgot Password',style: TextStyle(color: Colors.white,fontSize: 12),),
                  const SizedBox(width: 15,),
                  ElevatedButton(onPressed: (){
                    _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty
                        ? doLogin(_emailController.text,_passwordController.text)
                        : Fluttertoast.showToast(msg: 'All fields are required',textColor: Colors.red);

                  },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text("Login",style: TextStyle(color: Colors.white),),
                  )
                ],
              ),
              const SizedBox(height: 20,),
              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterPage()));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                     Text('Don`t have an account',style: TextStyle(color: Colors.white),),
                    Text('Register',style: TextStyle(color: Colors.blue,fontWeight: FontWeight.w600,fontSize: 18),)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  doLogin(String email, String password) async {
    _sharedPreferences=await SharedPreferences.getInstance();
    var res=await login(email.trim(), password.trim());
    print(res.statusCode);
    if(res.statusCode==200){
      //here we set data
      var data = jsonDecode(res.body);
      String token=data['token'];
      final storage = new FlutterSecureStorage();
      await storage.write(key: "auth-token", value: token );
      Fluttertoast.showToast(msg: 'Login Success',textColor: Colors.green);
      // print("token: ${token}");

      var resp = await getUserType();
      // print("status code : ${resp.statusCode}");
      if (resp.statusCode == 200) {
        var user = jsonDecode(resp.body)['usertype'];
        // print("user type: ${user}");
        _sharedPreferences!.setString('usertype', user);
        redirectUser(user);
      }else{

        Fluttertoast.showToast(msg: 'Token Expired',textColor: Colors.red);
      }

    }else{
      Fluttertoast.showToast(msg: 'Email and password not valid ?',textColor: Colors.red);
    }

  }

  redirectUser(String user) {
    if(user=='admin'){
      Route route=MaterialPageRoute(builder: (context)=>AdminCourseList());
      Navigator.pushReplacement(context, route);
    }else if(user=='student'){
      Route route=MaterialPageRoute(builder: (context)=>StudentCourseList());
      Navigator.pushReplacement(context, route);
    }else if(user=='teacher'){
      Route route=MaterialPageRoute(builder: (context)=>TeacherCourseList());
      Navigator.pushReplacement(context, route);
    }else{
      Fluttertoast.showToast(msg: 'User not found',textColor: Colors.red);
    }
  }


}