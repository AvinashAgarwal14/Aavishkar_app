import 'package:firebase_database/firebase_database.dart';

// A class where each Comment on Post is treated like an object
// For simple usage and retrieval of data from FireBase

class PostsCommentItem {

  PostsCommentItem(
      this.authorId,
      this.authorName,
      this.authorImage,
      this.createdDate,
      this.id,
      this.text
      );

  String key;
  String authorId;
  String authorName;
  String authorImage;
  String createdDate;
  String id;
  String text;

  PostsCommentItem.fromSnapshot(DataSnapshot snapshot) :
        key = snapshot.key,
        authorId = snapshot.value['authorId'],
        authorName = snapshot.value['authorName'],
        authorImage = snapshot.value['authorImage'],
        createdDate = snapshot.value['createdDate'],
        id = snapshot.value['id'],
        text = snapshot.value['text'];

  toJson() {
    return {
      'authorId': authorId,
      'authorName': authorName,
      'authorImage': authorImage,
      'createdDate' : createdDate,
      'id':id,
      'text': text
    };
  }
}