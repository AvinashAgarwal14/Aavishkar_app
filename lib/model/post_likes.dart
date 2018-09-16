import 'package:firebase_database/firebase_database.dart';

class PostsLikeItem {

  PostsLikeItem(
      this.likes,
      this.postId
      );

  String key;
  int likes;
  String postId;


  PostsLikeItem.fromSnapshot(DataSnapshot snapshot) :
        key = snapshot.key,
        likes = snapshot.value['likes'],
        postId = snapshot.value['postId'];
}