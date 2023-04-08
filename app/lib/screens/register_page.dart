import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:app/screens/functions.dart';
import 'package:app/screens/login_page.dart';
import 'package:app/widgets/form_fields_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RegisterPageState();
  }
}

class RegisterPageState extends State<RegisterPage> {
  final TextEditingController username = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController password = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final heightOfScreen = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
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
        height: heightOfScreen,
        child: Stack(
          children: <Widget>[
            Positioned(
              child: Container(),
              top: MediaQuery.of(context).size.height * .15,
              right: MediaQuery.of(context).size.width * .4,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 120,
                    ),
                    titleWidget(),
                    SizedBox(
                      height: 25,
                    ),
                    Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            FormFields(
                              controller: username,
                              data: Icons.person,
                              txtHint: 'Username',
                              obsecure:
                                  false, // this means if field type is password then sed true for *****
                            ),
                            FormFields(
                              controller: email,
                              data: Icons.email,
                              txtHint: 'Email',
                              obsecure:
                              false, // this means if field type is password then sed true for *****
                            ),
                            FormFields(
                              controller: phone,
                              data: Icons.phone,
                              txtHint: 'Phone',
                              obsecure:
                              false, // this means if field type is password then sed true for *****
                            ),
                            FormFields(
                              controller: password,
                              data: Icons.lock,
                              txtHint: 'Password',
                              obsecure:
                                  true, // this means if field type is password then sed true for *****
                            )
                          ],
                        )),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            username.text.isNotEmpty &&
                                    password.text.isNotEmpty &&
                                    email.text.isNotEmpty
                            &&   phone.text.isNotEmpty
                                ? doRegister(
                                    username.text, email.text, password.text,phone.text, "Student", " ", " ")
                                : Fluttertoast.showToast(
                                    msg: 'All fields are required',
                                    textColor: Colors.red);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                          child: Text(
                            "Register",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 35,),
                    _LoginText(),
                  ],
                ),
              ),
            ),
            Positioned(top: 40, left: 0, child: _backButton()),
          ],
        ),
      ),
    );
  }

  titleWidget() {
    return RichText(
        textAlign: TextAlign.center,
        text: const TextSpan(
            text: 'K',
            style: TextStyle(
                fontSize: 30, color: Colors.blue, fontWeight: FontWeight.w700),
            children: [
              TextSpan(
                  text: 'G',
                  style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w700,
                      fontSize: 30)),
              TextSpan(
                  text: 'P',
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w700,
                      fontSize: 30)),
            ]));
  }

  doRegister(String username, String email, String password,String phoneNo, String userType, String rollNo, String dept) async {
    var res=await userRegister(username, email, password,phoneNo, userType, rollNo, dept);
    if(res['success']){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage()));
    }else{
      Fluttertoast.showToast(msg: res['message'],textColor: Colors.red);
    }
  }

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: const Icon(
                Icons.keyboard_arrow_left,
                color: Colors.white,
              ),
            ),
            Text(
              'Back',
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }

  Widget _LoginText() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
      child: Container(
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Already have an Account ? Login',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
