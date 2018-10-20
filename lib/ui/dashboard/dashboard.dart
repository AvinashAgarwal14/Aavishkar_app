import 'dart:async';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import '../../util/drawer.dart';
import './dashboard_layout.dart';
import './newsfeed.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:barcode_scan/barcode_scan.dart';
import '../search_by_tags/tags.dart';
import '../eurekoin/eurekoin.dart';
import '../account/login.dart';

class Dashboard extends StatefulWidget {

  @override
  _DashboardState createState() => _DashboardState();
}
class _DashboardState extends State<Dashboard> {

  bool darkThemeEnabled=false;
  var _currentState = 0;
  FirebaseUser currentUser;
  int isEurekoinAlreadyRegistered;
  String barcodeString;

  List Views = [
    DashBoardLayout(),
    Newsfeed()
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Aavishkar 2.0"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchByTags()),
                );
              }
            ),
            (currentUser!=null && isEurekoinAlreadyRegistered!=null)?
              IconButton(
              icon: Image(image: AssetImage("images/QRIcon.png"), color: Colors.white),
              onPressed: ()
                  {
                    if(isEurekoinAlreadyRegistered==1)
                      {
                        scanQR();
                      }
                    else if (isEurekoinAlreadyRegistered==0)
                      {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EurekoinHomePage()),
                        ).then((onReturn){
                          getUser();
                        });
                      }
                  }
              )
                :
                Container(),
            IconButton(
                icon: Icon(Icons.account_box),
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LogInPage()),
                  ).then((onReturn){
                    getUser();
                  });
                }
            )
          ],
        ),
      drawer: NavigationDrawer(currentDisplayedPage: 0),
      body: Views[_currentState],
      bottomNavigationBar: Container(
//        color: Color.fromRGBO(255, 255, 255, 40.0),
        child: BottomNavigationBar(
          currentIndex: _currentState,
          onTap:(int index){
            setState(() {
              _currentState = index;
            });
          },
          fixedColor: Theme.of(context).primaryColor,
          items:[
            BottomNavigationBarItem(
                icon: Icon(Icons.dashboard,),
                title: Text("Dashboard",),
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.rss_feed),
                title: Text("Newsfeed",
                )
            )
          ],
        ),
      )
    );
  }

  Future getUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    print(user);
    setState(() {
      currentUser = user;
    });
    if(currentUser!=null)
      isEurekoinUserRegistered();
  }

  Future isEurekoinUserRegistered() async {
    var email = currentUser.email;
    var name = currentUser.displayName;
    var bytes = utf8.encode("$email"+"$name");
    var encoded = sha1.convert(bytes);

    String apiUrl = "https://eurekoin.avskr.in/api/exists/$encoded";
    http.Response response = await http.get(apiUrl);
    var status = json.decode(response.body)['status'];
    if(status == '1')
    {
      setState(() {
        isEurekoinAlreadyRegistered = 1;
      });
    }
    else
      setState(() {
        isEurekoinAlreadyRegistered = 0;
      });
  }

  Future scanQR() async {
    try {
      String hiddenString = await BarcodeScanner.scan();
      setState(() {
        barcodeString = hiddenString;
        print(barcodeString);
        Future<int> result = couponEurekoin(barcodeString);
        result.then((value) {
          print(value);
          if (value == 0)
          {
            setState(() {
              barcodeString = "Successful!";
            });
            showDialogBox(barcodeString);
          }
          else if (value == 2)
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
        }
        );
      }
    } on FormatException{
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
    var bytes = utf8.encode("$email"+"$name");
    var encoded = sha1.convert(bytes);
    String apiUrl = "https://eurekoin.avskr.in/api/coupon/$encoded/?code=$coupon";
    print(apiUrl);
    http.Response response = await http.get(apiUrl);
    print(response.body);
    var status = json.decode(response.body)['status'];
    return int.parse(status);
  }

}

