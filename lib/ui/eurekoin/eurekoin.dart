import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './eurekoin_transfer.dart';
import './eurekoin_coupon.dart';
import 'package:crypto/crypto.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:share/share.dart';
import 'dart:convert';
import '../../util/drawer.dart';
import 'package:intl/intl.dart';

class DetailCategory extends StatelessWidget {
  const DetailCategory({Key key, this.icon, this.children}) : super(key: key);

  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return new Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: new BoxDecoration(
          border: new Border(
              bottom: new BorderSide(color: themeData.dividerColor))),
      child: new DefaultTextStyle(
        style: Theme.of(context).textTheme.subhead,
        child: new SafeArea(
          top: false,
          bottom: false,
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Container(
                  padding: (icon != Icons.transfer_within_a_station)
                      ? const EdgeInsets.symmetric(vertical: 24.0)
                      : const EdgeInsets.only(
                          top: 24.0, left: 10.0, bottom: 24.0),
                  width: 72.0,
                  child: new Icon(icon, color: themeData.primaryColor)),
              new Expanded(child: new Column(children: children))
            ],
          ),
        ),
      ),
    );
  }
}

class DetailItem extends StatelessWidget {
  DetailItem({Key key, this.icon, this.lines, this.tooltip, this.onPressed})
      : super(key: key);

  final icon;
  final List<String> lines;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final List<Widget> columnChildren =
        lines.map((String line) => new Text(line)).toList();

    final List<Widget> rowChildren = <Widget>[
      new Expanded(
          child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: columnChildren))
    ];
    if (icon != null) {
      rowChildren.add(new SizedBox(
          width: 72.0,
          child: new IconButton(
              icon: icon,
              color: themeData.primaryColor,
              onPressed: onPressed)));
    } else {
      rowChildren.add(new SizedBox(
        width: 60.0,
        child: Container(),
      ));
    }
    return new MergeSemantics(
      child: new Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: rowChildren)),
    );
  }
}


class EurekoinHomePage extends StatefulWidget {
  EurekoinHomePage({Key key}) : super(key: key);

  @override
  EurekoinHomePageState createState() => new EurekoinHomePageState();
}

enum AppBarBehavior { normal, pinned, floating, snapping }

