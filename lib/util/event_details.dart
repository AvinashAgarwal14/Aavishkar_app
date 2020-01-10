import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/event.dart';
import './web_render.dart';
import './detailSection.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class EventDetails extends StatefulWidget {
  final EventItem item;
  EventDetails({Key key, this.item}) : super(key: key);

  @override
  EventDetailsState createState() => new EventDetailsState();
}

enum AppBarBehavior { normal, pinned, floating, snapping }

class EventDetailsState extends State<EventDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Container(
            height: double.infinity,
            child: Image.network(
              widget.item.imageUrl,
              fit: BoxFit.cover,
            )),
        SafeArea(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(children: [
                  MaterialButton(
                    padding: const EdgeInsets.all(8.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Icon(Icons.arrow_back_ios),
                    color: Colors.white,
                    textColor: Colors.black,
                    minWidth: 0,
                    height: 40,
                    onPressed: () => Navigator.pop(context),
                  ),
                ]),
              ),
              Spacer(flex: 1),
              Expanded(
                  child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.white),
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 20.0),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                                title: Text(
                              widget.item.title,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 26.0),
                            )),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: Text(
                                widget.item.body,
                                style: TextStyle(color: Colors.grey.shade600, fontSize: 15.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )),
              SlidingUpPanel(
                  minHeight: 65.0,
                  maxHeight: (widget.item.link != "nil")?MediaQuery.of(context).size.height * 0.45:MediaQuery.of(context).size.height * 0.35,
                  panel: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 5.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 35,
                              height: 8,
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0))),
                            )
                          ],
                        ),
                        SizedBox(height: 13.0),
                        Center(child: Text("Show Details")),
                        SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                          Column(
                            children: <Widget>[
                              Icon(Icons.date_range, color: Colors.grey),
                              Padding(
                                padding: EdgeInsets.only(top: 10.0),
                              ),
                              Text(widget.item.date)
                            ],
                          ),
                          (widget.item.location != "nil") ?
                          Column(
                            children: <Widget>[
                              Icon(Icons.location_on, color: Colors.grey),
                              Padding(
                                padding: EdgeInsets.only(top: 10.0),
                              ),
                              Text(widget.item.location)
                            ],
                          ):Container(),
                          Column(
                            children: <Widget>[
                              Icon(Icons.category, color: Colors.grey),
                              Padding(
                                padding: EdgeInsets.only(top: 10.0),
                              ),
                              Text(widget.item.tag)
                            ],
                          )
                          ],
                        ),
                        SizedBox(height: 20.0),
                        Divider(),
                        (widget.item.contact != null)?
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
                        ):Container(),
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
                        ):Container()
                    ]),
                  ),
                      ]))
            ],
    ));
  }
}
