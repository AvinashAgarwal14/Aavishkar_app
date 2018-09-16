import 'package:aavishkarapp/model/newsfeed.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../../model/post_likes.dart';

class StatusCategory extends StatefulWidget {
  StatusCategory({ Key key, this.postKey, this.commentsCount, this.views }) : super(key: key);
  final postKey;
  final int views;
  final int commentsCount;

  @override
  _StatusCategoryState createState() => _StatusCategoryState();
}

class _StatusCategoryState extends State<StatusCategory> {

  List<Icon> likeOptions = [
    Icon(Icons.thumb_up),
    Icon(Icons.thumb_up, color: Colors.indigo)
  ];
  Icon likeButton;
  FirebaseDatabase _database = FirebaseDatabase.instance;
  DatabaseReference _databaseReferenceForPostsLikes;
  PostsLikeItem likeItem;

  DatabaseReference _databaseReferenceForPosts;
  NewsfeedItem postItem;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    likeButton = likeOptions[0];
    _databaseReferenceForPostsLikes = _database.reference().child("Posts-Likes");
    _databaseReferenceForPostsLikes.onChildAdded.listen(_onLikesEntryAddedOrUpdated);
    _databaseReferenceForPostsLikes.onChildChanged.listen(_onLikesEntryAddedOrUpdated);


    _databaseReferenceForPosts = _database.reference().child("Posts");
    _databaseReferenceForPosts.onChildAdded.listen(_onPostsEntryAddedOrUpdated);
    _databaseReferenceForPosts.onChildChanged.listen(_onPostsEntryAddedOrUpdated);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return new Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: new BoxDecoration(
          border: new Border(bottom: new BorderSide(color: themeData.dividerColor))
      ),
      child: new DefaultTextStyle(
        style: Theme.of(context).textTheme.subhead,
        child: new SafeArea(
          top: false,
          bottom: false,
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Expanded(
                  child: new Row(
                      children: <Widget>
                      [
                        Container(
                            padding: EdgeInsets.only(top: 15.0),
                            width: 72.0,
                            child: Column(
                              children: <Widget>[
                                Icon(Icons.remove_red_eye, color: Colors.indigo),
                                Padding(padding: EdgeInsets.only(top: 10.0)),
                                Text("${widget.views}")
                              ],
                            )
                        ),
                        Container(
                            width: 60.0,
                            child: (likeItem!=null)?Column(
                              children: <Widget>[
                                IconButton(icon: likeButton, onPressed: () {
                                  setState(() {
                                    if(likeButton == likeOptions[0])
                                    {
                                      likeButton = likeOptions[1];
                                      likeItem.likes++;
                                      _updateLikes(likeItem.likes);
                                      _updatePostLikes(likeItem.likes);
                                    }
                                    else
                                    {
                                      likeButton = likeOptions[0];
                                      likeItem.likes--;
                                      _updateLikes(likeItem.likes);
                                      _updatePostLikes(likeItem.likes);
                                    }
                                  });
                                }),
                                  Text("${likeItem.likes}")
                              ],
                            ):CircularProgressIndicator()
                        ),
                        Container(
                            padding: EdgeInsets.only(top: 15.0),
                            width: 60.0,
                            child: Column(
                              children: <Widget>[
                                Icon(Icons.mode_comment, color: Colors.indigo),
                                Padding(padding: EdgeInsets.only(top: 10.0)),
                                Text("${widget.commentsCount}")
                              ],
                            )
                        ),
                      ]
                  )
              )
            ],
          ),
        ),
      ),
    );
  }

  void _onLikesEntryAddedOrUpdated(Event event) {
    setState(() {
      if(event.snapshot.value['postId'] == widget.postKey)
        likeItem =(PostsLikeItem.fromSnapshot(event.snapshot));
    });
  }

  void _onPostsEntryAddedOrUpdated(Event event) {
    setState(() {
      if(event.snapshot.key == widget.postKey)
        postItem = (NewsfeedItem.fromSnapshot(event.snapshot));
    });
  }

  void _updateLikes(int value)
  {
    _databaseReferenceForPostsLikes.child("${widget.postKey}").update({
      "likes":value
    });
  }

  void _updatePostLikes(int value)
  {
    _databaseReferenceForPosts.child("${widget.postKey}").update({
      "likesCount":value
    });
  }
}
