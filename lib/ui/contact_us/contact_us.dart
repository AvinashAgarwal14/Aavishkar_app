import '../../util/drawer.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


var kFontFam = 'CustomFonts';
var whatsappFontFam = 'WhatsappIcon';

IconData whatsapp =  IconData(0xf232, fontFamily:whatsappFontFam );

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
  "User" : ["Anand Jhunjhunwala",
  "Aniq Ur Rahman",
  "Arnav Kumar",
  "Deeksha Chandwani",
  "Devansh Goenka",
    "Divyadutta Behura",
    "Nidhi Yadav",
    "Punit Drolia",
"Sahil Jaiswal",
    "Utkarsh Jaiswal",
    "Saurabh Kumar Gupta",
  "Srinjoy Banerjee",
  "Sudipto Mukherjee",
    "Suvit Kumar",
  "Syed Wasiqul Haque",
  "Shaista Ambreen",
  ],

  "Designation":["kuch bhi",
  "kuch bhi",
  "kuch bhi",
  "kuch bhi",
  "kuch bhi",
  "kuch bhi",
  "kuch bhi",
  "kuch bhi",
  "kuch bhi",
  "kuch bhi",
  "kuch bhi",
  "kuch bhi",
  "kuch bhi",
  "kuch bhi",
  "kuch bhi",
  "kuch bhi",
  ],

  "ProfilesFacebook": ["https://www.facebook.com/anand.jhunjhunwala.315",
  "https://www.linkedin.com/in/aniq55/",
  "https://www.facebook.com/arnav.grv",
  "https://flutter.io/cookbook/lists/grid-lists/",
  "https://www.facebook.com/devansh97",
  "https://flutter.io/cookbook/lists/grid-lists/",
  "https://flutter.io/cookbook/lists/grid-lists/",
  "https://flutter.io/cookbook/lists/grid-lists/",
  "https://flutter.io/cookbook/lists/grid-lists/",
    "https://flutter.io/cookbook/lists/grid-lists/",
"https://www.facebook.com/saurabhadroit",
  "https://flutter.io/cookbook/lists/grid-lists/",
  "https://flutter.io/cookbook/lists/grid-lists/",
  "https://flutter.io/cookbook/lists/grid-lists/",
  "https://flutter.io/cookbook/lists/grid-lists/",
  "https://flutter.io/cookbook/lists/grid-lists/",

  ],

  "ProfilesLinkedin": ["https://www.linkedin.com/in/anand13696/",
  "https://www.linkedin.com/in/aniq55/",
  "https://www.linkedin.com/in/arnav-amb",
  "https://flutter.io/cookbook/lists/grid-lists/",
  "https://www.linkedin.com/in/devansh-goenka",
  "https://flutter.io/cookbook/lists/grid-lists/",
  "https://flutter.io/cookbook/lists/grid-lists/",
    "https://www.linkedin.com/in/punit-drolia-7096b2121/",
  "https://www.linkedin.com/in/sahil-jaiswal-b3b55413a/",
    "https://www.linkedin.com/in/utkj97/",
    "https://www.linkedin.com/in/saurabh-kumar-gupta-a42a81163",
  "https://flutter.io/cookbook/lists/grid-lists/",
  "https://flutter.io/cookbook/lists/grid-lists/",
  "https://flutter.io/cookbook/lists/grid-lists/",
  "https://flutter.io/cookbook/lists/grid-lists/",
  "https://flutter.io/cookbook/lists/grid-lists/",
  ],

  "ProfilesWhatsapp":["+91 9903322358",
  "+91 9038663352",
  "+91 7903865654",
  "+91 9083583214",
  "+91 9674825450",
    "+91 9439091552",
    "+91 7679883025",
  "+91 8967945051",
    "+91 9836286146",
    "+91 8902010515",
"+91 8145386516",
"+91 8334073271",
    "+91 8158892279",
"+91 9163472507",
    "+91 9674598150",
    "+91 8789015691",
  ],

  "Contact":["+91 9903322358",
  "+91 7044171717",
  "+91 7903865654",
  "+91 9083583214",
  "+91 9674825450",
    "+91 9439091552",
    "+91 7679883025",
    "+91 8967945051",
    "+91 9836286146",
    "+91 8902010515",
  "+91 8145386516",
  "+91 8334073271",
 "+91 8158892279",
"+91 9163472507",
  "+91 9674598150",
    "+91 9593626313",
  ],

  "Image":[
  "images/Contact Us/Anand.jpg",
  "images/Contact Us/Aniq.jpg",
  "images/Contact Us/Arnav.jpeg",
  "images/Contact Us/Deeksha Chandwani.jpg",
  "images/Contact Us/Devansh Goenka.jpg",
  "images/Contact Us/Divyadutta Behura.jpg",
  "images/Contact Us/Nidhi Yadav.jpg",
  "images/Contact Us/Punit Drolia.jpg",
  "images/Contact Us/Sahil Jaiswal.jpeg",
  "images/Contact Us/Saurabh Kumar Gupta.jpg",
  "images/Contact Us/Srinjoy.JPG",
  "images/Contact Us/Sudipto Mukherjee.JPG",
  "images/Contact Us/Suvit Kumar.jpg",
  "images/Contact Us/Utkarsh Jaiswal.jpg",
  "images/Contact Us/Wasiq.jpg",
  "images/events.png"],
};
class _ContactUsState extends State<ContactUs> {
  @override
  Widget build(BuildContext context) {

    return Scaffold (
        backgroundColor: Theme.of(context).brightness==Brightness.light?Colors.white70:Colors.black38,
    drawer: NavigationDrawer(currentDisplayedPage: 10),
    appBar: AppBar(title: Text("Contact Us"),),
    body: OrientationBuilder(
      builder:(context, orientation) {
        return GridView.count(crossAxisCount: orientation==Orientation.portrait ? 2 : 3,
cacheExtent: MediaQuery.of(context).size.height,
            padding: EdgeInsets.all(8.0), children: List.generate(16, (index) {
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
                                Text("kuch bhi",
                                    //contactCard["Designation"][index],
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
                                IconButton(
                                  icon: Icon(whatsapp, color: Colors.lightGreen,),
                                  onPressed: () {
                                    _launchWhatsapp(contactCard["ProfilesWhatsapp"][index]);
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

  _launchWhatsapp (String str) async{
    var whatsappUrl ="whatsapp://send?phone=$str";
    await canLaunch(whatsappUrl)? launch(whatsappUrl):print("open whatsapp app link or do a snackbar with notification that there is no whatsapp installed");
  }

}
