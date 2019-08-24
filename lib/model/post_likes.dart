import 'package:firebase_database/firebase_database.dart';

// A class where each Like on Post is treated like an object
// For simple usage and retrieval of data from FireBase

class PostsLikeItem {

  PostsLikeItem(
      this.authorId,
      this.date
      );

  String key;
  String authorId;
  String date;


  PostsLikeItem.fromSnapshot(DataSnapshot snapshot) :
        key = snapshot.key,
        authorId = snapshot.value['authorId'],
        date = snapshot.value['date'];

  toJson() {
    return {
      'authorId': authorId,
      'date': date
    };
  }
}