import 'package:firebase_database/firebase_database.dart';

// A class where each Schedule is treated like an object
// For simple usage and retrieval of data from FireBase

class ScheduleItem {
  String key;
  String name;
  String category;
  String time;
  bool completed;

  ScheduleItem(this.name, this.category, this.time, this.completed);

  ScheduleItem.fromSnapshot(DataSnapshot snapshot) :
        key = snapshot.key,
        name = snapshot.value['name'],
        category = snapshot.value['category'],
        time = snapshot.value['time'],
        completed = snapshot.value['completed'];
}
