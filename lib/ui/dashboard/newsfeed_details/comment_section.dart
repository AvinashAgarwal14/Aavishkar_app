import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../../model/posts_comment.dart';
import './feed_details.dart';

class CommentCategory extends StatefulWidget {

  const CommentCategory({ Key key, this.postKey}) : super(key: key);
  final postKey;

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
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Container(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  width: 72.0,
                  child: new Icon(Icons.comment, color: themeData.primaryColor)
              ),
              new Expanded(
                  child: new Column(
                    children: (commentItems.length > 0)? <Widget>[
                      new DetailItem(
                          icon: null,
                          lines: <String>[
                            'Comments',
                            '(${commentItems.length})',
                          ]
                      ),
                      new Column(
                        children: getComments().toList(),
                      )
                    ]: <Widget>[
                        new DetailItem(
                          icon: null,
                          lines: <String>[
                            'Comments',
                            '(0)',
                          ]
                        ),
                        new Container()
                ]
              ))
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
              '${comment.authorId}',
              '${comment.text}',
              '${comment.createdDate}',
            ],
            commentId: comment.id,
            postKey: widget.postKey,
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

}

class CommentItem extends StatefulWidget{

  CommentItem({ Key key, this.lines, this.commentId, this.postKey})
      : assert(lines.length > 1),
        super(key: key);

  final List<String> lines;
  final String commentId;
  final String postKey;

  @override
  _CommentItemState createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {

  final FirebaseDatabase _database = FirebaseDatabase.instance;
  DatabaseReference _databaseReferenceForComments;
  TextEditingController editComment = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _databaseReferenceForComments = _database.reference().child("Posts-Comments").child(widget.postKey);
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
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              CircleAvatar(
                  backgroundImage: NetworkImage("https://wallpaperbrowse.com/media/images/3848765-wallpaper-images-download.jpg")
              ),
              Padding(padding: EdgeInsets.only(right: 7.0)),
              new Expanded(
                  child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: columnChildren
                  )
              ),
              IconButton(
                  icon: Icon(Icons.edit,
                      color: Colors.indigo),
                  onPressed: _editOption
              ),
              IconButton(
                  icon: Icon(Icons.delete,
                      color: Colors.indigo),
                  onPressed: _deleteOption
              )
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
                  'text':editComment.text
                });
                _onEdit();
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
                _onDelete();
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

  void _onEdit() {

  }

  void _onDelete() {

  }
}

class AddNewComment extends StatefulWidget {

  const AddNewComment({ Key key, this.postKey, this.authorId}) : super(key: key);
  final String postKey;
  final String authorId;

  @override
  _AddNewCommentState createState() => _AddNewCommentState();
}

class _AddNewCommentState extends State<AddNewComment> {

  final FirebaseDatabase _database = FirebaseDatabase.instance;
  DatabaseReference _databaseReferenceForNewComment;
  TextEditingController commentController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _databaseReferenceForNewComment = _database.reference().child("Posts-Comments").child(widget.postKey);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
          height: 60.0,
          child: Column(
            children: <Widget>[
              Divider(
                color: Colors.indigo,
                height: 2.0,
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 5.0),
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
                        icon: Icon(Icons.play_arrow, color: Colors.indigo),
                        onPressed: ()
                        {
                          PostsCommentItem comment = new PostsCommentItem('', 0, '',  '');
                          comment.authorId = widget.authorId;
                          comment.createdDate = 4645454;
                          comment.text = commentController.text;
                          setState(() {
                            commentController.clear();
                          });
                          addComment(comment);
                        }
                        ),
                  )
                ],
              )
            ],
          )
        );
  }

  void addComment(comment) {
    var newRef = _databaseReferenceForNewComment.push();
    comment.id = newRef.key;
    newRef.set(comment.toJson());
  }

}

