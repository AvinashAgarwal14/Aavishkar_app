import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import './comment_section.dart';
import './status_section.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class FeedDetails extends StatefulWidget {
  final post;
  FeedDetails({Key key, this.post}) : super(key: key);
  @override
  FeedDetailsState createState() => new FeedDetailsState();
}

enum AppBarBehavior { normal, pinned, floating, snapping }

class FeedDetailsState extends State<FeedDetails> {
  FirebaseUser currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Container(
            height: double.infinity,
            child: Image.network(
              widget.post.imageUrl,
              fit: BoxFit.cover,
            )),
        SafeArea(
            child: Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(children: [
              MaterialButton(
                padding: const EdgeInsets.all(8.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Icon(Icons.arrow_back_ios),
                color: Colors.white,
                textColor: Colors.black,
                minWidth: 0,
                height: 40,
                onPressed: () => Navigator.pop(context),
              ),
            ]),
          ),
          Spacer(flex: 1),
          Expanded(
              child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0), color: Colors.white),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 20.0),
                Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(height: 20.0),
                          new StatusCategory(
                            commentsCount: widget.post.commentsCount,
                            postKey: widget.post.key,
                            date: widget.post.date
                          ),

                        SizedBox(height: 20.0),
                        ListTile(
                            title: Text(
                          widget.post.title,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 26.0),
                        )),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Text(
                            widget.post.body,
                            style: TextStyle(
                                color: Colors.grey.shade600, fontSize: 15.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
          SlidingUpPanel(
            minHeight: 65.0,
            maxHeight: (widget.post.commentsCount <= 3)
                ? MediaQuery.of(context).size.height * 0.45
                : MediaQuery.of(context).size.height * 0.65,
            panel: new Scaffold(
                body: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 5.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 35,
                            height: 8,
                            decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.0))),
                          )
                        ],
                      ),
                      SizedBox(height: 13.0),
                      Center(child: Text("Comments")),
                      Container(
                        height: (widget.post.commentsCount <= 3)
                            ? MediaQuery.of(context).size.height * 0.32
                            : MediaQuery.of(context).size.height * 0.52,
                        child: new CommentCategory(
                            postKey: widget.post.key,
                            commentCount: widget.post.commentsCount),
                      )
                    ]),
                bottomNavigationBar: new AddNewComment(
                      postKey: widget.post.key,
                      user: currentUser,
                      parent: this,
                      commentCount: widget.post.commentsCount),
                )
          ),
        ]))
      ],
    ));
  }

  Future getUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    print(user);
    setState(() {
      currentUser = user;
    });
  }
}
