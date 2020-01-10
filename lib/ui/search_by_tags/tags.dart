import 'dart:async';
import 'package:flutter/material.dart';
import '../../util/drawer.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../model/event.dart';
import '../../util/event_details.dart';

Map<String, List<EventItem>> eventsByTags;

class SearchByTags extends StatefulWidget {
  @override
  _SearchByTagsState createState() => _SearchByTagsState();
}

class _SearchByTagsState extends State<SearchByTags> {
  var _selectedTag = 'All';

  List<String> _tags = <String>[
    'Logic',
    'Strategy',
    'Mystery',
    'Innovation',
    'Treasure Hunt',
    'Coding',
    'Sports',
    'Robotics',
    'Workshops'
  ];

  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseReference;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    eventsByTags = {
      'All': new List(),
      'Logic': new List(),
      'Strategy': new List(),
      'Mystery': new List(),
      'Innovation': new List(),
      'Treasure Hunt': new List(),
      'Coding': new List(),
      'Sports': new List(),
      'Robotics': new List(),
      'Workshops': new List()
    };

    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(15000000);
    databaseReference = database.reference().child("Events");
    databaseReference.onChildAdded.listen(_onEntryAdded);
    databaseReference.onChildChanged.listen(_onEntryChanged);
  }

  Color _nameToColor(String name) {
    assert(name.length > 1);
    final int hash = name.hashCode & 0xffff;
    final double hue = (360.0 * hash / (1 << 5)) % 360.0;
    return HSVColor.fromAHSV(1.0, hue, 0.4, 0.90).toColor();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> choiceChips = _tags.map<Widget>((String name) {
      Color chipColor;
      chipColor = _nameToColor(name);
      return ChoiceChip(
        key: new ValueKey<String>(name),
        backgroundColor: chipColor,
        label: new Text(name, style: TextStyle(color: Colors.white)),
        selected: _selectedTag == name,
        selectedColor: chipColor.withOpacity(0.3),
        onSelected: (bool value) {
          setState(() {
            _selectedTag = value ? name : _selectedTag;
          });
        },
      );
    }).toList();

    final List<Widget> cardChildren = <Widget>[
      new Wrap(
        children: choiceChips.map((Widget chip) {
      return new Padding(
        padding: const EdgeInsets.all(2.0),
        child: chip,
      );
    }).toList())];

    return Scaffold(
      appBar: AppBar(
        title: Text("Tags"),
      ),
      drawer: NavigationDrawer(currentDisplayedPage: 3),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10.0),
          ),
          Container(
              child: new Column(
            mainAxisSize: MainAxisSize.min,
            children: cardChildren,
          )),
          Divider(
            color: Theme.of(context).brightness==Brightness.light ?Colors.grey:Color(0xFF505194),
          ),
          Container(
              child: Expanded(
            child: ListView.builder(
                cacheExtent: MediaQuery.of(context).size.height*3,
                itemCount: eventsByTags[_selectedTag].length,
                itemBuilder: (context, position) {
                  return Container(
                      child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => new EventDetails(
                                      item: eventsByTags[_selectedTag]
                                          [position])),
                            );
                          },
                          child: SearchByTagsCards(
                              eventCard: eventsByTags[_selectedTag]
                                  [position])));
                }),
          ))
        ],
      ),
    );
  }

  void _onEntryAdded(Event event) {
    setState(() {
      //print(event.snapshot.value);
      eventsByTags["All"].add(EventItem.fromSnapshot(event.snapshot));
      eventsByTags[event.snapshot.value["tag"]]
          .add(EventItem.fromSnapshot(event.snapshot));
      //print(eventsByTags);
    });
  }

  void _onEntryChanged(Event event) {
    var oldEntry =
        eventsByTags[event.snapshot.value["tag"]].singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    setState(() {
      eventsByTags[event.snapshot.value["tag"]]
              [eventsByTags[event.snapshot.value["tag"]].indexOf(oldEntry)] =
          EventItem.fromSnapshot(event.snapshot);
    });
  }
}

class SearchByTagsCards extends StatefulWidget {
  SearchByTagsCards({Key key, this.eventCard}) : super(key: key);

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
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (widget.eventCard.color != 'invalid') {
      if (widget.eventCard.color == 'null')
        cardColor = Theme.of(context).brightness==Brightness.light ?Colors.white:Color(0xFF505194);
      else {
        String valueString = widget.eventCard.color
            .split('(0x')[1]
            .split(')')[0]; // kind of hacky..
        int value = int.parse(valueString, radix: 16);
        cardColor = new Color(value);
      }
    } else {
      databaseReferenceForUpdate = database.reference().child("Events");
      updatePaletteGenerator();
    }
  }


  @override
  Widget build(BuildContext context) {
    Widget cardItem = new Card(
        color: (paletteGenerator != null)
            ? paletteGenerator.lightVibrantColor?.color
            : cardColor,
        child: new Column(
          children: <Widget>[
            new ClipRRect(
                  borderRadius: new BorderRadius.only(
                      topLeft: new Radius.circular(5.0),
                      topRight: new Radius.circular(5.0)
                  ),
                  child:
                  Container(
                  height: 256.0,
                  child: SizedBox.expand(
                    child: Hero(
                        tag: widget.eventCard.imageUrl,
                        child: CachedNetworkImage(
                            placeholder:  (context, url) => Image.asset("images/imageplaceholder.png"),
                            imageUrl: widget.eventCard.imageUrl,
                            fit: BoxFit.cover,
                            height: 256.0)
                    ),
                  ),
                  )
            ),
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
    setState(() {});
    updateNewsFeedPostColor(paletteGenerator.lightVibrantColor?.color);
  }

  void updateNewsFeedPostColor(Color color) {
    databaseReferenceForUpdate
        .child(widget.eventCard.key)
        .update({'color': color.toString()});
  }
}
