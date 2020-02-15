import 'package:flutter/material.dart';
import 'package:task_manager_app/pages/addtask.dart';
import 'package:task_manager_app/pages/dailypage.dart';
import 'package:task_manager_app/pages/rootpage.dart';
import 'package:task_manager_app/services/authentication.dart';
import 'pages/loginpage.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
        title: 'Flutter Login Demo',
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new RootPage(auth: new Auth())
    );
  }
}