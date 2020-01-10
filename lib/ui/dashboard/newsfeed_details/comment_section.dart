import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './feed_details.dart';
import '../../../model/posts_comment.dart';
import '../../../util/detailSection.dart';
import 'package:intl/intl.dart';

class CommentCategory extends StatefulWidget {

  const CommentCategory({ Key key, this.postKey, this.commentCount}) : super(key: key);
  final postKey;
  final commentCount;

  @override
  _CommentCategoryState createState() => _CommentCategoryState();
}

class _CommentCategoryState extends State<CommentCategory> {

  final FirebaseDatabase _database = FirebaseDatabase.instance;
  DatabaseReference _databaseReferenceForComments;
  List<PostsCommentItem> commentItems;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    commentItems = new List();
    _databaseReferenceForComments = _database.reference().child("Posts-Comments").child(widget.postKey);
    _databaseReferenceForComments.onChildAdded.listen(_onCommentsEntryAdded);
    _databaseReferenceForComments.onChildChanged.listen(_onCommentsEntryUpdated);
    _databaseReferenceForComments.onChildRemoved.listen(_onCommentsEntryRemoved);
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
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              (commentItems.length > 0)?
              new Stack(
                children: <Widget>[
                  _buildComments(),
                  new Column(
                    children: getComments().toList(),
                  )
                ],
              ):
              new Container()
            ],
          ),
        ),
      ),
    );
  }

  List<CommentItem> getComments()
  {
    List<CommentItem> comments = new List();
    List fromDatabase = commentItems ;
    for(var comment in fromDatabase)
    {
      comments.add(
          new CommentItem(
              lines: <String>[
                '${comment.authorName}',
                '${comment.text}',
                '${comment.createdDate}',
              ],
              commentId: comment.id,
              postKey: widget.postKey,
              authorId: comment.authorId,
              authorImage: comment.authorImage,
              commentCount: widget.commentCount
          )
      );
    }
    return comments;
  }

  void _onCommentsEntryAdded(Event event) {
    setState(() {
      commentItems.add(PostsCommentItem.fromSnapshot(event.snapshot));
    });
  }

  void _onCommentsEntryUpdated(Event event) {
    var oldEntry = commentItems.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    setState(() {
      commentItems[commentItems.indexOf(oldEntry)] = PostsCommentItem.fromSnapshot(event.snapshot);
    });
  }

  void _onCommentsEntryRemoved(Event event) {
    var oldEntry = commentItems.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });
    setState(() {
      commentItems.removeAt(commentItems.indexOf(oldEntry));
    });
  }

  Widget _buildComments() {
    return new Positioned(
      top: 0.0,
      bottom: 0.0,
      left: 39.0,
      child: new Container(
        width: 1.0,
        color: Colors.grey[300],
      ),
    );
  }

}

class CommentItem extends StatefulWidget{

  CommentItem({ Key key, this.lines, this.commentId, this.postKey, this.authorId, this.authorImage, this.commentCount})
      : assert(lines.length > 1),
        super(key: key);

  final List<String> lines;
  final String commentId;
  final String postKey;
  final String authorId;
  final String authorImage;
  final commentCount;

