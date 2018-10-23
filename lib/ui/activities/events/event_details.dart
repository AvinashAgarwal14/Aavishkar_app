import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../model/event.dart';
import '../../../util/web_render.dart';
import '../../../util/detailSection.dart';

class EventDetails extends StatefulWidget {

  final EventItem item;

  EventDetails({Key key, this.item}) : super(key: key);

  @override
  EventDetailsState createState() => new EventDetailsState();
}

enum AppBarBehavior { normal, pinned, floating, snapping }

class EventDetailsState extends State<EventDetails> {
  static final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final double _appBarHeight = 256.0;

  AppBarBehavior _appBarBehavior = AppBarBehavior.pinned;

  @override
  Widget build(BuildContext context) {
//    return new Theme(
//      data: new ThemeData(
//        brightness: Brightness.dark,
//        primarySwatch: Colors.indigo,
//        platform: Theme.of(context).platform,
//      ),
//      child:
      return new Scaffold(
        key: _scaffoldKey,
        body: new CustomScrollView(
          slivers: <Widget>[
            new SliverAppBar(
              expandedHeight: _appBarHeight,
              pinned: _appBarBehavior == AppBarBehavior.pinned,
              floating: _appBarBehavior == AppBarBehavior.floating || _appBarBehavior == AppBarBehavior.snapping,
              snap: _appBarBehavior == AppBarBehavior.snapping,
              flexibleSpace: new FlexibleSpaceBar(
                title: Text('${widget.item.title}'),
                background: new Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    new Hero(
                        tag: widget.item.imageUrl,
                        child: CachedNetworkImage(
                            imageUrl: widget.item.imageUrl,
                            fit: BoxFit.cover,
                            height: _appBarHeight
                        )),
                    // This gradient ensures that the toolbar icons are distinct
                    // against the background image.
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(0.0, 0.6),
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
                new DetailCategory(
                  icon: Icons.description ,
                  children: <Widget>[
                    new DetailItem(
                      tooltip: 'Details',
                      onPressed: null,
                      lines: <String>[
                        "${widget.item.body}",
                        "Tag: ${widget.item.tag}"
                      ]
                    )
                  ],
                ),
                new DetailCategory(
                  icon: Icons.calendar_today,
                  children: <Widget>[
                    new DetailItem(
                      tooltip: 'Date',
                      lines:<String>[
                        "${widget.item.date}",
                        "Date"
                      ],
                    ),
                  ],
                ),
                (widget.item.link != "nil")?
                new DetailCategory(
                  icon: Icons.link,
                  children: <Widget>[
                    new DetailItem(
                      tooltip: 'Open Link',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => new WebRender(link: widget.item.link)),
                        );
                      },
                      lines: <String>[
                        "${widget.item.link}",
                        "Link"
                      ],
                    ),
                  ],
                )
                    :
                new DetailCategory(
                  icon: Icons.location_on,
                  children: <Widget>[
                    new DetailItem(
                      tooltip: 'Open map',
                      lines: <String>[
                        "${widget.item.location}",
                        "Venue *subject to change"
                      ],
                    ),
                  ],
                ),
        (widget.item.contact!=null && widget.item.contact.length > 10)?
                new DetailCategory(
                    icon: Icons.call,
                    children: <Widget>[
                      new DetailItem(
                        tooltip: 'Send message',
                        onPressed: () {
                          launch("tel:+91${widget.item.contact.substring(0,10)}");
                        },
                        lines: <String>[
                          '+91 ${widget.item.contact.substring(0,10)}',
                          '${widget.item.contact.substring(11)}',
                        ],
                      )
                    ],
                  ):
            new Container()
              ]),
            ),
          ],
        ),
//      ),
    );
  }
}
