import 'package:firebase_database/firebase_database.dart';

class PostsCommentItem {

  PostsCommentItem(
      this.authorId,
      this.createdDate,
      this.id,
      this.text
      );

  String key;
  String authorId;
  int createdDate;
  String id;
  String text;

  PostsCommentItem.fromSnapshot(DataSnapshot snapshot) :
        key = snapshot.key,
        authorId = snapshot.value['authorId'],
        createdDate = snapshot.value['createdDate'],
        id = snapshot.value['id'],
        text = snapshot.value['text'];

  toJson() {
    return {
      'authorId': authorId,
      'createdDate' : createdDate,
      'id':id,
      'text': text
    };
  }
}