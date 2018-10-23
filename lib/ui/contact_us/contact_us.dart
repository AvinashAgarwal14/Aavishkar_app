import '../../util/drawer.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

var kFontFam = 'CustomFonts';
var whatsappFontFam = 'WhatsappIcon';

IconData whatsapp = IconData(0xf232, fontFamily: whatsappFontFam);

IconData github_circled = IconData(0xe800, fontFamily: kFontFam);
IconData linkedin = IconData(0xe801, fontFamily: kFontFam);
IconData facebook = IconData(0xf052, fontFamily: kFontFam);
IconData google = IconData(0xf1a0, fontFamily: kFontFam);
IconData facebook_1 = IconData(0xf300, fontFamily: kFontFam);

class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

Map contactCard = {
  "User": [
    "Devansh Goenka",
    "Saurabh Kumar Gupta",
    "Punit Drolia",
    "Shreyashee Sinha",
    "Syed Wasiqul Haque",
    "Sudipto Mukherjee",
    "Anand Jhunjhunwala",
    "Sahil Jaiswal",
    "Nidhi Yadav",
    "Divyadutta Behura",
    "Suvit Kumar",
    "Aniq Ur Rahman",
    "Shaista Ambreen",
    "Deeksha Chandwani",
    "Arnav Kumar",
    "Srinjoy Banerjee"
  ],
  "Designation": [
    "Executive Head",
    "Executive Head",
    "Executive Head",
    "Public Relations",
    "Publicity Head",
    "Sponsorship Head",
    "Sponsorship Head",
    "Travel and Logistics",
    "Travel and Logistics",
    "Events and Workshops",
    "Events and Workshops",
    "ScienceX",
    "ScienceX",
    "ScienceX",
    "Design",
    "Design"
  ],
  "ProfilesFacebook": [
    "https://www.facebook.com/devansh97",
    "https://www.facebook.com/saurabhadroit",
    "https://www.facebook.com/punit.drolia",
    "https://www.facebook.com/sinha23",
    "https://www.facebook.com/gadfreax",
    "https://www.facebook.com/msudipto9",
    "https://www.facebook.com/anand.jhunjhunwala.315",
    "https://www.facebook.com/sahil.jaiswal.7399",
    "https://www.facebook.com/nidhi.yadav.18294053",
    "https://www.facebook.com/divyadutta.behura.9",
    "https://www.facebook.com/suvitkumar6?ref=bookmarks",
    "https://www.linkedin.com/in/aniq55/",
    "https://www.facebook.com/profile.php?id=100010157537791",
    "https://www.facebook.com/deeksha.chandwani.9",
    "https://www.facebook.com/arnav.grv",
    "https://www.facebook.com/srinjoy.banerjee2"
  ],
  "ProfilesLinkedin": [
    "https://www.linkedin.com/in/devansh-goenka",
    "https://www.linkedin.com/in/saurabh-kumar-gupta-a42a81163",
    "https://www.linkedin.com/in/punit-drolia-7096b2121/",
    "https://www.linkedin.com/in/shreyashee-sinha-37454b139/",
    "https://www.linkedin.com/in/wasiqul-haque-03a52a165/",
    "https://www.linkedin.com/in/sudipto-mukherjee-04076b124/",
    "https://www.linkedin.com/in/anand13696/",
    "https://www.linkedin.com/in/sahil-jaiswal-b3b55413a/",
    "https://www.linkedin.com/in/nidhi-kumari-yadav-091952140",
    "https://www.linkedin.com/in/divyadutta-behura-236220173",
    "https://www.linkedin.com/in/suvit-kumar-a8b194128",
    "https://www.linkedin.com/in/aniq55/",
    "https://www.linkedin.com/in/shaista-ambreen-157b48137",
    "https://www.linkedin.com/in/deeksha-chandwani-296574104/",
    "https://www.linkedin.com/in/arnav-amb",
    "https://www.linkedin.com/in/srinjoy-banerjee-b18a83115/"
  ],
  "ProfilesWhatsapp": [
    "+91 9674825450",
    "+91 8145386516",
    "+91 8967945051",
    "+91 7063141513",
    "+91 9674598150",
    "+91 8158892279",
    "+91 9903322358",
    "+91 9836286146",
    "+91 7679883025",
    "+91 9439091552",
    "+91 9163472507",
    "+91 9038663352",
    "+91 8789015691",
    "+91 9593626313",
    "+91 9083583214",
    "+91 7903865654",
    "+91 8334073271"
  ],
  "Contact": [
    "+91 9674825450",
    "+91 8145386516",
    "+91 8967945051",
    "+91 7063141513",
    "+91 9674598150",
    "+91 8158892279",
    "+91 9903322358",
    "+91 9836286146",
    "+91 7679883025",
    "+91 9439091552",
    "+91 9163472507",
    "+91 7044171717",
    "+91 9083583214",
    "+91 7903865654",
    "+91 8334073271"
  ],
  "Image": [
    "images/Contact Us/Devansh Goenka.jpg",
    "images/Contact Us/Saurabh Kumar Gupta.jpg",
    "images/Contact Us/Punit Drolia.jpeg",
    "images/Contributors/shreyasheedidi.jpg",
    "images/Contact Us/Wasiq.jpg",
    "images/Contact Us/Sudipto Mukherjee.JPG",
    "images/Contact Us/Anand.jpg",
    "images/Contact Us/Sahil Jaiswal.jpeg",
    "images/Contact Us/Nidhi Yadav.jpg",
    "images/Contact Us/Divyadutta Behura.jpg",
    "images/Contact Us/Suvit Kumar.jpg",
    "images/Contact Us/Aniq.jpg",
    "images/Contact Us/Shaista.jpeg",
    "images/Contact Us/Deeksha Chandwani.jpg",
    "images/Contact Us/Arnav.jpeg",
    "images/Contact Us/Srinjoy.JPG"
  ],
};

