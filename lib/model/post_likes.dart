import 'package:firebase_database/firebase_database.dart';

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