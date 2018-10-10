import '../../util/drawer.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


var kFontFam = 'CustomFonts';

IconData github_circled =  IconData(0xe800, fontFamily: kFontFam);
IconData linkedin =  IconData(0xe801, fontFamily: kFontFam);
IconData facebook =  IconData(0xf052, fontFamily: kFontFam);
IconData google = IconData(0xf1a0, fontFamily: kFontFam);
IconData facebook_1 = IconData(0xf300, fontFamily: kFontFam);


class ContactUs extends StatefulWidget {

  @override
  _ContactUsState createState() => _ContactUsState();
}
Map contactCard={
  "User" : ["User 1", "User 2","User3 ","User 4","User 5"],

  "Designation":["kuch bhi","kuch bhi","kuch bhi","kuch bhi","kuch bhi",],

  "ProfilesFacebook": ["https://flutter.io/cookbook/lists/grid-lists/",
  "https://flutter.io/cookbook/lists/grid-lists/",
  "https://flutter.io/cookbook/lists/grid-lists/",
  "https://flutter.io/cookbook/lists/grid-lists/",
  "https://flutter.io/cookbook/lists/grid-lists/"],

  "ProfilesLinkedin": ["https://flutter.io/cookbook/lists/grid-lists/",
  "https://flutter.io/cookbook/lists/grid-lists/",
  "https://flutter.io/cookbook/lists/grid-lists/",
  "https://flutter.io/cookbook/lists/grid-lists/",
  "https://flutter.io/cookbook/lists/grid-lists/"],

  "Contact":["+91 8004937056","+91 8004937056","+91 8004937056","+91 8004937056","+91 8004937056"],

  "Image":["images/events.png","images/events.png","images/events.png","images/events.png","images/events.png",],
};
class _ContactUsState extends State<ContactUs> {
  @override
  Widget build(BuildContext context) {

    return Scaffold (backgroundColor:Colors.white70,
    drawer: NavigationDrawer(currentDisplayedPage: 10),
    appBar: AppBar(title: Text("Contact Us"),),
    body: OrientationBuilder(
      builder:(context, orientation) {
        return GridView.count(crossAxisCount: orientation==Orientation.portrait ? 2 : 3,

            padding: EdgeInsets.all(8.0), children: List.generate(5, (index) {
              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Container(
                          child: Image.asset(
                            contactCard["Image"][index], fit: BoxFit.fill,)
                      ),
                      Container(
                        height: 100.0,
                        margin: EdgeInsets.only(top: 90.0),
                        color: Color.fromRGBO(0, 0, 0, 0.65),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[

                            Center(
                              child: Column(children: <Widget>[
                                Text(contactCard["User"][index],
                                  style: TextStyle(
                                      fontSize: 18.0, color: Colors.white),),
                                Text(contactCard["Designation"][index],
                                    style: TextStyle(
                                        fontSize: 12.0, color: Colors.white70)),
                              ], mainAxisAlignment: MainAxisAlignment.center,
                              ),
                            ),


                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Flexible(
                                  child: IconButton(icon: Icon(facebook,),
                                    disabledColor: Colors.black,
                                    color: Colors.blueAccent,
                                    onPressed: () {
                                      _launchURL(contactCard["ProfilesFacebook"][index]);
                                    },),
                                ),
                                IconButton(
                                  icon: Icon(linkedin, color: Colors.blue,),
                                  onPressed: () {
                                    _launchURL(contactCard["ProfilesLinkedin"][index]);
                                  },),
                                IconButton(icon: Icon(Icons.call),
                                  color: Colors.green,
                                  onPressed: () {
                                    launch(
                                        "tel:" + contactCard["Contact"][index]);
                                  },),
                              ],
                            ),
                          ],
                        ),
                      )
                    ]),
              );
            })
        );
      }
    ) );
  }
  _launchURL(String str) async {

    if (await canLaunch(str)) {
      await launch(str);
    } else {
      throw 'Could not launch $str';
    }
  }

}
