import 'package:firebase_database/firebase_database.dart';

// Create each and every news feed as an object for
// simple usage and retrieval of data from FireBase
class NewsfeedItem {

  NewsfeedItem(
      this.title,
      this.body,
      this.imageUrl,
      this.date,
      this.likesCount,
      this.commentsCount
      );

  String key;
  String title;
  String body;
  String imageUrl;
  String date;
  int likesCount;
  int commentsCount;


  NewsfeedItem.fromSnapshot(DataSnapshot snapshot) {
    key = snapshot.key;
    title = snapshot.value['title'];
    body = snapshot.value['body'];
    imageUrl = snapshot.value['imageUrl'];
    date = snapshot.value['date'];
    commentsCount = snapshot.value['commentsCount'];
    likesCount = snapshot.value['likesCount'];
  }
}