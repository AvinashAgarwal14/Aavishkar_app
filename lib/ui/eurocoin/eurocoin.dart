import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './eurocoin_transfer.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class DetailCategory extends StatelessWidget {
  const DetailCategory({ Key key, this.icon, this.children }) : super(key: key);

  final IconData icon;
  final List<Widget> children;

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
                  padding: (icon!=Icons.transfer_within_a_station)?const EdgeInsets.symmetric(vertical: 24.0)
                      :
                  const EdgeInsets.only(top: 24.0,left: 10.0,bottom: 24.0),
                  width: 72.0,
                  child: new Icon(icon, color: themeData.primaryColor)
              ),
              new Expanded(child: new Column(children: children))
            ],
          ),
        ),
      ),
    );
  }
}

class DetailItem extends StatelessWidget {
  DetailItem({ Key key, this.icon, this.lines, this.tooltip, this.onPressed })
      : super(key: key);

  final IconData icon;
  final List<String> lines;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final List<Widget> columnChildren = lines.map((String line) => new Text(line)).toList();

    final List<Widget> rowChildren = <Widget>[
      new Expanded(
              child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: columnChildren
                    )
                )
    ];
    if (icon != null) {
      rowChildren.add(new SizedBox(
          width: 72.0,
          child: new IconButton(
              icon: new Icon(icon),
              color: themeData.primaryColor,
              onPressed: onPressed
          )
      ));
    }
    else
    {
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
              children: rowChildren
          )
      ),
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
  static final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController referalCode = new TextEditingController();
  final double _appBarHeight = 256.0;
  AppBarBehavior _appBarBehavior = AppBarBehavior.pinned;
  bool isEurocoinAlreadyRegistered;
  FirebaseUser currentUser;
  String userReferralCode;
  int userEurocoin;
  bool registerWithEurocoin = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUser();
    isEurocoinAlreadyRegistered = false;
    userEurocoin = 0;
  }

  @override
  Widget build(BuildContext context) {
    return
      (currentUser!=null)?
      (isEurocoinAlreadyRegistered!=true)?
      new Container(
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Image.asset("images/events.png", fit: BoxFit.fill),
            Container(
              child: RaisedButton(
                onPressed: (){
                  registerEuroCoinUser('');
                },
                  color: Colors.white,
                  child: Text("Register without Eurocoin")
              ),
            ),
            Container(
              child: RaisedButton(
                  onPressed: (){
                    setState(() {
                      registerWithEurocoin = true;
                    });
                  },
                  color: Colors.white,
                  child: Text("Register with Referal Code!")
              ),
            ),
            (registerWithEurocoin == true)?
              Column(
                  children: <Widget>[
                    Material(
                      child: TextField(
                          controller: referalCode,
                          decoration: InputDecoration(
                            labelText: "Referal Code",
                          )
                      ),
                    ),
                    RaisedButton(
                      onPressed: (){
                        registerEuroCoinUser(referalCode.text);
                      },
                      child: Text("Register!"),
                    )
                  ],
                )
                :Container()
          ],
        )
      )
    :
      new Theme(
      data: new ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.indigo,
        platform: Theme.of(context).platform,
      ),
      child: new Scaffold(
        key: _scaffoldKey,
        body: new CustomScrollView(
          slivers: <Widget>[
            new SliverAppBar(
              expandedHeight: _appBarHeight,
              pinned: _appBarBehavior == AppBarBehavior.pinned,
              floating: _appBarBehavior == AppBarBehavior.floating || _appBarBehavior == AppBarBehavior.snapping,
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
                          colors: <Color>[Color(0x60000000), Color(0x00000000)],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            new SliverList(
              delegate: new SliverChildListDelegate(<Widget>[
                DetailCategory(
                  icon: Icons.swap_horiz,
                  children: <Widget>[
                    DetailItem(
                      lines: <String>[
                        "You havee: ", "$userEurocoin"
                      ],
                    )
                  ],
                ),
                DetailCategory(
                  icon: Icons.exit_to_app,
                  children: <Widget>[
                    DetailItem(
                      lines: <String>[
                        "Refer and Earn" ,"50 Eurocoins"
                      ],
                    ),
                    DetailItem(
                      icon: Icons.share,
                      onPressed: ()
                      {
                        print("Hey");
                        launch("sms:?body=Use my referal code $userReferralCode to get 50 Eurocoins when you register. \nDownload Link: dsd5");
                      },
                      lines: <String>[
                        "Your Refer Code is: ", "$userReferralCode"
                      ],
                    )
                  ],
                ),
                DetailCategory(
                  icon: Icons.transfer_within_a_station,
                  children: <Widget>[
                    new MergeSemantics(
                    child: new Padding(
                    padding: EdgeInsets.only(left:0.0, top: 10.0,right: 10.0),
                      child: EurocoinTransfer(name: currentUser.displayName, email: currentUser.email, parent: this)
                      ),
                    )
                  ],
                )
              ]),
            ),
          ],
        ),
      ),
    ):
      new Container(
          alignment: Alignment.center,
          child: Stack(
            children: <Widget>[
              Image.asset("images/events.png", fit: BoxFit.fill),
              Container(
                child: RaisedButton(
                    onPressed: (){
                      Navigator.of(context).pushNamed("/ui/account/login");
                    },
                    color: Colors.white,
                    child: Text("Login First")
                ),
              )
            ],
          )
      );
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
    var bytes = utf8.encode("$email"+"$name");
    var encoded = sha1.convert(bytes);
    print(encoded);

    String apiUrl = "https://eurekoin.avskr.in/api/exists/$encoded";
    http.Response response = await http.get(apiUrl);
    var status = json.decode(response.body)['status'];
      if(status == '1')
        {
          setState(() {
            isEurocoinAlreadyRegistered = true;
          });
          getUserEurocoin();
        }
      else
        setState(() {
          isEurocoinAlreadyRegistered = false;
        });
  }

  Future registerEuroCoinUser(var referalCode) async {
    var email = currentUser.email;
    var name = currentUser.displayName;
    var bytes = utf8.encode("$email"+"$name");
    var encoded = sha1.convert(bytes);

    String apiUrl = "https://eurekoin.avskr.in/api/register/$encoded?name=$name&email=$email&referred_invite_code=$referalCode&image=${currentUser.photoUrl}";
    http.Response response = await http.get(apiUrl);
    var status = json.decode(response.body)['status'];
    if(status == '0')
      {
        setState(() {
          isEurocoinAlreadyRegistered = true;
        });
        getUserEurocoin();
      }
    else
      setState(() {
        isEurocoinAlreadyRegistered = false;
      });
  }

  Future getUserEurocoin() async {
    var email = currentUser.email;
    var name = currentUser.displayName;
    var bytes = utf8.encode("$email"+"$name");
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
    var bytes = utf8.encode("$email"+"$name");
    var encoded = sha1.convert(bytes);
    String apiUrl = "https://eurekoin.avskr.in/api/invite_code/$encoded";
    http.Response response = await http.get(apiUrl);
    print(response.body);
    var referralCode = json.decode(response.body)['invite_code'];
    setState(() {
      userReferralCode = referralCode;
    });
  }
}
