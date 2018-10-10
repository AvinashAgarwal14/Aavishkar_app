import 'dart:async';
import 'package:aavishkarapp/model/newsfeed.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../model/post_likes.dart';

class StatusCategory extends StatefulWidget {
  StatusCategory({ Key key, this.postKey, this.commentsCount, this.date }) : super(key: key);
  final postKey;
  final String date;
  final int commentsCount;

  @override
  _StatusCategoryState createState() => _StatusCategoryState();
}

class _StatusCategoryState extends State<StatusCategory> {

  List<Icon> likeOptions = [
    Icon(Icons.thumb_up),
    Icon(Icons.thumb_up, color: Color(0xFF353662))
  ];
  Icon likeButton;
  FirebaseDatabase _database = FirebaseDatabase.instance;
  DatabaseReference _databaseReferenceForPostsLikes;
  int numberOfLikes;
  FirebaseUser currentUser;
  String likeId;
  bool currentLike;

  DatabaseReference _databaseReferenceForPosts;
  NewsfeedItem postItem;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
    numberOfLikes = 0;
    currentLike = false;
    _databaseReferenceForPostsLikes = _database.reference().child("Posts-Likes").child("${widget.postKey}");
    _databaseReferenceForPostsLikes.onChildAdded.listen(_onLikesEntryAdded);

    _databaseReferenceForPosts = _database.reference().child("Posts").child("${widget.postKey}");
  }

  @override
  Widget build(BuildContext context) {
    if(currentUser!=null && currentLike==true)
      likeButton = likeOptions[1];
    else
      likeButton = likeOptions[0];
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
                            width: 60.0,
                            child: Column(
                              children: <Widget>[
                                IconButton(icon: likeButton, onPressed: () {
                                  if(currentUser==null)
                                    {
                                      Navigator.of(context).pushNamed("/ui/account/login").then((onReturn){
                                        getUser();
                                      });
                                    } else
                                      {
                                          if(likeButton == likeOptions[0])
                                          {
                                            setState(() {
                                              currentLike = true;
                                            });
                                            _addUserToPostLikes();
                                            _updatePost(numberOfLikes+1);
                                          }
                                          else
                                          {
                                            setState(() {
                                              currentLike =  false;
                                              numberOfLikes--;
                                            });
                                            _deleteUserFromPostLikes();
                                            _updatePost(numberOfLikes);
                                          }
                                      }
                                }),
                                  Text("$numberOfLikes")
                              ],
                            )
                        ),
                        Container(
                            padding: EdgeInsets.only(top: 15.0),
                            width: 60.0,
                            child: Column(
                              children: <Widget>[
                                Icon(Icons.mode_comment, color: Color(0xFF353662)),
                                Padding(padding: EdgeInsets.only(top: 10.0)),
                                Text("${widget.commentsCount}")
                              ],
                            )
                        ),
                        Container(
                            padding: EdgeInsets.only(top: 10.0),
                            width: 72.0,
                            child: Column(
                              children: <Widget>[
                                Icon(Icons.date_range, color: Color(0xFF353662)),
                                Padding(padding: EdgeInsets.only(top: 10.0)),
                                Text("${widget.date}", style: TextStyle(fontSize: 13.0),)
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

  Future getUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    setState(() {
      currentUser = user;
    });
  }

  void _onLikesEntryAdded(Event event) {
    setState(() {
      numberOfLikes++;
      print(numberOfLikes);
      if(currentUser!=null && event.snapshot.value['authorId'] == currentUser.uid)
        {
          currentLike = true;
          likeId = event.snapshot.key;
        }
    });
  }

  void _addUserToPostLikes()
  {

        PostsLikeItem user = new PostsLikeItem('', '');
        user.authorId = currentUser.uid;
        user.date = '62616110';
        _databaseReferenceForPostsLikes.push().set(user.toJson());

  }

  void _deleteUserFromPostLikes()
  {
    _databaseReferenceForPostsLikes.child(likeId).remove();
  }

  void _updatePost(int value)
  {
    _databaseReferenceForPosts.update({
      "likesCount":value
    });
  }
}
