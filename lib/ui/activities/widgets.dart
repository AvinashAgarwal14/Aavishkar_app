import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'events/event_details.dart';
import '../../model/event.dart';
import 'sections.dart';

const double kSectionIndicatorWidth = 32.0;

// The card for a single section. Displays the section's gradient and background image.
class SectionCard extends StatelessWidget {
  const SectionCard({Key key, @required this.section})
      : assert(section != null),
        super(key: key);

  final Section section;

  @override
  Widget build(BuildContext context) {
    return new Semantics(
      label: section.title,
      button: true,
      child: new DecoratedBox(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: <Color>[
              section.leftColor,
              section.rightColor,
            ],
          ),
        ),
        child: new Image.asset(
          section.backgroundAsset,
          color: const Color.fromRGBO(255, 255, 255, 0.075),
          colorBlendMode: BlendMode.modulate,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

// The title is rendered with two overlapping text widgets that are vertically
// offset a little. It's supposed to look sort-of 3D.
class SectionTitle extends StatelessWidget {
  static const TextStyle sectionTitleStyle = TextStyle(
    fontFamily: 'Raleway',
    inherit: false,
    fontSize: 24.0,
    fontWeight: FontWeight.w500,
    color: Colors.white,
    textBaseline: TextBaseline.alphabetic,
  );

  static final TextStyle sectionTitleShadowStyle = sectionTitleStyle.copyWith(
    color: const Color(0x19000000),
  );

  const SectionTitle({
    Key key,
    @required this.section,
    @required this.scale,
    @required this.opacity,
  })  : assert(section != null),
        assert(scale != null),
        assert(opacity != null && opacity >= 0.0 && opacity <= 1.0),
        super(key: key);

  final Section section;
  final double scale;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return new IgnorePointer(
      child: new Opacity(
        opacity: opacity,
        child: new Transform(
          transform: new Matrix4.identity()..scale(scale),
          alignment: Alignment.center,
          child: new Stack(
            children: <Widget>[
              new Positioned(
                top: 4.0,
                child: new Text(section.title, style: sectionTitleShadowStyle),
              ),
              new Text(section.title, style: sectionTitleStyle),
            ],
          ),
        ),
      ),
    );
  }
}

// Small horizontal bar that indicates the selected section.
class SectionIndicator extends StatelessWidget {
  const SectionIndicator({Key key, this.opacity = 1.0}) : super(key: key);

  final double opacity;

  @override
  Widget build(BuildContext context) {
    return new IgnorePointer(
      child: new Container(
        width: kSectionIndicatorWidth,
        height: 3.0,
        color: Colors.white.withOpacity(opacity),
      ),
    );
  }
}

// Display a single SectionDetail.

class SectionDetailView extends StatefulWidget {
  SectionDetailView({Key key, @required this.detail})
      : assert(detail != null && detail.imageUrl != null),
        assert((detail.imageUrl ?? detail.title) != null),
        super(key: key);

  final EventItem detail;

  @override
  _SectionDetailViewState createState() => _SectionDetailViewState();
}

class _SectionDetailViewState extends State<SectionDetailView> {
  PaletteGenerator paletteGenerator;
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseReferenceForUpdate;
  Color cardColor;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.detail.color != 'invalid') {
      if (widget.detail.color == 'null')
        cardColor = Color(0xFF505194);
      else {
        String valueString = widget.detail.color
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
    Widget item;
    item = new GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => new EventDetails(item: widget.detail)),
          );
        },
        child: new Card(
            color: (paletteGenerator != null)
                ? paletteGenerator.lightVibrantColor?.color
                : cardColor,
            child: new Column(
              children: <Widget>[
                new ClipRRect(
                    borderRadius: new BorderRadius.only(
                        topLeft: new Radius.circular(5.0),
                        topRight: new Radius.circular(5.0)),
                    child: Container(
                        height: 256.0,
                        child: SizedBox.expand(
                            child: Hero(
                                tag: widget.detail.imageUrl,
                                child: CachedNetworkImage(
                                    placeholder: Image.asset(
                                        "images/imageplaceholder.png"),
                                    imageUrl: widget.detail.imageUrl,
                                    fit: BoxFit.cover,
                                    height: 256.0))))),
                ListTile(
                  title: new Text(widget.detail.title),
                  subtitle: new Text(widget.detail.date),
                )
              ],
            )));

    return item;
  }

  Future<void> updatePaletteGenerator() async {
    paletteGenerator = await PaletteGenerator.fromImageProvider(
      NetworkImage(widget.detail.imageUrl),
      maximumColorCount: 5,
    );
    setState(() {});
    updateNewsFeedPostColor(paletteGenerator.lightVibrantColor?.color);
  }

  void updateNewsFeedPostColor(Color color) {
    databaseReferenceForUpdate
        .child(widget.detail.key)
        .update({'color': color.toString()});
  }
}
