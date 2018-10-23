import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class EurekoinTransactionsHistory extends StatefulWidget {
  EurekoinTransactionsHistory({Key key, this.name, this.email})
      : super(key: key);
  final String name;
  final String email;

  @override
  _EurekoinTransactionsHistoryState createState() =>
      _EurekoinTransactionsHistoryState();
}

class _EurekoinTransactionsHistoryState
    extends State<EurekoinTransactionsHistory> {
  var transHistory;
  List<ListTile> buildItems;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    transHistory = null;
    buildItems = new List();
    transactionsHistory();
  }

  @override
  Widget build(BuildContext context) {
    return (transHistory == null)
        ? ExpansionTile(
        title: Text('Transactions History'),
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Color(0xff424242),
        children: <Widget>[
          LinearProgressIndicator(
              valueColor:
              new AlwaysStoppedAnimation<Color>(Color(0xFF505194)))
        ])
        : (transHistory.length != 0)
        ? ExpansionTile(
        title: Text('Transactions History'),
        backgroundColor:
        Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Color(0xff424242),
        children: buildTransactionsWidget())
        : ExpansionTile(
        title: Text('Transactions History'),
        backgroundColor:
        Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Color(0xff424242),
        children: <Widget>[
          ListTile(title: Text("No Transactions made."))
        ]);
  }

  Future transactionsHistory() async {
    var email = widget.email;
    var name = widget.name;
    var bytes = utf8.encode("$email" + "$name");
    var encoded = sha1.convert(bytes);
    print("transHistory");

    String apiUrl = "https://eurekoin.avskr.in/api/history/$encoded";
    http.Response response = await http.get(apiUrl);
    setState(() {
      transHistory = json.decode(response.body)['history'];
    });
    print(transHistory.length);
  }

  List buildTransactionsWidget() {
    transactionsHistory();
    buildItems = new List();
    for (var item in transHistory) {
      if (item['receiver'] == widget.email) {
        buildItems.add(ListTile(
            title: Text("Received from"),
            subtitle: Text(item['source']),
            trailing: Text("+ ${item['amount']}",
                style: TextStyle(color: Colors.green))));
      } else {
        buildItems.add(ListTile(
            title: Text("Send to"),
            subtitle: Text(item['receiver']),
            trailing: Text("- ${item['amount']}",
                style: TextStyle(color: Colors.red))));
      }
    }
    return buildItems.toList();
  }
}




