import 'package:flutter/material.dart';
import '../../model/sponsor.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../util/drawer.dart';

class Sponsors extends StatefulWidget {
  @override
  _SponsorsState createState() => _SponsorsState();
}

class _SponsorsState extends State<Sponsors> {
  List<SponsorItem> sponsorList = List();
  SponsorItem sponsorItem, b;
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseReference;
  Map<String, List<SponsorItem>> sponsorsByCategories;
  int indexOfWidget;

  @override
  void initState() {
    super.initState();

    databaseReference = database.reference().child("Sponsors");
    databaseReference.onChildAdded.listen(_onEntryAdded);
    indexOfWidget = 0;
  }

  @override
  Widget build(BuildContext context) {
    indexOfWidget=0;
    return Scaffold(
      appBar: AppBar(title: Text("Sponsors")),
      drawer: NavigationDrawer(currentDisplayedPage: 9),
      body: sponsorList.length > 0
          ? ListView.builder(
              cacheExtent: MediaQuery.of(context).size.height*5,
              itemCount: sponsorList.length,
              padding: EdgeInsets.all(8.0),
              itemBuilder: (context, index) {
                if (indexOfWidget < sponsorList.length - 1) {
                  if ((sponsorList[index].priority) > 1) {
                    int p = indexOfWidget;
                    indexOfWidget = indexOfWidget + 1;
                    // print("------$a----- $p------");
                    return majorSponsor(
                        sponsorList[p], sponsorList[indexOfWidget++]);
                  } else {
                    indexOfWidget = index + 1;
                    print("----Gangnum 2 $index");
                    return majorSponsor(sponsorList[index], b);
                  }
                } else if ((indexOfWidget == sponsorList.length - 1) &&
                    (sponsorList.length % 2 != 0))
                  return majorSponsor(sponsorList[indexOfWidget++], b);
              })
          : Container(

        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: Theme.of(context).brightness==Brightness.light?
                AssetImage("images/gifs/loaderlight.gif"):
                AssetImage("images/gifs/loaderdark.gif"),
                fit: BoxFit.fill)
        ),
      ),
    );
  }

  int i = 0;
  void _onEntryAdded(Event event) {
    setState(() {
      //sponsorsByCategories[event.snapshot.value["category"]].add(SponsorItem.fromSnapshot(event.snapshot));
      sponsorList.add(SponsorItem.fromSnapshot(event.snapshot));
      sponsorList.sort((SponsorItem a, SponsorItem b) {
        return (a.priority).compareTo(b.priority);
      });
    });
  }

  Widget majorSponsor(SponsorItem indexOfWidget, SponsorItem c) {
    if (c == b)
      return Column(children: <Widget>[
        prioritySponsor(indexOfWidget),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Divider(
            color: Colors.black,
            height: 5.0,
          ),
        )
      ]);
    else {
      return Column(children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly ,
          children: <Widget>[
          Flexible(child:prioritySponsor(indexOfWidget)),
         // Expanded(child:SizedBox()),
        Padding(
          padding: EdgeInsets.all(5.0),
          child: prioritySponsor(c),
        )
      ])]);
    }
  }

  prioritySponsor(SponsorItem s) {
    int p = s.priority;
    switch (p) {
      case 0:
        {
          return Container(
            height: MediaQuery.of(context).size.height / 2.5,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: s.description==""?EdgeInsets.all(0.0):EdgeInsets.all(12.0),
                  child: Center(
                      child:s.description!=""? Text(
                    s.description,
                    style: TextStyle(fontSize: 20.0),
                  ):Container()),
                ),
                Expanded(
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(new Radius.circular(15.0)),
                      child: CachedNetworkImage(
                        placeholder:  (context, url) => Image.asset("images/imageplaceholder.png"),
                        imageUrl: s.imageUrl,
                        fit: BoxFit.fill,
                      )),
                ),
              ],
            ),
          );
        }
      case 1:
        {
          return Container(
            height: MediaQuery.of(context).size.height / 4,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: s.description==""?EdgeInsets.all(0.0):EdgeInsets.all(12.0),
                  child: Center(
                      child: s.description!=""?Text(
                    s.description,
                    style: TextStyle(fontSize: 20.0),
                  ):Container()),
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(new Radius.circular(15.0)),
                    child: CachedNetworkImage(
                      placeholder:  (context, url) => Image.asset("images/imageplaceholder.png"),
                      imageUrl: s.imageUrl,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

      case 2:
        {
          return Container(
            padding: EdgeInsets.all(8.0),
            width: MediaQuery.of(context).size.width / 2.5,
            height: MediaQuery.of(context).size.height / 3,
            child: ClipRRect(
                borderRadius: BorderRadius.all(new Radius.circular(15.0)),
                child: CachedNetworkImage(
                  placeholder: (context, url) =>  Image.asset("images/imageplaceholder.png"),
                  imageUrl: s.imageUrl,
                  fit: BoxFit.fill,
                )),
          );
        }
      case 3:
        {
          return Container(
            padding: EdgeInsets.all(8.0),
            width: MediaQuery.of(context).size.width / 4,
            height: MediaQuery.of(context).size.height / 6,
            child: ClipRRect(
                borderRadius: BorderRadius.all(new Radius.circular(15.0)),
                child: CachedNetworkImage(
                  placeholder: (context, url) => Image.asset("images/imageplaceholder.png"),
                  imageUrl: s.imageUrl,
                  fit: BoxFit.fill,
                )),
          );
        }
    }
  }
}
