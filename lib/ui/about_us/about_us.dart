
import 'package:flutter/material.dart';
import '../../util/drawer.dart';

class AboutUsPage extends StatefulWidget {
  @override
  _AboutUsPageState createState() => new _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage>
    with TickerProviderStateMixin {
  var listViewKey = new GlobalKey();
  final scrollController = new ScrollController();

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
      drawer: NavigationDrawer(),
      appBar: AppBar(
        title: Text("About Us"),
      ),
      body: new ListView(
        key: listViewKey,
        controller: scrollController,
        children: <Widget>[
          new Image.asset("images/events.png"),
          new Container(
            padding: EdgeInsets.all(16.0),
            child: new Text(
              'Aavishkar, as its name suggests a blend of innovation, team work and a geeky love for technology, is a tech fest that is not just an arena to exhibit but also an environment to learn. Our motto is to unveil in this college a fantasy world of bytes. From organising prestigious events like Hackathon, to creating an entire tournament for the cricket and football fans, this fest is known for its diverse nature. Aavishkar is a innovation of the future, learning from the past and progressing with the present.',
              style: TextStyle(fontSize: 24.0),
            ),
          ),
          new FadeTransition(
            opacity: boxOpacityOne,
            child: new SlideTransition(
              position: boxPositionOne,
              child: new Container(
                  key: animatedBoxOneKey,
                  height: 750.0,
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      new Image.asset("images/events.png"),
                      new Text(
                        'This time too, Aavishkar comes with a number of attractions including a crypto currency made by the members of GLUG that creates a hype inculcating in the students the concept of a cash-free nation. Eurocoin also holds a number of goodies when redeemed. Capture the flag,  a cyber security based event is captivates the attention of all the hackers, inviting them to turn on the siren. Another icing on the cake is Hackathon, a marathon for the developers be it software or graphics, on a global level it inspires the students to dedicate two sleepless days to a project that will shape the clay of future generations.',
                        style: TextStyle(fontSize: 24.0),
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
                  height: 500.0,
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      new Image.asset("images/events.png"),
                      new Text(
                        'Inviting the students to the battleground, this year Aavishkar has a theme that veils a world every engineer can call home. Taking you to the next level, the 4 days will be exhausted by counter strikes at the opponents and backing your teams. In the midst of rifles, crates and Pokemons, Aavishkar brings to you events that will need you all armed.',
                        style: TextStyle(fontSize: 24.0),
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
                  height: 700.0,
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      new Image.asset("images/events.png"),
                      new Text(
                        "GLUG or GNU/ Linux Users' group is the open source club of NIT Durgapur. A group of people with a flare for technology, GLUG believes in taking the students towards a  development where contributions and distributions are not restricted.\nThe Maths and Tech club of this college, abbreviated as MnTC is a group of logical brains, playing with numbers, a game most students dread.\nSAE, a set of displaced numbers, keys speaking  codes, and engines ready for the green, all put together for the sole purpose, to innovate.",
                        style: TextStyle(fontSize: 24.0),
                      )
                    ],
                  )),
            ),
          ),
          new FlatButton(
            onPressed: () {
              scrollController.jumpTo(0.0);
              animatedBoxOneEnterAnimationController.reset();
              animatedBoxTwoEnterAnimationController.reset();
              animatedBoxThreeEnterAnimationController.reset();
            },
            child: new Text('Move up'),
          )
        ],
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
