import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    return new Theme(
      data: new ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.indigo,
        platform: Theme.of(context).platform,
      ),
      child: new Scaffold(
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
                        child: new Image.network(
                          widget.item.imageUrl,
                          fit: BoxFit.cover,
                          height: _appBarHeight,
                        )),
                    // This gradient ensures that the toolbar icons are distinct
                    // against the background image.
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(0.0, -1.0),
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
                      icon: null,
                      tooltip: 'Details',
                      onPressed: null,
                      lines: <String>[
                        "${widget.item.body}",
                        "Tag: ${widget.item.tag}"
                      ]
                    )
                  ],
                ),
                (widget.item.link !=null)?
                new DetailCategory(
                  icon: Icons.link,
                  children: <Widget>[
                    new DetailItem(
                      icon: Icons.open_in_new,
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
                      icon: Icons.map,
                      tooltip: 'Open map',
                      onPressed: () {
                        launch("tel:8981866219");
                      },
                      lines: <String>[
                        "${widget.item.date}",
                        "${widget.item.date}"
                      ],
                    ),
                  ],
                ),
                new DetailCategory(
                    icon: Icons.call,
                    children: <Widget>[
                      new DetailItem(
                        icon: Icons.message,
                        tooltip: 'Send message',
                        onPressed: () {
                          launch("tel:8981866219");
                        },
                        lines: <String>[
                          '${widget.item.date}',
                          '${widget.item.date}',
                        ],
                      )
                    ],
                  ),
                new DetailCategory(
                  icon: Icons.contact_mail,
                  children: <Widget>[
                    new DetailItem(
                      icon: Icons.email,
                      tooltip: 'Send personal e-mail',
                      onPressed: () {
                        launch("mailto:agarwalavinash14@gmail.com");
                      },
                      lines:<String>[
                        "${widget.item.date}",
                        "${widget.item.date}"
                      ],
                    ),
                  ],
                )
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
