import 'package:flutter/material.dart';

class DetailCategory extends StatelessWidget {
  const DetailCategory({Key key, this.icon, this.children}) : super(key: key);

  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return new Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: new BoxDecoration(
          border: new Border(
              bottom: new BorderSide(color: themeData.dividerColor))),
      child: new DefaultTextStyle(
        style: Theme.of(context).textTheme.subhead,
        child: new SafeArea(
          top: false,
          bottom: false,
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 10.0),
              ),
              new Container(
                  padding: const EdgeInsets.symmetric(vertical: 18.0),
                  width: 72.0,
                  child: new Icon(icon, color: Colors.grey)),
              new Expanded(child: new Column(children: children))
            ],
          ),
        ),
      ),
    );
  }
}

class DetailItem extends StatelessWidget {
  DetailItem({Key key, this.lines, this.tooltip, this.onPressed})
      : super(key: key);

  final List<String> lines;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    List<Widget> columnChildren = new List();
    if(lines.length > 1)
      {
        columnChildren = lines
            .sublist(0, lines.length - 1)
            .map((String line) => new Text(line))
            .toList();
        columnChildren
            .add(new Text(lines.last, style: themeData.textTheme.caption));
      }
      else
        {
          columnChildren = lines.map((String line) => new Text(line)).toList();
        }

    final List<Widget> rowChildren = <Widget>[
      new Expanded(
          child: new GestureDetector(
        onTap: onPressed,
        child: new Container(
          padding: (lines.length==1)?EdgeInsets.only(top: 10.0):EdgeInsets.only(top: 0.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: columnChildren),
        )),
        )
    ];
    rowChildren.add(new SizedBox(
      width: 60.0,
      child: Container(),
    ));
    return new MergeSemantics(
      child: new Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: rowChildren)),
    );
  }
}
