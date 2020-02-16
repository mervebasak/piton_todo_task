import 'package:flutter/material.dart';
import 'package:task_manager_app/pages/weeklypage.dart';
import 'package:task_manager_app/services/authentication.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:task_manager_app/models/todo.dart';
import 'dart:async';
import 'addtask.dart';
import 'completedpage.dart';
import 'dailypage.dart';
import 'monthlypage.dart';



class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
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
    print(_todoList.length);
    if (_todoList.length > 0) {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: _todoList.length,
          itemBuilder: (BuildContext context, int index) {
            String todoId = _todoList[index].key;
            String title = _todoList[index].title;
            String desc = _todoList[index].description;
            String date = _todoList[index].date;
            bool completed = _todoList[index].completed;
            String userId = _todoList[index].userId;
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
                        leading: listTileCheck(_todoList[index].priorty),
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
                                updateTodo(_todoList[index]);
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
          title: new Text('Home Page '),
          actions: <Widget>[
            new FlatButton(
                child: new Text('Logout',
                    style: new TextStyle(fontSize: 17.0, color: Colors.white)),
                onPressed: signOut)
          ],
        ),
        body: showTodoList(),
        drawer: Drawer(

          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text("Piton ARGE ve Yazılım Evi"),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: AssetImage("assets/piton.jpg"),
                ),
              ),

              ListTile(
                leading: Icon(Icons.today),
                title: Text("Daily plans"),
                onTap: (){
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DailyPage()),
                  );
                },
              ),
              Divider(),

              ListTile(
                leading: Icon(Icons.insert_invitation),
                title: Text("Weekly plans"),
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WeeklyPage()),
                  );
                },
              ),
              Divider(),

              ListTile(
                leading: Icon(Icons.calendar_today),
                title: Text("Monthly plans"),
                onTap: (){
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MonthlyPage()),
                  );
                },
              ),
              Divider(),

              ListTile(
                leading: Icon(Icons.check_circle),
                title: Text("Completed plans"),
                onTap: (){
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CompletedPage()),
                  );
                },
              ),
              Divider(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddTask()),
            );
          },
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ));
  }
}