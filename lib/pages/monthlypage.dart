import 'package:flutter/material.dart';
import 'package:task_manager_app/pages/homepage.dart';

class MonthlyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {

    return MonthlyTask();
  }
}

class MonthlyTask extends State<MonthlyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Monthly Page'),
      ),
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Monthly Plans',
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