class _ContactUsState extends State<ContactUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
//        backgroundColor: Theme.of(context).brightness==Brightness.light?Colors.white70:Colors.black38,
        drawer: NavigationDrawer(currentDisplayedPage: 10),
        appBar: AppBar(
          title: Text("Contact Us"),
        ),
        body: OrientationBuilder(builder: (context, orientation) {
          return GridView.count(
              crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
              cacheExtent: MediaQuery.of(context).size.height,
              padding: EdgeInsets.all(8.0),
              children: List.generate(16, (index) {
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        Container(
                        child: Image.asset(contactCard["Image"][index],
                            fit: BoxFit.cover)),
                    Container(
                      height: 100.0,
                      margin: EdgeInsets.only(top: 98.0),
                      color: Color.fromRGBO(0, 0, 0, 0.65),
                      child:
                          Column(
                            //mainAxisSize: MainAxisSize.min,
                           // crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  contactCard["User"][index],
                                  style: TextStyle(
                                      fontSize: 13.0, color: Colors.white),
                                ),
                                Text(contactCard["Designation"][index],
                                    style: TextStyle(
                                        fontSize: 10.0, color: Colors.white70)),
                          Row(
//                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Flexible(
                                child: IconButton(
                                  //padding: EdgeInsets.all(0.0),
                                  iconSize: 15.0,
                                  icon: Icon(
                                    facebook,
                                    color: Colors.grey
                                  ),
                                  disabledColor: Colors.black,
                                  color: Colors.blueAccent,
                                  onPressed: () {
                                    _launchURL(
                                        contactCard["ProfilesFacebook"][index]);
                                  },
                                ),
                              ),
                              IconButton(
                                //padding: EdgeInsets.all(0.0),
                                iconSize: 15.0,
                                icon: Icon(
                                  linkedin,
                                  color: Colors.grey
                                ),
                                onPressed: () {
                                  _launchURL(
                                      contactCard["ProfilesLinkedin"][index]);
                                },
                              ),
                              IconButton(
                                //padding: EdgeInsets.all(0.0),
                                iconSize: 15.0,
                                icon: Icon(whatsapp, color: Colors.grey),
                                onPressed: () {
                                  _launchWhatsapp(
                                      contactCard["ProfilesWhatsapp"][index]);
                                },
                              ),
                              IconButton(
                               // padding: EdgeInsets.all(0.0),
                                iconSize: 15.0,
                                icon: Icon(Icons.call, color: Colors.grey),
                                onPressed: () {
                                  launch(
                                      "tel:" + contactCard["Contact"][index]);
                                },
                              ),
                            ],
                          ),
                              ],
                          ),
                    )
                  ]),
                );
              }));
        }));
  }

  _launchURL(String str) async {
    if (await canLaunch(str)) {
      await launch(str);
    } else {
      throw 'Could not launch $str';
    }
  }

  _launchWhatsapp(String str) async {
    var whatsappUrl = "whatsapp://send?phone=$str";
    await canLaunch(whatsappUrl)
        ? launch(whatsappUrl)
        : print(
            "open whatsapp app link or do a snackbar with notification that there is no whatsapp installed");
  }
}
