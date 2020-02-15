import 'package:flutter/material.dart';
import 'package:task_manager_app/pages/homepage.dart';

class CompletedPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {

    return CompletedTask();
  }
}

class CompletedTask extends State<CompletedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Completed Page'),
      ),
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Completed Plans',
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

