import 'package:flutter/material.dart';
import 'package:task_manager_app/pages/homepage.dart';

class DailyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {

    return DailyTask();
  }
}

class DailyTask extends State<DailyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Page'),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Daily Plans',
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

