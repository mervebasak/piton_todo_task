import 'package:flutter/material.dart';
import 'package:task_manager_app/pages/homepage.dart';

class WeeklyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {

    return WeeklyTask();
  }
}

class WeeklyTask extends State<WeeklyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weekly Plans'),
      ),
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Weekly Plans',
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.blueGrey,
                        fontStyle: FontStyle.italic
                    ),
                  ),
                ),
              ]

          )

      ),
    );
  }
}

