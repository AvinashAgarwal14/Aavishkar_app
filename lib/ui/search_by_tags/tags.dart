import 'package:flutter/material.dart';
import '../../util/drawer.dart';
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
                backgroundColor: Colors.blueAccent,
                label: new Text(name),
                selected: _selectedTag == name,
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
      drawer: NavigationDrawer(),
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
//                        height: 350.0,
                        child: GestureDetector(
                          onTap:() {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => new EventDetails(item: eventsByTags[_selectedTag][position])),
                            );
                          },
                          child: new Card(
                              child: new Column(
                                children: <Widget>[
                                  Hero(
                                    tag: eventsByTags[_selectedTag][position].imageUrl,
                                    child: CachedNetworkImage(
                                        imageUrl: eventsByTags[_selectedTag][position].imageUrl,
                                        fit: BoxFit.cover
                                    )),
                                  ListTile(
                                    title: new Text(eventsByTags[_selectedTag][position].title),
                                    subtitle: new Text(eventsByTags[_selectedTag][position].date),
                                  )
                                ],
                              )),
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