class EurekoinHomePageState extends State<EurekoinHomePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController referalCode = new TextEditingController();
  var scrollController = new TrackingScrollController();
  final double _appBarHeight = 256.0;
  AppBarBehavior _appBarBehavior = AppBarBehavior.pinned;
  int isEurekoinAlreadyRegistered;
  FirebaseUser currentUser;
  String userReferralCode;
  int userEurekoin;
  bool registerWithReferralCode = false;
  String barcodeString = "";
  var transHistory;
  List<ListTile> buildItems;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUser();
    scrollController.addListener(() {
//      print(scrollController.position);
    });
    transHistory = null;
    buildItems = new List();
  }

  @override
  Widget build(BuildContext context) {
    return (currentUser != null)
        ? (isEurekoinAlreadyRegistered == null)
            ? new Scaffold(
                drawer: NavigationDrawer(currentDisplayedPage: 1),
                body: new Container(
                    padding: EdgeInsets.only(bottom: 50.0),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("images/eurekoin.png"),
                            fit: BoxFit.fill))))
            : (isEurekoinAlreadyRegistered == 0)
                ? new Scaffold(
                    drawer: NavigationDrawer(currentDisplayedPage: 1),
                    body: new Stack(
                      children: <Widget>[
                        new Container(
                            padding: EdgeInsets.only(bottom: 50.0),
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("images/eurekoin.png"),
                                    fit: BoxFit.fill)),
                            alignment: Alignment.bottomCenter,
                            child: (registerWithReferralCode == true)
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      SizedBox(
                                          width: 150.0,
                                          child: TextFormField(
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white),
                                              controller: referalCode,
                                              decoration: InputDecoration(
                                                fillColor: Colors.white,
                                                hintStyle: TextStyle(
                                                    color: Colors.white),
                                                border: InputBorder.none,
                                                hintText: "Referal Code",
                                              ))),
                                      Container(
                                        child: RaisedButton(
                                          color: Color(0xFF00f6ff),
                                          onPressed: () {
                                            registerEurekoinUser(
                                                referalCode.text);
                                          },
                                          //color: Colors.white,
                                          child: Text("Register"),
                                        ),
                                      )
                                    ],
                                  )
                                : Container(
                                    child: RaisedButton(
                                        color: Color(0xFF00f6ff),
                                        onPressed: () {
                                          registerEurekoinUser('');
                                        },
                                        //color: Colors.white,
                                        child: Text("Register")),
                                  )),
                        (registerWithReferralCode == false)
                            ? Container(
                                padding:
                                    EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 5.0),
                                alignment: Alignment.bottomRight,
                                child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        registerWithReferralCode = true;
                                      });
                                    },
                                    child: Text("Have a Referral Code?",
                                        style: TextStyle(color: Colors.white))),
                              )
                            : Container(
                                padding:
                                    EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 5.0),
                                alignment: Alignment.bottomRight,
                                child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        registerWithReferralCode = false;
                                      });
                                    },
                                    child: Text("No Referral Code?",
                                        style: TextStyle(color: Colors.white))),
                              )
                      ],
                    ))
                : new Scaffold(
                    drawer: NavigationDrawer(currentDisplayedPage: 1),
                    key: _scaffoldKey,
                    body: new CustomScrollView(
                      controller: scrollController,
                      slivers: <Widget>[
                        new SliverAppBar(
                          expandedHeight: _appBarHeight,
                          pinned: _appBarBehavior == AppBarBehavior.pinned,
                          floating:
                              _appBarBehavior == AppBarBehavior.floating ||
                                  _appBarBehavior == AppBarBehavior.snapping,
                          snap: _appBarBehavior == AppBarBehavior.snapping,
                          flexibleSpace: new FlexibleSpaceBar(
                            title: Text('Eurekoin Wallet'),
                            background: new Stack(
                              fit: StackFit.expand,
                              children: <Widget>[
                                new Image.asset(
                                  "images/gifs/eurekoinSliver.gif",
                                  fit: BoxFit.cover,
                                  height: _appBarHeight,
                                ),
                                // This gradient ensures that the toolbar icons are distinct
                                // against the background image.
                                const DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment(0.0, 0.6),
                                      end: Alignment(0.0, -0.4),
                                      colors: <Color>[
                                        Color(0x60000000),
                                        Color(0x00000000)
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        (userReferralCode != null && userEurekoin != null)
                            ? new SliverList(
                                delegate: new SliverChildListDelegate(<Widget>[
                                  DetailCategory(
                                    icon: Icons.monetization_on,
                                    children: <Widget>[
                                      DetailItem(
                                        lines: <String>[
                                          "You have: ",
                                          "$userEurekoin"
                                        ],
                                      )
                                    ],
                                  ),
                                  DetailCategory(
                                    icon: Icons.message,
                                    children: <Widget>[
                                      DetailItem(
                                        lines: <String>[
                                          "Refer and Earn",
                                          "25 Eurekoins"
                                        ],
                                      ),
                                      DetailItem(
                                        icon: Icon(Icons.share),
                                        onPressed: (){
                                          Share.share('Use my referal code $userReferralCode to get 25 Eurekoins when you register. \nLink: https://play.google.com/store/apps/details?id=com.app.aavishkar.aavishkarapp');
                                        },
                                        lines: <String>[
                                          "Your Referral Code is: ",
                                          "$userReferralCode"
                                        ],
                                      )
                                    ],
                                  ),
                                  DetailCategory(
                                    icon: Icons.location_searching,
                                    children: <Widget>[
                                      DetailItem(
                                        icon: Image(
                                            image:
                                                AssetImage("images/QRIcon.png"),
                                            color: Color(0xFF505194)),
                                        onPressed: () {
                                          scanQR();
                                        },
                                        lines: <String>["Scan QR Code"],
                                      )
                                    ],
                                  ),
                                  DetailCategory(
                                    icon: Icons.transfer_within_a_station,
                                    children: <Widget>[
                                      new MergeSemantics(
                                        child: new Padding(
                                            padding: EdgeInsets.only(
                                                left: 0.0,
                                                top: 10.0,
                                                right: 10.0),
                                            child: EurekoinTransfer(
                                                name: currentUser.displayName,
                                                email: currentUser.email,
                                                parent: this)),
                                      )
                                    ],
                                  ),
                                  DetailCategory(
                                    icon: Icons.monetization_on,
                                    children: <Widget>[
                                      new MergeSemantics(
                                        child: new Padding(
                                            padding: EdgeInsets.only(
                                                left: 0.0,
                                                top: 10.0,
                                                right: 10.0),
                                            child: EurekoinCoupon(
                                                name: currentUser.displayName,
                                                email: currentUser.email,
                                                parent: this)),
                                      )
                                    ],
                                  ),
                                  DetailCategory(
                                    icon: Icons.format_line_spacing,
                                    children: <Widget>[
                                      new MergeSemantics(
                                        child: new Padding(
                                            padding: EdgeInsets.only(
                                                left: 0.0,
                                                top: 10.0,
                                                right: 10.0),
                                            child: Container(
                                              color: Theme.of(context).brightness==Brightness.light?Colors.white:Color(0xff424242),
                                             child: (transHistory == null)
                                                 ? ExpansionTile(
                                                 title: Text('Transactions History'),
                                                 backgroundColor: Theme.of(context).brightness == Brightness.light
                                                     ? Colors.white
                                                     : Color(0xff424242),
                                                 children: <Widget>[
                                                   LinearProgressIndicator(
                                                       valueColor:
                                                       new AlwaysStoppedAnimation<Color>(Color(0xFF505194)))
                                                 ])
                                                 : (transHistory.length != 0)
                                                 ? ExpansionTile(
                                                 title: Text('Transactions History'),
                                                 backgroundColor:
                                                 Theme.of(context).brightness == Brightness.light
                                                     ? Colors.white
                                                     : Color(0xff424242),
                                                 children: buildTransactionsWidget())
                                                 : ExpansionTile(
                                                 title: Text('Transactions History'),
                                                 backgroundColor:
                                                 Theme.of(context).brightness == Brightness.light
                                                     ? Colors.white
                                                     : Color(0xff424242),
                                                 children: <Widget>[
                                                   ListTile(title: Text("No Transactions made."))
                                                 ]),
                                            )
                                            ),
                                          )
                                    ],
                                  )
                                ]),
                              )
                            : new SliverList(
                                delegate: SliverChildListDelegate(<Widget>[
                                Container(
                                    height: 2.0,
                                    child: LinearProgressIndicator(
                                        valueColor:
                                            new AlwaysStoppedAnimation<Color>(
                                                Color(0xFF505194)))),
                              ]))
                      ],
                    ),
                  )
        : new Container(
            padding: EdgeInsets.only(bottom: 40.0),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/eurekoin.png"),
                    fit: BoxFit.fill)),
            alignment: Alignment.bottomCenter,
            child: Stack(
              children: <Widget>[
                Container(
                  child: RaisedButton(
                      color: Color(0xFF00f6ff),
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed("/ui/account/login")
                            .then((onReturn) {
                          _getUser();
                        });
                      },
                      child: Text("Login",style: TextStyle(color: Colors.black) ,)),
                )
              ],
            ));
  }

  Future _getUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    print(user);
    setState(() {
      currentUser = user;
    });
    isEurekoinUserRegistered();
  }

  Future isEurekoinUserRegistered() async {
    var email = currentUser.email;
    var name = currentUser.displayName;
    var bytes = utf8.encode("$email" + "$name");
    var encoded = sha1.convert(bytes);
    print(encoded);

    String apiUrl = "https://eurekoin.avskr.in/api/exists/$encoded";
    http.Response response = await http.get(apiUrl);
    var status = json.decode(response.body)['status'];
    if (status == '1') {
      setState(() {
        isEurekoinAlreadyRegistered = 1;
      });
      getUserEurekoin();
      transactionsHistory();
    } else
      setState(() {
        isEurekoinAlreadyRegistered = 0;
      });
  }

  Future registerEurekoinUser(var referalCode) async {
    var email = currentUser.email;
    var name = currentUser.displayName;
    var bytes = utf8.encode("$email" + "$name");
    var encoded = sha1.convert(bytes);

    String apiUrl =
        "https://eurekoin.avskr.in/api/register/$encoded?name=$name&email=$email&referred_invite_code=$referalCode&image=${currentUser.photoUrl}";
    http.Response response = await http.get(apiUrl);
    var status = json.decode(response.body)['status'];
    if (status == '0') {
      setState(() {
        isEurekoinAlreadyRegistered = 1;
      });
      getUserEurekoin();
    } else
      setState(() {
        isEurekoinAlreadyRegistered = 0;
      });
  }

  Future getUserEurekoin() async {
    var email = currentUser.email;
    var name = currentUser.displayName;
    var bytes = utf8.encode("$email" + "$name");
    var encoded = sha1.convert(bytes);
    String apiUrl = "https://eurekoin.avskr.in/api/coins/$encoded";
    http.Response response = await http.get(apiUrl);
    var status = json.decode(response.body)['coins'];
    setState(() {
      userEurekoin = status;
    });
    getReferralCode();
  }

  Future getReferralCode() async {
    var email = currentUser.email;
    var name = currentUser.displayName;
    var bytes = utf8.encode("$email" + "$name");
    var encoded = sha1.convert(bytes);
    String apiUrl = "https://eurekoin.avskr.in/api/invite_code/$encoded";
    http.Response response = await http.get(apiUrl);
    print(response.body);
    var referralCode = json.decode(response.body)['invite_code'];
    setState(() {
      userReferralCode = referralCode;
    });
  }

  Future scanQR() async {
    try {
      String hiddenString = await BarcodeScanner.scan();
      setState(() {
        barcodeString = hiddenString;
        Future<int> result = couponEurekoin(barcodeString);
        result.then((value) {
          print(value);
          if (value == 0) {
            setState(() {
              barcodeString = "Successful!";
            });
            getUserEurekoin();
            showDialogBox(barcodeString);
          } else if (value == 2)
            setState(() {
              barcodeString = "Invalid Coupon";
              showDialogBox(barcodeString);
            });
          else if (value == 3)
            setState(() {
              barcodeString = "Already Used";
              showDialogBox(barcodeString);
            });
          else if (value == 4)
            setState(() {
              barcodeString = "Coupon Expired";
              showDialogBox(barcodeString);
            });
        });
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          barcodeString = 'The user did not grant the camera permission!';
          showDialogBox(barcodeString);
        });
      } else {
        setState(() {
          barcodeString = 'Unknown error: $e';
          showDialogBox(barcodeString);
        });
      }
    } on FormatException {
      setState(() {
//        barcodeString = 'null (User returned using the "back"-button before scanning anything. Result)';
//        showDialogBox(barcodeString);
      });
    } catch (e) {
      setState(() {
        barcodeString = 'Unknown error: $e';
        showDialogBox(barcodeString);
      });
    }
  }

  void showDialogBox(String message) {
    // flutter defined function
    print("$message");
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("QR Code Result"),
          content: new Text("$message"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<int> couponEurekoin(String coupon) async {
    var email = currentUser.email;
    var name = currentUser.displayName;
    var bytes = utf8.encode("$email" + "$name");
    var encoded = sha1.convert(bytes);
    String apiUrl =
        "https://eurekoin.avskr.in/api/coupon/$encoded/?code=$coupon";
    print(apiUrl);
    http.Response response = await http.get(apiUrl);
    print(response.body);
    var status = json.decode(response.body)['status'];
    return int.parse(status);
  }

  void moveDown() {
    scrollController.position.animateTo(scrollController.offset + 180.0,
        duration: Duration(milliseconds: 500), curve: Curves.easeOut);
  }

  Future transactionsHistory() async {
    var email = currentUser.email;
    var name = currentUser.displayName;
    var bytes = utf8.encode("$email" + "$name");
    var encoded = sha1.convert(bytes);
    print("transHistory");

    String apiUrl = "https://eurekoin.avskr.in/api/history/$encoded";
    print(apiUrl);
    http.Response response = await http.get(apiUrl);
    setState(() {
      transHistory = json.decode(response.body)['history'];
    });
    print(transHistory.length);
  }

  List buildTransactionsWidget() {
    buildItems = new List();
    for (var item in transHistory) {
      var time = new DateFormat.yMMMd().add_jm().format(DateTime.parse(item['created_at']).toLocal());
      if (item['receiver'] == currentUser.email) {
        buildItems.add(ListTile(
            title: Text("Received from:"),
            isThreeLine: true,
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("${item['source']}", style: TextStyle(color:Theme.of(context).brightness == Brightness.light
                    ? Colors.black:Colors.white)),
                Text("$time")
              ],
            ),
            trailing: Text("+ ${item['amount']}",
                style: TextStyle(color: Colors.green))));
      } else {
        buildItems.add(ListTile(
            title: Text("Sent to:"),
            subtitle:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("${item['receiver']}", style: TextStyle(color:Theme.of(context).brightness == Brightness.light
                    ? Colors.black:Colors.white)),
                Text("$time")
              ],
            ),
            isThreeLine: true,
            trailing: Text("- ${item['amount']}",
                style: TextStyle(color: Colors.red))));
      }
    }
    return buildItems.toList();
  }
}