  @override
  _CommentItemState createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {

  final FirebaseDatabase _database = FirebaseDatabase.instance;
  FirebaseUser currentUser;
  DatabaseReference _databaseReferenceForComments;
  DatabaseReference _databaseReferenceForPost;
  TextEditingController editComment = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
    _databaseReferenceForComments = _database.reference().child("Posts-Comments").child(widget.postKey);
    _databaseReferenceForPost = _database.reference().child("Posts").child(widget.postKey);
    editComment.text = widget.lines[1];
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final List<Text> columnChildren = [new Text(widget.lines.first, style: themeData.textTheme.title)];
    String lastLine = widget.lines.last;
    List<String> updatedLine ;
    updatedLine = widget.lines.sublist(1, widget.lines.length-1);
    for(String line in updatedLine)
      columnChildren.add(new Text(line));
    columnChildren.add(new Text(lastLine, style: themeData.textTheme.caption));

    return new MergeSemantics(
        child: new Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 10.0),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              CircleAvatar(
                  backgroundImage: NetworkImage("${widget.authorImage}")
              ),
              Padding(padding: EdgeInsets.only(right: 7.0)),
              new Expanded(
                  child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: columnChildren
                  )
              ),
              (currentUser!=null && currentUser.uid == widget.authorId)?
              IconButton(
                  icon: Icon(Icons.edit,
                      color: Color(0xFF505194)),
                  onPressed: _editOption
              ):Container(),
              (currentUser!=null && currentUser.uid == widget.authorId)?
              IconButton(
                  icon: Icon(Icons.delete,
                      color: Color(0xFF505194)),
                  onPressed: _deleteOption
              ):Container()
            ],
          ),
        )
    );
  }

  void _editOption() {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('Edit'),
          content: new SingleChildScrollView(
              child: new TextFormField(
                controller: editComment,
              )
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('Update'),
              onPressed: () {
                Navigator.of(context).pop();
                _databaseReferenceForComments.child(widget.commentId).update({
                  'text':editComment.text,
                  'createdDate':new DateFormat.yMMMd().add_jm().format(new DateTime.now())
                });
              },
            ),
            new FlatButton(
              child: new Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteOption() {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('Delete'),
          content: new SingleChildScrollView(
              child: new Text('Are you sure you want to delete ?')
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop();
                _databaseReferenceForComments.child(widget.commentId).remove();
                _databaseReferenceForPost.update({
                  'commentsCount':widget.commentCount-1
                });
              },
            ),
            new FlatButton(
              child: new Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future getUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    print(user);
    setState(() {
      currentUser = user;
    });
  }
}

class AddNewComment extends StatefulWidget {

  const AddNewComment({ Key key, this.postKey, this.user, this.commentCount, this.parent}) : super(key: key);
  final String postKey;
  final FirebaseUser user;
  final commentCount;
  final FeedDetailsState parent;

  @override
  _AddNewCommentState createState() => _AddNewCommentState();
}

class _AddNewCommentState extends State<AddNewComment> {

  final FirebaseDatabase _database = FirebaseDatabase.instance;
  DatabaseReference _databaseReferenceForNewComment;
  DatabaseReference _databaseReferenceForPost;
  TextEditingController commentController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _databaseReferenceForNewComment = _database.reference().child("Posts-Comments").child(widget.postKey);
    _databaseReferenceForPost = _database.reference().child("Posts").child(widget.postKey);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 60.0,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 20.0),
                ),
                Expanded(
                  flex: 4 ,
                  child: TextField(
                    controller: commentController,
                    decoration: InputDecoration(
                        hintText: "Enter your comment"
                    ),
                  ),
                ),
                Expanded(
                  child: IconButton(
                      icon: Icon(Icons.play_arrow, color: Colors.black),
                      onPressed: ()
                      {
                        if(widget.user == null)
                        {
                          Navigator.of(context).pushNamed('/ui/account/login').then((onReturn){
                            widget.parent.getUser();
                          });
                        }
                        else
                        {
                          PostsCommentItem comment = new PostsCommentItem('','', '', '', '','');
                          comment.authorId = widget.user.uid;
                          comment.authorImage = widget.user.photoUrl;
                          comment.authorName = widget.user.displayName;
                          comment.createdDate = new DateFormat.yMMMd().add_jm().format(new DateTime.now());
                          comment.text = commentController.text;
                          setState(() {
                            commentController.clear();
                          });
                          addComment(comment);
                          FocusScope.of(context).requestFocus(new FocusNode());
                        }
                      }
                  ),
                )
              ],
            )
          ],
        )
    );
  }

  Future addComment(comment) async {
    await _databaseReferenceForPost.update({
      'commentsCount':widget.commentCount+1
    });

    var newRef = _databaseReferenceForNewComment.push();
    comment.id = newRef.key;
    newRef.set(comment.toJson());
  }

}




