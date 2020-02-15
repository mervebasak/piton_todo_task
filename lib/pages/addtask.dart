import 'package:flutter/material.dart';
import '../models/user.dart';

class AddTask extends StatefulWidget {
  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
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
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            decoration:
                            InputDecoration(labelText: 'Title'),
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
                              InputDecoration(labelText: 'Description'),
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
                            child: Text('Subscribe'),
                          ),
                          SwitchListTile(
                              title: const Text('Monthly Newsletter'),
                              value: _user.newsletter,
                              onChanged: (bool val) =>
                                  setState(() => _user.newsletter = val)),
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 50, 0, 20),
                            child: Text('Priority'),
                          ),
                          CheckboxListTile(
                              title: const Text('High Importance'),
                              value: _user.priority[User.PriorityHigh],
                              onChanged: (val) {
                                setState(() =>
                                _user.priority[User.PriorityMedium] = val);
                              }),
                          CheckboxListTile(
                              title: const Text('Importance'),
                              value: _user.priority[User.PriorityLow],
                              onChanged: (val) {
                                setState(() => _user
                                    .priority[User.PriorityLow] = val);
                              }),
                          CheckboxListTile(
                              title: const Text('Low Importance'),
                              value: _user.priority[User.PriorityMedium],
                              onChanged: (val) {
                                setState(() =>
                                _user.priority[User.PriorityMedium] = val);
                              }),
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




