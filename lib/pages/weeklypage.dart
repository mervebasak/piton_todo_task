import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../models/todo.dart';

class WeeklyPage extends StatefulWidget {

  final String userId;

  const WeeklyPage({Key key, this.userId}) : super(key: key);


  @override
  State<StatefulWidget> createState() => new WeeklyTask();
}


class WeeklyTask extends State<WeeklyPage> {
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

    List _weeklyToDo = new List();

    print(_todoList.length);

    String nowTimeSplit = DateTime.now().toString().substring(8,10);
    print(nowTimeSplit);
    var nowTimeInt = int.parse(nowTimeSplit);

    for (var i = 0; i < _todoList.length; i++) {
      String firstSplit = _todoList[i].date.substring(8,10);
      var day = int.parse(firstSplit);

      if((day - nowTimeInt) < 7 && (day - nowTimeInt) > 0 ){
        _weeklyToDo.add(_todoList[i]);

        print("day" + '$day');
        print("nowTimeInt" + '$nowTimeInt');
        print("difference");
        print(day - nowTimeInt);

      }

    }

    if (_weeklyToDo.length > 0) {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: _weeklyToDo.length,
          itemBuilder: (BuildContext context, int index) {

            String todoId = _weeklyToDo[index].key;
            String title = _weeklyToDo[index].title;
            String desc = _weeklyToDo[index].description;
            String date = _weeklyToDo[index].date;
            bool completed = _weeklyToDo[index].completed;
            String userId = _weeklyToDo[index].userId;
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
                        leading: listTileCheck(_weeklyToDo[index].priorty),
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
                                updateTodo(_weeklyToDo[index]);
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
        title: new Text('Weekly Plans Page'),
      ),
      body: showTodoList(),

    );
  }
}