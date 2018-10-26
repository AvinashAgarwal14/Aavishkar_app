//import 'dart:async';
//import 'package:firebase_database/firebase_database.dart';
//import 'package:flutter/material.dart';
//import 'package:google_sign_in/google_sign_in.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
//import './loginAnimation.dart';
//import 'package:flutter/animation.dart';
//import './styles.dart';
//import '../activities/events/event_details.dart';
//import '../../util/detailSection.dart';
//import '../../util/drawer.dart';
//
//var kFontFam = 'CustomFonts';
//
//IconData github_circled = IconData(0xe800, fontFamily: kFontFam);
//IconData linkedin = IconData(0xe801, fontFamily: kFontFam);
//IconData facebook = IconData(0xf052, fontFamily: kFontFam);
//IconData google = IconData(0xf1a0, fontFamily: kFontFam);
//IconData facebook_1 = IconData(0xf300, fontFamily: kFontFam);
//
//class LogInPage extends StatefulWidget {
//  @override
//  State createState() => new LogInPageState();
//}
//
//class LogInPageState extends State<LogInPage> with TickerProviderStateMixin {
//  final FirebaseDatabase database = FirebaseDatabase.instance;
//  DatabaseReference databaseReference;
//  int click = 0, gclick = 0;
//  final FirebaseAuth _auth = FirebaseAuth.instance;
//  final GoogleSignIn _googleSignIn = new GoogleSignIn();
//  final _facebookLogin = new FacebookLogin();
//  FirebaseUser currentUser;
//
//  bool previouslyLoggedIn = false;
//  AnimationController _glogInButtonController;
//  AnimationController _flogInButtonController;
//  var animationStatus = 0;
//
//  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
//  final double _appBarHeight = 256.0;
//  AppBarBehavior _appBarBehavior = AppBarBehavior.pinned;
//
//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
//    getUser();
//    _glogInButtonController = new AnimationController(
//        duration: new Duration(milliseconds: 1700),
//        vsync: this,
//        debugLabel: "google");
//    _flogInButtonController = new AnimationController(
//        duration: new Duration(milliseconds: 1700),
//        vsync: this,
//        debugLabel: "facebook");
//  }
//
//  Future<Null> _playAnimation(int n) async {
//    try {
//      if (n == 1) {
//        print("BLOCK 31");
//        await _glogInButtonController.forward();
//        print("BLOCK 31");
//        setState(() {});
//      } else if (n == 2) {
//        await _flogInButtonController.forward();
//        setState(() {});
//      }
//    } on TickerCanceled {}
//  }
//
//  Future<Null> _reverseAnimation(int n) async {
//    try {
//      if (n == 1) {
//        print("BLOCK 51");
//        await _glogInButtonController.reverse();
//        print("BLOCK 52");
//        setState(() {
//          print("BLOCK 52");
//          animationStatus = 0;
//          currentUser = null;
//        });
//      } else if (n == 2) {
//        await _flogInButtonController.reverse();
//        //await _glogInButtonController.reverse();
//        setState(() {
//          animationStatus = 0;
//          currentUser = null;
//        });
//      }
//    } on TickerCanceled {}
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    if (currentUser == null) {
//      return new Scaffold(
//          drawer: NavigationDrawer(),
//          body: new Container(
//              decoration: new BoxDecoration(
//                image: backgroundImage,
//              ),
//              child: new Container(
//                  height: MediaQuery.of(context).size.height,
//                  width: MediaQuery.of(context).size.width,
//                  decoration: new BoxDecoration(
//                      gradient:
//                      new LinearGradient(
//                        colors: <Color>[
//                          const Color.fromRGBO(162, 146, 199, 0.4),
//                          const Color.fromRGBO(51, 51, 63, 0.4),
//                        ],
//                        stops: [0.2, 1.0],
//                        begin: const FractionalOffset(0.0, 0.0),
//                        end: const FractionalOffset(0.0, 1.0),
//                      )
//                  ),
//                  child: new ListView(
//                    padding: const EdgeInsets.all(0.0),
//                    children: <Widget>[
//                      new Stack(
//                          alignment: (animationStatus == 0)
//                              ? AlignmentDirectional.topCenter
//                              : AlignmentDirectional.center,
//                          children: <Widget>[
//                            animationStatus == 0
//                                ? Padding(
//                              padding: const EdgeInsets.only(
//                                  top: 15.0, left: 5.0),
//                              child: ListTile(
//                                leading: BackButton(
//                                  color: Colors.white,
//                                ),
//                              ),
//                            )
//                                : Container(),
//                            animationStatus != 0
//                                ? SizedBox(
//                                height: MediaQuery.of(context).size.height)
//                                : Container(),
//                            animationStatus == 0
//                                ? (Container(
//                              child: new Column(
//                                mainAxisAlignment:
//                                MainAxisAlignment.center,
//                                children: <Widget>[
//                                  SizedBox(
//                                      height: MediaQuery.of(context)
//                                          .size
//                                          .height /
//                                          3),
//                                  new Padding(
//                                    padding: const EdgeInsets.only(),
//                                    child: new InkWell(
//                                        onTap: () {
//                                          setState(() {
//                                            animationStatus = 1;
//                                          });
//                                        },
//                                        child: SignIn(
//                                            "Sign in with Google")),
//                                  ),
//                                  Padding(
//                                    padding: const EdgeInsets.all(20.0),
//                                    child: Center(
//                                        child: Text(
//                                          "OR",
//                                          style: TextStyle(
//                                              color: Colors.white,
//                                              fontSize: 20.0),
//                                        )),
//                                  ),
//                                  new Padding(
//                                    padding: const EdgeInsets.only(),
//                                    child: new InkWell(
//                                        onTap: () {
//                                          setState(() {
//                                            animationStatus = 2;
//                                          });
//                                        },
//                                        child: SignIn(
//                                            "Sign in with Facebook")),
//                                  ),
//                                ],
//                                crossAxisAlignment:
//                                CrossAxisAlignment.center,
//                              ),
//                            ))
//                                : FutureBuilder(
//                                future: animationStatus == 1
//                                    ? _gSignIn()
//                                    : _fSignIn(),
//                                builder: (BuildContext context,
//                                    AsyncSnapshot snapshot) {
//                                  if (currentUser == null) {
//                                    print("---------Gangnum");
//                                    return animationStatus == 1
//                                        ? Container(
//                                        child:
//                                        CircularProgressIndicator(
//                                          value: null,
//                                          strokeWidth: 2.0,
//                                          valueColor:
//                                          new AlwaysStoppedAnimation<
//                                              Color>(Colors.white),
//                                        ))
//                                        : Container();
//                                  } else {
//                                    _playAnimation(animationStatus);
//                                    return new StaggerAnimation(
//                                        buttonController: animationStatus ==
//                                            2
//                                            ? _flogInButtonController.view
//                                            : _glogInButtonController.view);
//                                  }
//                                })
//                          ])
//                    ],
//                  ))));
//    } else {
//      return new Scaffold(
//          body: previouslyLoggedIn == false
//              ? new Scaffold(
//              key: _scaffoldKey,
//              drawer: NavigationDrawer(currentDisplayedPage: 8),
//              body: new CustomScrollView(slivers: <Widget>[
//                new SliverAppBar(
//                  expandedHeight: _appBarHeight,
//                  pinned: _appBarBehavior == AppBarBehavior.pinned,
//                  floating: _appBarBehavior == AppBarBehavior.floating ||
//                      _appBarBehavior == AppBarBehavior.snapping,
//                  snap: _appBarBehavior == AppBarBehavior.snapping,
//                  flexibleSpace: new FlexibleSpaceBar(
//                    title: Text('Profile'),
//                    background: new Stack(
//                      alignment: AlignmentDirectional.center,
//                      fit: StackFit.loose,
//                      children: <Widget>[
//                        CircleAvatar(radius:  animationStatus==1?60.0:42.0,backgroundColor: Theme.of(context).brightness==Brightness.light?Colors.grey:Colors.black12,),
//                        Container(
//                            width: animationStatus==1?120.0:80.0,
//                            height: animationStatus==1?120.0:80.0,
//                            decoration: new BoxDecoration(
//                                shape: BoxShape.circle,
//                                image: new DecorationImage(
//                                    fit: BoxFit.fill,
//                                    image:  NetworkImage(currentUser.photoUrl)
//                                )
//                            )
//                        ),
//
////                                    CircleAvatar(
////
////                                      child: new Image.network(
////                                        "${currentUser.photoUrl}",
////                                        fit: BoxFit.scaleDown,
////                                        //height: _appBarHeight,
////                                      ),backgroundColor: Colors.white,
////                                      radius: animationStatus==2?45.0:80.0,
////                                    ),
//                        //maxRadius:10
//
//                        // This gradient ensures that the toolbar icons are distinct
//                        // against the background image.
////                            const DecoratedBox(
////                              decoration: BoxDecoration(
////                                gradient: LinearGradient(
////                                  begin: Alignment(0.0, 0.6),
////                                  end: Alignment(0.0, -0.4),
////                                  colors: <Color>[
////                                    Color(0x60000000),
////                                    Color(0x00000000)
////                                  ],
////                                ),
////                              ),
////                            ),
//                      ],
//                    ),
//                  ),
//                ),
//                new SliverList(
//                    delegate: new SliverChildListDelegate(<Widget>[
//                      DetailCategory(
//                        icon: Icons.person,
//                        children: <Widget>[
//                          DetailItem(
//                            lines: <String>[
//                              "Name :",
//                              "${currentUser.displayName}"
//                            ],
//                          )
//                        ],
//                      ),
//                      DetailCategory(
//                        icon: Icons.email,
//                        children: <Widget>[
//                          DetailItem(
//                            lines: <String>["Email :", "${currentUser.email}"],
//                          )
//                        ],
//                      ),
//                      GestureDetector(
//                        onTap: () {
//                          Navigator.of(context).pushNamed("/ui/eurekoin");
//                        },
//                        child: DetailCategory(
//                          icon: Icons.videogame_asset,
//                          children: <Widget>[
//                            DetailItem(
//                              lines: <String>["Eurekoin Wallet"],
//                            )
//                          ],
//                        ),
//                      ),
//                      GestureDetector(
//                        onTap: () {
//                          if (currentUser.providerData[1].providerId ==
//                              "google.com")
//                            _gSignOut();
//                          else
//                            _fSignOut();
//                          print("Logout!");
//                        },
//                        child: DetailCategory(
//                          icon: Icons.remove_circle,
//                          children: <Widget>[
//                            DetailItem(
//                              lines: <String>['Logout'],
//                            )
//                          ],
//                        ),
//                      )
//                    ]))
//              ]))
//              : Scaffold(
//              body: Container(
//                  decoration: new BoxDecoration(
//                    image: backgroundImage,
//                  ),
//                  child: new Container(
//                    height: MediaQuery.of(context).size.height,
//                    width: MediaQuery.of(context).size.width,
//                    decoration: new BoxDecoration(
//                        gradient: new LinearGradient(
//                          colors: <Color>[
//                            const Color.fromRGBO(162, 146, 199, 0.8),
//                            const Color.fromRGBO(51, 51, 63, 0.9),
//                          ],
//                          stops: [0.2, 1.0],
//                          begin: const FractionalOffset(0.0, 0.0),
//                          end: const FractionalOffset(0.0, 1.0),
//                        )),
//                    child: ListView(
//                      children: <Widget>[
//                        Stack(
//                          alignment: AlignmentDirectional.bottomCenter,
//                          children: <Widget>[
//                            SizedBox(
//                              height:
//                              MediaQuery.of(context).size.height / 2,
//                            ),
//                            FutureBuilder(
//                                future: animationStatus == 1
//                                    ? _reverseAnimation(1)
//                                    : _reverseAnimation(2),
//                                builder: (BuildContext context,
//                                    AsyncSnapshot snapshot) {
//                                  previouslyLoggedIn = false;
//                                  animationStatus == 1
//                                      ? _reverseAnimation(1)
//                                      : _reverseAnimation(2);
//                                  return Center(
//                                      child: StaggerAnimation(
//                                        buttonController: animationStatus == 1
//                                            ? _glogInButtonController.view
//                                            : _flogInButtonController.view,
//                                      ));
//                                })
//                          ],
//                        )
//                      ],
//                    ),
//                  ))));
//    }
//  }
//
//  Future getUser() async {
//    FirebaseUser user = await FirebaseAuth.instance.currentUser();
//    if (user == null) {
//      setState(() {
//        currentUser = user;
//        animationStatus = 0;
//      });
//    } else {
//      setState(() {
//        currentUser = user;
//        if (user.providerData[1].providerId == "google.com") {
//          animationStatus = 1;
//          _playAnimation(1);
//        } else {
//          animationStatus = 2;
//          _playAnimation(2);
//        }
//      });
//    }
//  }
//
//  _gSignOut() async {
//    await _googleSignIn.signOut();
//    await _auth.signOut();
//    setState(() {
//      previouslyLoggedIn = true;
//    });
//  }
//
//  _fSignOut() async {
//    _facebookLogin.logOut();
//    _auth.signOut();
//    setState(() {
//      previouslyLoggedIn = true;
//    });
//  }
//
//  Future _gSignIn() async {
//    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
//    GoogleSignInAuthentication googleSignInAuthentication =
//    await googleSignInAccount.authentication;
//
//    FirebaseUser user = await _auth.signInWithGoogle(
//      idToken: googleSignInAuthentication.idToken,
//      accessToken: googleSignInAuthentication.accessToken,
//    );
//    currentUser = user;
//    database
//        .reference()
//        .child("Profiles")
//        .update({"${user.uid}": "${user.email}"});
//    print("User: $user");
//    return user;
//  }
//
//  Future _fSignIn() async {
//    final result = await _facebookLogin.logInWithReadPermissions(['email']);
//    FirebaseUser user;
//    switch (result.status) {
//      case FacebookLoginStatus.loggedIn:
//        print(result.accessToken.token);
//        user = await _auth.signInWithFacebook(
//            accessToken: result.accessToken.token);
//        currentUser = user;
//        print("Facebook user: ");
//        print(user);
//        database
//            .reference()
//            .child("Profiles")
//            .update({"${user.uid}": "${user.email}"});
//        break;
//      case FacebookLoginStatus.cancelledByUser:
//        print('CANCEL _loggedIn=true;ED BY USER');
//        break;
//      case FacebookLoginStatus.error:
//        print(result.errorMessage);
//        break;
//    }
//    return user;
//  }
//
//  SignIn(String str) {
//    return (new Container(
//      width: MediaQuery.of(context).size.width - 80.0,
//      height: 60.0,
//      alignment: FractionalOffset.center,
//      decoration: new BoxDecoration(
//        color: const Color.fromRGBO(247, 64, 106, 1.0),
//        borderRadius: new BorderRadius.all(const Radius.circular(30.0)),
//      ),
//      child: Row(
//        mainAxisAlignment: MainAxisAlignment.center,
//        crossAxisAlignment: CrossAxisAlignment.center,
//        children: <Widget>[
//          Padding(
//            padding: const EdgeInsets.all(15.0),
//            // child: Image( image: str.contains("Google")?AssetImage("images/googleicon.jpg"):AssetImage("images/facebookicon.jpg"),),
//            child: str.contains("Google")
//                ? Icon(
//              google,
//            )
//                : Icon(
//              facebook,
//            ),
//          ),
//          Text(
//            str,
//            maxLines: 1,
//            style: new TextStyle(
//              color: Colors.black,
//              fontSize: 20.0,
//              fontWeight: FontWeight.w300,
//              letterSpacing: 0.3,
//            ),
//          ),
//        ],
//      ),
//    ));
//  }
//}