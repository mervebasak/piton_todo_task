import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:task_manager_app/services/dateTimePicker.dart';
import '../models/todo.dart';
import '../models/user.dart';
import 'package:intl/intl.dart' show DateFormat;

import 'homepage.dart';


class AddTask extends StatefulWidget {


  @override
  _AddTaskState createState() => _AddTaskState();

}

class _AddTaskState extends State<AddTask> {


  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();


  String selectedRadioButton = "";


  final _textTitleController = TextEditingController();
  final _textDescriptionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _user = User();





  addNewTodo(String title,String desc,String priorty, String date) {
    if (title.length > 0) {
      Todo todo = new Todo(title.toString(), desc.toString(),priorty.toString(),date.toString(), HomePage().userId, false);
      _database.reference().child("todo").push().set(todo.toJson());
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Add New Task')),
        body: Container(
            padding:
            const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: Builder(
                builder: (context) => Form(
                    key: _formKey,
                    child: ListView(
                        children: [
                          TextFormField(
                            controller: _textTitleController,
                            decoration:
                            InputDecoration(
                                prefixIcon: Icon(Icons.people),
                                labelText: 'Title'),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter title';
                              }
                            },
                            onSaved: (val) =>
                                setState(() => _user.firstName = val),
                          ),
                          TextFormField(
                              controller: _textDescriptionController,
                              decoration:
                              InputDecoration(
                                  prefixIcon: Icon(Icons.description),
                                  labelText: 'Description'),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter description';
                                }
                              },
                              onSaved: (val) =>
                                  setState(() => _user.lastName = val)
                          ),

                          Container(
                              padding: const EdgeInsets.fromLTRB(0, 50, 0, 20),
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.date_range),
                                  Text('   Pick Date', textAlign: TextAlign.center),
                                ],
                              )
                          ),

                          Container(
                            child: BasicDateTimeField(),
                          ),

                          Container(
                              padding: const EdgeInsets.fromLTRB(0, 50, 0, 20),
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.priority_high),
                                  Text('   Priority', textAlign: TextAlign.center),
                                ],
                              )
                          ),
                          RadioButtonGroup(
                            labels: <String>[
                              "High Priorty",
                              "Medium Priorty",
                              "Low Priorty",
                            ],
                            onSelected: (String selected) => setState((){
                              selectedRadioButton = selected;
                            }),
                          ),
                          Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16.0, horizontal: 16.0),
                              child: RaisedButton(
                                  onPressed: () {
                                    addNewTodo(_textTitleController.text.toString(),
                                        _textDescriptionController.text.toString(),
                                        selectedRadioButton.toString(),
                                        selectedDate);
                                    Navigator.pop(context);
                                  },
                                  child: Text('Add'))),
                        ])))));
  }


}