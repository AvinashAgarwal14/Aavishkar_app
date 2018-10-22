import 'package:flutter/material.dart';
import '../../util/drawer.dart';

class AboutUsPage extends StatefulWidget {
  @override
  _AboutUsPageState createState() => new _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage>
    with TickerProviderStateMixin {
  var listViewKey = new GlobalKey();
  var scrollController = new ScrollController();

  var animatedBoxOneKey = new GlobalKey();
  AnimationController animatedBoxOneEnterAnimationController;

  var animatedBoxTwoKey = new GlobalKey();
  AnimationController animatedBoxTwoEnterAnimationController;

  var animatedBoxThreeKey = new GlobalKey();
  AnimationController animatedBoxThreeEnterAnimationController;

  @override
  void initState() {
    super.initState();
    animatedBoxOneEnterAnimationController = new AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    );
    animatedBoxTwoEnterAnimationController = new AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    );
    animatedBoxThreeEnterAnimationController = new AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    );
    scrollController.addListener(() {
      _updateAnimatedBoxOneEnterAnimation();
      _updateAnimatedBoxTwoEnterAnimation();
      _updateAnimatedBoxThreeEnterAnimation();
    });
  }

  static const enterAnimationMinHeight = 100.0;

  _updateAnimatedBoxOneEnterAnimation() {
    if (animatedBoxOneEnterAnimationController.status !=
        AnimationStatus.dismissed) {
      return; // animation already in progress/finished
    }
    RenderObject listViewObject =
        listViewKey.currentContext?.findRenderObject();
    RenderObject animatedBoxObject =
        animatedBoxOneKey.currentContext?.findRenderObject();
    if (listViewObject == null || animatedBoxObject == null) return;
    final listViewHeight = listViewObject.paintBounds.height;
    final animatedObjectTop =
        animatedBoxObject.getTransformTo(listViewObject).getTranslation().y;
    final animatedBoxVisible =
        (animatedObjectTop + enterAnimationMinHeight < listViewHeight);
    if (animatedBoxVisible) {
      // start animation
      animatedBoxOneEnterAnimationController.forward();
    }
  }

  _updateAnimatedBoxTwoEnterAnimation() {
    if (animatedBoxTwoEnterAnimationController.status !=
        AnimationStatus.dismissed) {
      return; // animation already in progress/finished
    }
    RenderObject listViewObject =
        listViewKey.currentContext?.findRenderObject();
    RenderObject animatedBoxObject =
        animatedBoxTwoKey.currentContext?.findRenderObject();
    if (listViewObject == null || animatedBoxObject == null) return;
    final listViewHeight = listViewObject.paintBounds.height;
    final animatedObjectTop =
        animatedBoxObject.getTransformTo(listViewObject).getTranslation().y;
    final animatedBoxVisible =
        (animatedObjectTop + enterAnimationMinHeight < listViewHeight);
    if (animatedBoxVisible) {
      // start animation
      animatedBoxTwoEnterAnimationController.forward();
    }
  }

  _updateAnimatedBoxThreeEnterAnimation() {
    if (animatedBoxThreeEnterAnimationController.status !=
        AnimationStatus.dismissed) {
      return; // animation already in progress/finished
    }
    RenderObject listViewObject =
        listViewKey.currentContext?.findRenderObject();
    RenderObject animatedBoxObject =
        animatedBoxThreeKey.currentContext?.findRenderObject();
    if (listViewObject == null || animatedBoxObject == null) return;
    final listViewHeight = listViewObject.paintBounds.height;
    final animatedObjectTop =
        animatedBoxObject.getTransformTo(listViewObject).getTranslation().y;
    final animatedBoxVisible =
        (animatedObjectTop + enterAnimationMinHeight < listViewHeight);
    if (animatedBoxVisible) {
      // start animation
      animatedBoxThreeEnterAnimationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final boxOpacityOne = CurveTween(curve: Curves.easeOut)
        .animate(animatedBoxOneEnterAnimationController);
    final boxPositionOne = Tween(begin: Offset(-1.0, 0.0), end: Offset.zero)
        .chain(CurveTween(curve: Curves.elasticOut))
        .animate(animatedBoxOneEnterAnimationController);

    final boxOpacityTwo = CurveTween(curve: Curves.easeOut)
        .animate(animatedBoxTwoEnterAnimationController);
    final boxPositionTwo = Tween(begin: Offset(-1.0, 0.0), end: Offset.zero)
        .chain(CurveTween(curve: Curves.elasticOut))
        .animate(animatedBoxTwoEnterAnimationController);

    final boxOpacityThree = CurveTween(curve: Curves.easeOut)
        .animate(animatedBoxThreeEnterAnimationController);
    final boxPositionThree = Tween(begin: Offset(-1.0, 0.0), end: Offset.zero)
        .chain(CurveTween(curve: Curves.elasticOut))
        .animate(animatedBoxThreeEnterAnimationController);

    return new Scaffold(
      drawer: NavigationDrawer(currentDisplayedPage: 7),
      appBar: AppBar(
        title: Text("About Aavishkar"),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/About Us/About Us 0.jpeg"),
                fit: BoxFit.fill)),
        child: new ListView(
          key: listViewKey,
          controller: scrollController,
          children: <Widget>[
            new Container(
              padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
              child: new ClipRRect(
                  borderRadius: new BorderRadius.circular(10.0),
                  child: new Image.asset("images/About Us/About Us 1.png")),
            ),
            new Container(
              alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(23.0, 0.0, 23.0, 23.0),
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: new Text(
                  'Aavishkar, as its name suggests a blend of innovation, team work and a geeky love for technology, is a tech fest that is not just an arena to exhibit but also an environment to learn. Our motto is to unveil in this college a fantasy world of bytes. From organising prestigious events like Hackathon, to creating an entire tournament for the cricket and football fans, this fest is known for its diverse nature. Aavishkar is  a innovation of the future, learning from the past and progressing with the present',
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            new FadeTransition(
              opacity: boxOpacityOne,
              child: new SlideTransition(
                position: boxPositionOne,
                child: new Container(
                    key: animatedBoxOneKey,
//                  height: 750.0,
                    padding: EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0.0),
                    child: Column(
                      children: <Widget>[
                        new ClipRRect(
                            borderRadius: new BorderRadius.circular(10.0),
                            child: new Image.asset(
                              "images/About Us/About Us 2.png",
                              fit: BoxFit.fill,
                            )),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: new Text(
                            'This time around, Aavishkar has a lot more in store than just technology. With a number of attractions like one of the first digital currency mediums, Eurekoins, which can be used to redeem goodies and privileges, a lot of fun and technology awaits. For all the innovative techies out there, brain wracking events like the Hackathon, ScienceX, Capture the Flag, Transmission and Codecracker with exciting cash prizes await. With special attractions like the Army Vehicle Display and the Robotics arena for the automobile and robotics enthusiasts, Cycle stunts for adrenaline junkies and exciting treasure hunts like Terrorist Takedown, we have something for everyone!',
                            style:
                                TextStyle(fontSize: 20.0, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    )),
              ),
            ),
            new FadeTransition(
              opacity: boxOpacityTwo,
              child: new SlideTransition(
                position: boxPositionTwo,
                child: new Container(
                    key: animatedBoxTwoKey,
//                  height: 500.0,
                    padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
                    child: Column(
                      children: <Widget>[
                        new ClipRRect(
                            borderRadius: new BorderRadius.circular(10.0),
                            child: new Image.asset(
                              "images/About Us/About Us 3.png",
                              fit: BoxFit.fill,
                            )),
                        Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: new Text(
                            ' Inviting students to the battle ground to prove their mettle, Aavishkar has a theme that veils a world that an engineer can call home. The four days will be exhausted by counter strikes at the opponents and backing your teams. In the midst of rifles, crates and Pokemons, Aavishkar brings to you overnight gaming events and many more that will need you all armed. Through the theme of gaming, this Aavishkar, we welcome you to the next level.',
                            style:
                                TextStyle(fontSize: 20.0, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    )),
              ),
            ),
            new FadeTransition(
              opacity: boxOpacityThree,
              child: new SlideTransition(
                position: boxPositionThree,
                child: new Container(
                    key: animatedBoxThreeKey,
//                  height: 700.0,
                    padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
                    child: Column(
                      children: <Widget>[
                        new ClipRRect(
                            borderRadius: new BorderRadius.circular(10.0),
                            child: new Image.asset(
                                "images/About Us/About Us 4.png",
                                fit: BoxFit.fill)),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: new Text(
                            " With technology taking centre stage and striking the perfect balance between innovation and fun, Aavishkar is here to give you an enthralling experience and break the confines of a technical fest. From workshops on trending technologies to fun events like Human Foosball and Laser Tag, there's something to cater to all your whimsies. So don’t miss out and come on down this Aavishkar and prepare to be enchanted by the myriad brain wracking events, exciting performances, inspiring speeches and enlightening workshops. Get ready to transcend to the next level.",
                            style:
                                TextStyle(fontSize: 20.0, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: new FlatButton(
                  onPressed: () {
                    scrollController.jumpTo(0.0);
                    animatedBoxOneEnterAnimationController.reset();
                    animatedBoxTwoEnterAnimationController.reset();
                   animatedBoxThreeEnterAnimationController.reset();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Text(
                        "Move Up",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      new Icon(
                        Icons.arrow_upward,
                        color: Colors.white,
                      )
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}

//import 'package:flutter/material.dart';
//import '../../util/drawer.dart';
//
//class AboutUsPage extends StatefulWidget {
//  @override
//  _AboutUsPageState createState() => new _AboutUsPageState();
//}
//
//class _AboutUsPageState extends State<AboutUsPage>
//    with TickerProviderStateMixin {
//  var listViewKey = new GlobalKey();
//  final scrollController = new ScrollController();
//
//  var animatedBoxOneKey = new GlobalKey();
//  AnimationController animatedBoxOneEnterAnimationController;
//
//  var animatedBoxTwoKey = new GlobalKey();
//  AnimationController animatedBoxTwoEnterAnimationController;
//
//  var animatedBoxThreeKey = new GlobalKey();
//  AnimationController animatedBoxThreeEnterAnimationController;
//
//  @override
//  void initState() {
//    super.initState();
//    animatedBoxOneEnterAnimationController = new AnimationController(
//      vsync: this,
//      duration: Duration(milliseconds: 2000),
//    );
//    animatedBoxTwoEnterAnimationController = new AnimationController(
//      vsync: this,
//      duration: Duration(milliseconds: 2000),
//    );
//    animatedBoxThreeEnterAnimationController = new AnimationController(
//      vsync: this,
//      duration: Duration(milliseconds: 2000),
//    );
//    scrollController.addListener(() {
//      _updateAnimatedBoxOneEnterAnimation();
//      _updateAnimatedBoxTwoEnterAnimation();
//      _updateAnimatedBoxThreeEnterAnimation();
//    });
//  }
//
//  static const enterAnimationMinHeight = 100.0;
//
//  _updateAnimatedBoxOneEnterAnimation() {
//    if (animatedBoxOneEnterAnimationController.status !=
//        AnimationStatus.dismissed) {
//      return; // animation already in progress/finished
//    }
//    RenderObject listViewObject =
//    listViewKey.currentContext?.findRenderObject();
//    RenderObject animatedBoxObject =
//    animatedBoxOneKey.currentContext?.findRenderObject();
//    if (listViewObject == null || animatedBoxObject == null) return;
//    final listViewHeight = listViewObject.paintBounds.height;
//    final animatedObjectTop =
//        animatedBoxObject.getTransformTo(listViewObject).getTranslation().y;
//    final animatedBoxVisible =
//    (animatedObjectTop + enterAnimationMinHeight < listViewHeight);
//    if (animatedBoxVisible) {
//      // start animation
//      animatedBoxOneEnterAnimationController.forward();
//    }
//  }
//
//  _updateAnimatedBoxTwoEnterAnimation() {
//    if (animatedBoxTwoEnterAnimationController.status !=
//        AnimationStatus.dismissed) {
//      return; // animation already in progress/finished
//    }
//    RenderObject listViewObject =
//    listViewKey.currentContext?.findRenderObject();
//    RenderObject animatedBoxObject =
//    animatedBoxTwoKey.currentContext?.findRenderObject();
//    if (listViewObject == null || animatedBoxObject == null) return;
//    final listViewHeight = listViewObject.paintBounds.height;
//    final animatedObjectTop =
//        animatedBoxObject.getTransformTo(listViewObject).getTranslation().y;
//    final animatedBoxVisible =
//    (animatedObjectTop + enterAnimationMinHeight < listViewHeight);
//    if (animatedBoxVisible) {
//      // start animation
//      animatedBoxTwoEnterAnimationController.forward();
//    }
//  }
//
//  _updateAnimatedBoxThreeEnterAnimation() {
//    if (animatedBoxThreeEnterAnimationController.status !=
//        AnimationStatus.dismissed) {
//      return; // animation already in progress/finished
//    }
//    RenderObject listViewObject =
//    listViewKey.currentContext?.findRenderObject();
//    RenderObject animatedBoxObject =
//    animatedBoxThreeKey.currentContext?.findRenderObject();
//    if (listViewObject == null || animatedBoxObject == null) return;
//    final listViewHeight = listViewObject.paintBounds.height;
//    final animatedObjectTop =
//        animatedBoxObject.getTransformTo(listViewObject).getTranslation().y;
//    final animatedBoxVisible =
//    (animatedObjectTop + enterAnimationMinHeight < listViewHeight);
//    if (animatedBoxVisible) {
//      // start animation
//      animatedBoxThreeEnterAnimationController.forward();
//    }
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    final boxOpacityOne = CurveTween(curve: Curves.easeOut)
//        .animate(animatedBoxOneEnterAnimationController);
//    final boxPositionOne = Tween(begin: Offset(-1.0, 0.0), end: Offset.zero)
//        .chain(CurveTween(curve: Curves.elasticOut))
//        .animate(animatedBoxOneEnterAnimationController);
//
//    final boxOpacityTwo = CurveTween(curve: Curves.easeOut)
//        .animate(animatedBoxTwoEnterAnimationController);
//    final boxPositionTwo = Tween(begin: Offset(-1.0, 0.0), end: Offset.zero)
//        .chain(CurveTween(curve: Curves.elasticOut))
//        .animate(animatedBoxTwoEnterAnimationController);
//
//    final boxOpacityThree = CurveTween(curve: Curves.easeOut)
//        .animate(animatedBoxThreeEnterAnimationController);
//    final boxPositionThree = Tween(begin: Offset(-1.0, 0.0), end: Offset.zero)
//        .chain(CurveTween(curve: Curves.elasticOut))
//        .animate(animatedBoxThreeEnterAnimationController);
//
//    return new Scaffold(
//      drawer: NavigationDrawer(),
//      appBar: AppBar(
//        title: Text("About Us"),
//      ),
//      body: new ListView(
//        key: listViewKey,
//        controller: scrollController,
//        children: <Widget>[
//          new Image.asset("images/events.png"),
//          new Container(
//            padding: EdgeInsets.all(16.0),
//            child: new Text(
//              'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.',
//              style: TextStyle(fontSize: 24.0),
//            ),
//          ),
//          new FadeTransition(
//            opacity: boxOpacityOne,
//            child: new SlideTransition(
//              position: boxPositionOne,
//              child: new Container(
//                  key: animatedBoxOneKey,
//                  height: 800.0,
//                  padding: EdgeInsets.all(16.0),
//                  child: Column(
//                    children: <Widget>[
//                      new Image.asset("images/events.png"),
//                      new Text(
//                        'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.',
//                        style: TextStyle(fontSize: 24.0),
//                      )
//                    ],
//                  )),
//            ),
//          ),
//          new FadeTransition(
//            opacity: boxOpacityTwo,
//            child: new SlideTransition(
//              position: boxPositionTwo,
//              child: new Container(
//                  key: animatedBoxTwoKey,
//                  height: 900.0,
//                  padding: EdgeInsets.all(16.0),
//                  child: Column(
//                    children: <Widget>[
//                      new Image.asset("images/events.png"),
//                      new Text(
//                        'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.',
//                        style: TextStyle(fontSize: 24.0),
//                      )
//                    ],
//                  )),
//            ),
//          ),
//          new FadeTransition(
//            opacity: boxOpacityThree,
//            child: new SlideTransition(
//              position: boxPositionThree,
//              child: new Container(
//                  key: animatedBoxThreeKey,
//                  height: 800.0,
//                  padding: EdgeInsets.all(16.0),
//                  child: Column(
//                    children: <Widget>[
//                      new Image.asset("images/events.png"),
//                      new Text(
//                        'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.',
//                        style: TextStyle(fontSize: 24.0),
//                      )
//                    ],
//                  )),
//            ),
//          ),
//          new FlatButton(
//            onPressed: () {
//              scrollController.jumpTo(0.0);
//              animatedBoxOneEnterAnimationController.reset();
//              animatedBoxTwoEnterAnimationController.reset();
//              animatedBoxThreeEnterAnimationController.reset();
//            },
//            child: new Text('Move up'),
//          )
//        ],
//      ),
//    );
//  }
//}
