
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget{
  HomePage({super.key, required this.title});
  String title;

  @override
  State<StatefulWidget> createState() {
    return HomePageState(title: title);
  }

}

class HomePageState extends State<HomePage>{
  HomePageState({required this.title});
  String title;

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: Text(title),
       centerTitle: true,
     ),
     body: Container(
       child: Center(
         child: Text('Welcome to Home',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
       ),
     ),
   );
  }
}