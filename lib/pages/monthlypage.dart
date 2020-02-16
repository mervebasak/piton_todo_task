import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../models/todo.dart';

class MonthlyPage extends StatefulWidget {

  final String userId;

  const MonthlyPage({Key key, this.userId}) : super(key: key);


  @override
  State<StatefulWidget> createState() => new MonthlyTask();
}


class MonthlyTask extends State<MonthlyPage> {
  List<Todo> _todoList;


  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  StreamSubscription<Event> _onTodoAddedSubscription;
  StreamSubscription<Event> _onTodoChangedSubscription;

  Query _todoQuery;


  @override
  void initState() {
    super.initState();

    _todoList = new List();
    _todoQuery = _database
        .reference()
        .child("todo")
        .orderByChild("userId");
    _onTodoAddedSubscription = _todoQuery.onChildAdded.listen(onEntryAdded);
    _onTodoChangedSubscription =
        _todoQuery.onChildChanged.listen(onEntryChanged);
  }


  @override
  void dispose() {
    _onTodoAddedSubscription.cancel();
    _onTodoChangedSubscription.cancel();
    super.dispose();
  }

  onEntryChanged(Event event) {
    var oldEntry = _todoList.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    setState(() {
      _todoList[_todoList.indexOf(oldEntry)] =
          Todo.fromSnapshot(event.snapshot);
    });
  }

  onEntryAdded(Event event) {
    setState(() {
      _todoList.add(Todo.fromSnapshot(event.snapshot));
    });
  }



  updateTodo(Todo todo) {
    //Toggle completed
    todo.completed = !todo.completed;
    if (todo != null) {
      _database.reference().child("todo").child(todo.key).set(todo.toJson());
    }
  }

  deleteTodo(String todoId, int index) {
    _database.reference().child("todo").child(todoId).remove().then((_) {
      print("Delete $todoId successful");
      setState(() {
        _todoList.removeAt(index);
      });
    });
  }

  listTileCheck(String radio){
    switch(radio.substring(0,1)){
      case 'H':
        return CircleAvatar(
          backgroundColor: Colors.red,
          child: Text("H",
            style: TextStyle(color: Colors.white),),
        );
        break;
      case 'M':
        return CircleAvatar(
          backgroundColor: Colors.yellow,
          child: Text("M",
            style: TextStyle(color: Colors.white),),
        );
        break;
      case 'L':
        return CircleAvatar(
          backgroundColor: Colors.green,
          child: Text("L",
            style: TextStyle(color: Colors.white),),
        );
        break;
    }
  }


  Widget showTodoList() {
    List _monthlyToDo = new List();
    print(_todoList.length);
    DateTime now = DateTime.now();
    String nowTimeSplit = DateTime.now().toString().substring(5,7);
    var nowTimeInt = int.parse(nowTimeSplit);

    for (var i = 0; i < _todoList.length; i++) {
      String firstSplit = _todoList[i].date.substring(5,7);
      var day = int.parse(firstSplit);

      print(now);
      print(day);
      print(nowTimeInt);

      if((day - nowTimeInt).abs() < 1 ){
        _monthlyToDo.add(_todoList[i]);

      }

    }

    if (_monthlyToDo.length > 0) {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: _monthlyToDo.length,
          itemBuilder: (BuildContext context, int index) {
            String todoId = _monthlyToDo[index].key;
            String title = _monthlyToDo[index].title;
            String desc = _monthlyToDo[index].description;
            String date = _monthlyToDo[index].date;
            bool completed = _monthlyToDo[index].completed;
            String userId = _monthlyToDo[index].userId;
            String finalTitle = '$title' +"   "+ '$date';
            return Dismissible(
              key: Key(todoId),
              background: Container(color: Colors.red),
              onDismissed: (direction) async {
                deleteTodo(todoId, index);
              },
              child: Card(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: listTileCheck(_monthlyToDo[index].priorty),
                        title: Text(
                          title,
                          style: TextStyle(fontSize: 20.0),
                        ),
                        subtitle: Text(desc),
                      ),
                      ButtonBar(
                        children: <Widget>[
                          FlatButton(
                            child:  Text(date),
                            onPressed: () { /* ... */ },
                          ),
                          IconButton(
                              icon: (completed)
                                  ? Icon(
                                Icons.done_outline,
                                color: Colors.green,
                                size: 20.0,
                              )
                                  : Icon(Icons.done, color: Colors.grey, size: 20.0),
                              onPressed: () {
                                updateTodo(_monthlyToDo[index]);
                              }),
                        ],
                      ),
                    ]),
              ),
            );
          });
    } else {
      return Center(
          child: Text(
            "Welcome. Your list is empty",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30.0),
          ));
    }
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Monthly Plans Page'),
      ),
      body: showTodoList(),

    );
  }
}