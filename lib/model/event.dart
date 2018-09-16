import 'package:firebase_database/firebase_database.dart';

class EventItem {

  EventItem(
      this.title,
      this.body,
      this.imageUrl,this.date,
      this.category,
      this.tag,
      this.link
      );

  String key;
  String title;
  String body;
  String imageUrl;
  String date;
  String category;
  String tag;
  String link;

  EventItem.fromSnapshot(DataSnapshot snapshot) :
        key = snapshot.key,
        title = snapshot.value['title'],
        body = snapshot.value['body'],
        imageUrl = snapshot.value['imageUrl'],
        date = snapshot.value['date'],
        tag = snapshot.value['tag'],
        category = snapshot.value['category'],
        link = snapshot.value['link'];
}