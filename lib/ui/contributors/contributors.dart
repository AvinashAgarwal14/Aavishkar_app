import '../../util/drawer.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Contributors extends StatefulWidget {
  @override
  _ContributorsState createState() => _ContributorsState();
}

var kFontFam = 'CustomFonts';

IconData github_circled =  IconData(0xe800, fontFamily: kFontFam);
IconData linkedin =  IconData(0xe801, fontFamily: kFontFam);
IconData facebook =  IconData(0xf052, fontFamily: kFontFam);
IconData google = IconData(0xf1a0, fontFamily: kFontFam);
IconData facebook_1 = IconData(0xf300, fontFamily: kFontFam);

//TODO Data Entry
Map contributors={
  "Name":["Avinash Agarwal", "Akshat Jain", "Shreyashee Sinha", "Aritra Karmakar","Mayank Tayal","Agnivarna Trivedi", ],
  "ProfilesFacebook":["https://www.facebook.com/avinash.agarwal.1614",
  "https://www.facebook.com/akshat.jain.336333",
  "https://www.facebook.com/sinha23",
  "https://www.facebook.com/aritra.karmakar.3",
  "https://www.facebook.com/mayank.tayal.7",
  "https://www.facebook.com/agnivarna.trivedi.98"
  ],
"ProfilesGithub":["https://github.com/AvinashAgarwal14",
"https://github.com/Akshat7321",
"https://github.com/ShreyasheeS",
"https://github.com/gravitydestroyer",
"https://github.com/MTnes",
"https://github.com/AgnivarnaTrivedi",
],
"ProfilesLinkedin":["https://www.linkedin.com/in/agarwalavinash14/",
"https://www.linkedin.com/in/akshat-jain-007365a2/",
"https://www.linkedin.com/in/shreyashee-sinha-37454b139/",
"https://www.facebook.com/aritra.karmakar.3",
"https://www.linkedin.com/in/mayank-tayal-9372a216b",
"https://www.linkedin.com/in/agnivarna-trivedi-6172b2154/"],
  "Contact":["+91 8981866219","+91 8004937056","+91 7063141513","+91 8759579260","+91 8447395105","+91 9123767237"],
"Image":["images/Contributors/avinash.jpeg","images/Contributors/akshat.jpg","images/Contributors/shreyasheedidi.jpg","images/Contributors/aritra bhaiya.jpg","images/Contributors/mayank.jpg","images/Contributors/agnivarna.jpg"],
};


class _ContributorsState extends State<Contributors> {
  Widget separator;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawer(currentDisplayedPage: 11),
      appBar: AppBar(title: Text("Contributors"),),
//      backgroundColor: Theme.of(context).brightness==Brightness.light?Colors.white70:Colors.black ,
        body: ListView.builder(

            itemCount: 6,
            itemBuilder: (context, index) {

              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Stack(
                   // fit: StackFit.expand,
                    children: <Widget>[
                      Container(
                        //color: Colors.black,
                          height: MediaQuery.of(context).size.height/3,
                          width:MediaQuery.of(context).size.width,
                          child: Image.asset(
                            contributors["Image"][index], fit: BoxFit.contain,
                          )),
              Container(
              decoration:BoxDecoration(color: Colors.white,
              shape: BoxShape.rectangle,
              gradient: new LinearGradient(
              colors: <Color>[
              const Color.fromRGBO(255,255,255, 0.2),
              const Color.fromRGBO(0,0,0, 0.7),
              ],
              stops: [0.2, 1.0],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(0.0, 1.0),
              )),
              height: MediaQuery.of(context).size.height/3,
              width:MediaQuery.of(context).size.width,
              ),
              Container(
                          height:80.0,
                         margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/3- 80.0),
                        color: Color.fromRGBO(0, 0, 0, 0.5),

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                             Center(
                              child:   Text(contributors["Name"][index],
                                    style: TextStyle(
                                        fontSize: 18.0, color: Colors.white),),
                             ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Flexible(
                                  child: IconButton(icon: Icon(facebook,),
                                    disabledColor: Colors.black,
                                    color: Colors.blueAccent,
                                    onPressed: () {
                                      _launchURL(contributors["ProfilesFacebook"][index]);
                                    },),
                                ),
                                IconButton(
                                  icon: Icon(linkedin, color: Colors.blue,),
                                  onPressed: () {
                                    _launchURL(contributors["ProfilesLinkedin"][index]);
                                  },),
                                IconButton(icon: Icon(github_circled,
                                  color: Color.fromRGBO(201, 81, 12, 1.0),),
                                  onPressed: () {
                                    _launchURL(contributors["ProfilesGithub"][index]);
                                  },),
                                IconButton(icon: Icon(Icons.call),
                                  color: Colors.green,
                                  onPressed: () {
                                    launch(
                                        "tel:" + contributors["Contact"][index]);
                                  },),
                              ],
                            ),
                          ],
                        ),
              )

                    ]),
              );
            }
        )
    );
  }
  _launchURL(String str) async {

    if (await canLaunch(str)) {
      await launch(str);
    } else {
      throw 'Could not launch $str';
    }
  }
}
