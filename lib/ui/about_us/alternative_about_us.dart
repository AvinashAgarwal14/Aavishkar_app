import 'package:flutter/material.dart';
import '../../util/drawer.dart';

class AboutUsPage extends StatefulWidget {
  @override
  _AboutUsPageState createState() => new _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage>
    with TickerProviderStateMixin {
  final listViewKey = new GlobalKey();
  final scrollController = new ScrollController();

  final animatedBoxOneKey = new GlobalKey();
  AnimationController animatedBoxOneEnterAnimationController;

  final animatedBoxTwoKey = new GlobalKey();
  AnimationController animatedBoxTwoEnterAnimationController;

  final animatedBoxThreeKey = new GlobalKey();
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
    final boxOpacityOne = CurveTween(curve: Curves.easeIn)
        .animate(animatedBoxOneEnterAnimationController);
    final boxPositionOne = Tween(begin: Offset(0.0, 0.01), end: Offset.zero)
        .chain(CurveTween(curve: Curves.easeIn))
        .animate(animatedBoxOneEnterAnimationController);

    final boxOpacityTwo = CurveTween(curve: Curves.easeIn)
        .animate(animatedBoxTwoEnterAnimationController);
    final boxPositionTwo = Tween(begin: Offset(0.0, 0.01), end: Offset.zero)
        .chain(CurveTween(curve: Curves.easeIn))
        .animate(animatedBoxTwoEnterAnimationController);

    final boxOpacityThree = CurveTween(curve: Curves.easeIn)
        .animate(animatedBoxThreeEnterAnimationController);
    final boxPositionThree = Tween(begin: Offset(0.0, 0.01), end: Offset.zero)
        .chain(CurveTween(curve: Curves.easeIn))
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
              'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.',
              style: TextStyle(fontSize: 24.0),
            ),
          ),
          new FadeTransition(
            opacity: boxOpacityOne,
            child: new SlideTransition(
              position: boxPositionOne,
              child: new Container(
                  key: animatedBoxOneKey,
                  height: 900.0,
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      new Image.asset("images/events.png"),
                      new Text(
                        'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.',
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
                  height: 900.0,
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      new Image.asset("images/events.png"),
                      new Text(
                        'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.',
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
                  height: 800.0,
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      new Image.asset("images/events.png"),
                      new Text(
                        'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.',
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
