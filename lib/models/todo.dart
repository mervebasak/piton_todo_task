import 'package:firebase_database/firebase_database.dart';

class Todo {
  String key;
  String title;
  bool completed;
  String userId;
  String description;
  String priorty;

  Todo(this.title,this.description,this.priorty,this.userId, this.completed);

  Todo.fromSnapshot(DataSnapshot snapshot) :
        key = snapshot.key,
        userId = snapshot.value["userId"],
        title = snapshot.value["title"],
        description = snapshot.value["description"],
        priorty = snapshot.value["priorty"],
        completed = snapshot.value["completed"];

  toJson() {
    return {
      "userId": userId,
      "title": title,
      "description": description,
      "priorty": priorty,
      "completed": completed,
    };
  }
}