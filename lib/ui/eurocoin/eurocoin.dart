import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './eurocoin_transfer.dart';
import './eurocoin_coupon.dart';
import 'package:crypto/crypto.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import '../../util/drawer.dart';

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

  final IconData icon;
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
              icon: new Icon(icon),
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

class EurocoinHomePage extends StatefulWidget {
  EurocoinHomePage({Key key}) : super(key: key);

  @override
  EurocoinHomePageState createState() => new EurocoinHomePageState();
}

enum AppBarBehavior { normal, pinned, floating, snapping }

class EurocoinHomePageState extends State<EurocoinHomePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController referalCode = new TextEditingController();
  final double _appBarHeight = 256.0;
  AppBarBehavior _appBarBehavior = AppBarBehavior.pinned;
  int isEurocoinAlreadyRegistered;
  FirebaseUser currentUser;
  String userReferralCode;
  int userEurocoin;
  bool registerWithReferralCode = false;
  String barcodeString = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    return (currentUser != null)
        ? (isEurocoinAlreadyRegistered == null)
            ? new Scaffold(
                drawer: NavigationDrawer(),
                body: new Container(
                    padding: EdgeInsets.only(bottom: 50.0),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("images/events.png"),
                            fit: BoxFit.cover)),
                    alignment: Alignment.center,
                    child: CircularProgressIndicator()))
            : (isEurocoinAlreadyRegistered == 0)
                ? new Scaffold(
                    drawer: NavigationDrawer(),
                    body: new Stack(
                      children: <Widget>[
                        new Container(
                            padding: EdgeInsets.only(bottom: 50.0),
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("images/events.png"),
                                    fit: BoxFit.cover)),
                            alignment: Alignment.bottomCenter,
                            child: (registerWithReferralCode == true)
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Material(
                                          child: Container(
                                        width: 200.0,
                                        child: TextField(
                                            controller: referalCode,
                                            decoration: InputDecoration(
                                              labelText: "Referal Code",
                                            )),
                                      )),
                                      Container(
                                        child: RaisedButton(
                                          onPressed: () {
                                            registerEuroCoinUser(
                                                referalCode.text);
                                          },
                                          color: Colors.white,
                                          child: Text("Register"),
                                        ),
                                      )
                                    ],
                                  )
                                : Container(
                                    child: RaisedButton(
                                        onPressed: () {
                                          registerEuroCoinUser('');
                                        },
                                        color: Colors.white,
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
                                    child: Text("Have a Referral Code?")),
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
                                    child: Text("No Referral Code?")),
                              )
                      ],
                    ))
                : new Theme(
                    data: new ThemeData(
                      brightness: Brightness.light,
                      primarySwatch: Colors.indigo,
                      platform: Theme.of(context).platform,
                    ),
                    child: new Scaffold(
                      drawer: NavigationDrawer(),
                      key: _scaffoldKey,
                      body: new CustomScrollView(
                        slivers: <Widget>[
                          new SliverAppBar(
                            expandedHeight: _appBarHeight,
                            pinned: _appBarBehavior == AppBarBehavior.pinned,
                            floating:
                                _appBarBehavior == AppBarBehavior.floating ||
                                    _appBarBehavior == AppBarBehavior.snapping,
                            snap: _appBarBehavior == AppBarBehavior.snapping,
                            flexibleSpace: new FlexibleSpaceBar(
                              title: Text('Eurocoin Wallet'),
                              background: new Stack(
                                fit: StackFit.expand,
                                children: <Widget>[
                                  new Image.asset(
                                    "images/events.png",
                                    fit: BoxFit.cover,
                                    height: _appBarHeight,
                                  ),
                                  // This gradient ensures that the toolbar icons are distinct
                                  // against the background image.
                                  const DecoratedBox(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment(0.0, -1.0),
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
                          (userReferralCode != null && userEurocoin != null)
                              ? new SliverList(
                                  delegate:
                                      new SliverChildListDelegate(<Widget>[
                                    DetailCategory(
                                      icon: Icons.swap_horiz,
                                      children: <Widget>[
                                        DetailItem(
                                          lines: <String>[
                                            "You havee: ",
                                            "$userEurocoin"
                                          ],
                                        )
                                      ],
                                    ),
                                    DetailCategory(
                                      icon: Icons.exit_to_app,
                                      children: <Widget>[
                                        DetailItem(
                                          lines: <String>[
                                            "Refer and Earn",
                                            "50 Eurocoins"
                                          ],
                                        ),
                                        DetailItem(
                                          icon: Icons.share,
                                          onPressed: () {
                                            print("Hey");
                                            launch(
                                                "sms:?body=Use my referal code $userReferralCode to get 50 Eurocoins when you register. \nDownload Link: dsd5");
                                          },
                                          lines: <String>[
                                            "Your Refer Code is: ",
                                            "$userReferralCode"
                                          ],
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
                                              child: EurocoinTransfer(
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
                                              child: EurocoinCoupon(
                                                  name: currentUser.displayName,
                                                  email: currentUser.email,
                                                  parent: this)),
                                        )
                                      ],
                                    ),
                                    DetailCategory(
                                      icon: Icons.scanner,
                                      children: <Widget>[
                                        DetailItem(
                                          icon: Icons.scanner,
                                          onPressed: () {
                                            scanQR();
                                          },
                                          lines: <String>["Scan QR Code"],
                                        )
                                      ],
                                    ),
                                  ]),
                                )
                              : new SliverList(
                                  delegate: SliverChildListDelegate(<Widget>[
                                  Container(
                                      height: 2.0,
                                      child: LinearProgressIndicator(
                                          valueColor:
                                              new AlwaysStoppedAnimation<Color>(
                                                  Colors.blueAccent))),
                                ]))
                        ],
                      ),
                    ),
                  )
        : new Container(
            padding: EdgeInsets.only(bottom: 40.0),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/events.png"), fit: BoxFit.cover)),
            alignment: Alignment.bottomCenter,
            child: Stack(
              children: <Widget>[
                Container(
                  child: RaisedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed("/ui/account/login");
                      },
                      color: Colors.white,
                      child: Text("Login First")),
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
    isEuroCoinUserRegistered();
  }

  Future isEuroCoinUserRegistered() async {
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
        isEurocoinAlreadyRegistered = 1;
      });
      getUserEurocoin();
    } else
      setState(() {
        isEurocoinAlreadyRegistered = 0;
      });
  }

  Future registerEuroCoinUser(var referalCode) async {
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
        isEurocoinAlreadyRegistered = 1;
      });
      getUserEurocoin();
    } else
      setState(() {
        isEurocoinAlreadyRegistered = 0;
      });
  }

  Future getUserEurocoin() async {
    var email = currentUser.email;
    var name = currentUser.displayName;
    var bytes = utf8.encode("$email" + "$name");
    var encoded = sha1.convert(bytes);
    String apiUrl = "https://eurekoin.avskr.in/api/coins/$encoded";
    http.Response response = await http.get(apiUrl);
    var status = json.decode(response.body)['coins'];
    setState(() {
      userEurocoin = status;
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
        Future<int> result = couponEurocoin(barcodeString.substring(7));
        result.then((value) {
          print(value);
          if (value == 0) {
            setState(() {
              barcodeString = "Successful!";
            });
            getUserEurocoin();
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
//      setState(() {
//        barcodeString =
//            'null (User returned using the "back"-button before scanning anything. Result)';
//        showDialogBox(barcodeString);
//      });
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

  Future<int> couponEurocoin(String coupon) async {
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
}
