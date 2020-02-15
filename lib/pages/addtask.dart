import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import '../models/user.dart';
import 'package:intl/intl.dart' show DateFormat;


class AddTask extends StatefulWidget {
  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {

  String selectedRadioButton = "";

  final _formKey = GlobalKey<FormState>();
  final _user = User();

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
                                    final form = _formKey.currentState;
                                    if (form.validate()) {
                                      form.save();
                                      _user.save();
                                      _showDialog(context);
                                    }
                                  },
                                  child: Text('Add'))),
                        ])))));
  }

  _showDialog(BuildContext context) {
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text('Submitting form')));
  }

}
class BasicDateTimeField extends StatelessWidget {
  final format = DateFormat("yyyy-MM-dd HH:mm");

  String selectedDate;
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      DateTimeField(
        format: format,
        onShowPicker: (context, currentValue) async {
          final date = await showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2100));
          if (date != null) {
            final time = await showTimePicker(
              context: context,
              initialTime:
              TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
            );
            selectedDate = DateTimeField.combine(date, time).toString();
            return DateTimeField.combine(date, time);

          } else {
            return currentValue;
          }
        },
      ),
    ]);
  }
}