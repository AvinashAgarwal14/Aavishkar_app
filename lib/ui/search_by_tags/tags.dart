import 'dart:async';
import 'package:flutter/material.dart';
import '../../util/drawer.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../model/event.dart';
import '../activities/events/event_details.dart';

Map<String, List<EventItem>> eventsByTags;

class SearchByTags extends StatefulWidget {
  @override
  _SearchByTagsState createState() => _SearchByTagsState();
}

class _SearchByTagsState extends State<SearchByTags> {

  var _selectedTag = 'All';

  List<String> _tags = <String>[
    'Action',
    'Mystery',
    'Treasure Hunt',
    'Code',
    'Sports'
  ];

  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseReference;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    eventsByTags = {
      'All': new List(),
      'Action': new List(),
      'Mystery': new List(),
      'Treasure Hunt': new List(),
      'Code': new List(),
      'Sports': new List()
    };

    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);
    databaseReference = database.reference().child("Events");
    databaseReference.onChildAdded.listen(_onEntryAdded);
    databaseReference.onChildChanged.listen(_onEntryChanged);
  }

  @override
  Widget build(BuildContext context) {

    final List<Widget> choiceChips = _tags.map<Widget>((String name) {
      return ChoiceChip(
                key: new ValueKey<String>(name),
                backgroundColor: Color(0xFF353662),
                label: new Text(name, style: TextStyle(color: Colors.white)),
                selected: _selectedTag == name,
                selectedColor: Color.fromRGBO(54, 59, 94, 0.5),
                onSelected: (bool value) {
                  setState(() {
                    _selectedTag = value ? name : _selectedTag;
                  });
                },
        );
    }).toList();

    final List<Widget> cardChildren = <Widget>[
      new Container(
        padding: const EdgeInsets.only(top: 16.0, bottom: 4.0),
        alignment: Alignment.center,
        child: new Text("Tags"),
      ),
    ];
      cardChildren.add(new Wrap(
          children: choiceChips.map((Widget chip) {
            return new Padding(
              padding: const EdgeInsets.all(2.0),
              child: chip,
            );
          }).toList()));

    return Scaffold(
      appBar: AppBar(
        title: Text("Tags"),
      ),
      drawer: NavigationDrawer(currentDisplayedPage: 3),
      body: Column(
        children: <Widget>[
            Container(
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                children: cardChildren,
              )
            ),
            Divider(
              color: Colors.grey,
            ),
            Container(
              child: Text("Results"),
            ),
            Divider(
              color: Colors.grey,
            ),
            Container(
              child: Expanded(
                child: ListView.builder(
                    itemCount: eventsByTags[_selectedTag].length    ,
                    itemBuilder: (context, position)
                    {
                      return Container(
                        child: GestureDetector(
                          onTap:() {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => new EventDetails(item: eventsByTags[_selectedTag][position])),
                            );
                          },
                          child: SearchByTagsCards(eventCard:eventsByTags[_selectedTag][position])
                        )
                      );
                    }
                ),
                )
            )
        ],
      ),
    );
  }

  void _onEntryAdded(Event event) {
    setState(() {
        //print(event.snapshot.value);
        eventsByTags["All"].add(EventItem.fromSnapshot(event.snapshot));
        eventsByTags[event.snapshot.value["tag"]].add(EventItem.fromSnapshot(event.snapshot));
        //print(eventsByTags);
    });
  }


  void _onEntryChanged(Event event) {
    var oldEntry = eventsByTags[event.snapshot.value["tag"]].singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    setState(() {
      eventsByTags[event.snapshot.value["tag"]][eventsByTags[event.snapshot.value["tag"]].indexOf(oldEntry)] = EventItem.fromSnapshot(event.snapshot);
    });
  }

}

class SearchByTagsCards extends StatefulWidget {

  SearchByTagsCards({ Key key, this.eventCard}) : super(key: key);

  final EventItem eventCard;

  @override
  _SearchByTagsCardsState createState() => _SearchByTagsCardsState();
}

class _SearchByTagsCardsState extends State<SearchByTagsCards> {

  PaletteGenerator paletteGenerator;
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseReferenceForUpdate;
  Color cardColor;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.eventCard.color!='invalid')
    {
      if(widget.eventCard.color=='null')
        cardColor = new Color(0xffffff);
      else
      {
        String valueString = widget.eventCard.color.split('(0x')[1].split(')')[0]; // kind of hacky..
        int value = int.parse(valueString, radix: 16);
        cardColor = new Color(value);
      }
    }
    else
    {
      databaseReferenceForUpdate = database.reference().child("Events");
      updatePaletteGenerator();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget cardItem = new Card(
        color: (paletteGenerator!=null)?paletteGenerator.lightVibrantColor?.color:cardColor,
        child: new Column(
          children: <Widget>[
            Hero(
                tag: widget.eventCard.imageUrl,
                child: CachedNetworkImage(
                    placeholder: Image.asset("images/imageplaceholder.png"),
                    imageUrl: widget.eventCard.imageUrl,
                    fit: BoxFit.cover
                )),
            ListTile(
              title: new Text(widget.eventCard.title),
              subtitle: new Text(widget.eventCard.date),
            )
          ],
        ));

    return cardItem;
  }

  Future<void> updatePaletteGenerator() async {
    paletteGenerator = await PaletteGenerator.fromImageProvider(
      NetworkImage(widget.eventCard.imageUrl),
      maximumColorCount: 5,
    );
    setState(() {
    });
    updateNewsFeedPostColor(paletteGenerator.lightVibrantColor?.color);
  }

  void updateNewsFeedPostColor(Color color)
  {
    databaseReferenceForUpdate.child(widget.eventCard.key).update({
      'color': color.toString()
    }) ;
  }
}


