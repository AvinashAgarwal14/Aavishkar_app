import 'dart:async';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import './eurekoin.dart';

typedef TransferEurekoinItemBodyBuilder<T> = Widget Function(
    TransferEurekoinItem<T> item);
typedef ValueToString<T> = String Function(T value);

class DualHeaderWithHint extends StatelessWidget {
  const DualHeaderWithHint({this.name, this.error, this.showHint});

  final String name;
  final String error;
  final bool showHint;

  Widget _crossFade(Widget first, Widget second, bool isExpanded) {
    return AnimatedCrossFade(
      firstChild: first,
      secondChild: second,
      firstCurve: const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
      secondCurve: const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
      sizeCurve: Curves.fastOutSlowIn,
      crossFadeState:
          isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Expanded(
        flex: 3,
        child: Container(
          padding: EdgeInsets.only(left: 15.0),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: DefaultTextStyle(
                style: Theme.of(context).textTheme.subhead, child: Text(name)),
          ),
        ),
      ),
      Expanded(
          flex: 3,
          child: Container(
              margin: const EdgeInsets.only(left: 24.0),
              child: _crossFade(
                  DefaultTextStyle(
                      style: Theme.of(context).textTheme.subhead,
                      child: Text(error, style: TextStyle(color: Colors.red))),
                  DefaultTextStyle(
                      style: Theme.of(context).textTheme.subhead,
                      child: Text("")),
                  showHint)))
    ]);
  }
}

class CollapsibleBody extends StatelessWidget {
  const CollapsibleBody(
      {this.margin = EdgeInsets.zero, this.child, this.onSave, this.onCancel});

  final EdgeInsets margin;
  final Widget child;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    return Column(children: <Widget>[
      Container(
          margin: const EdgeInsets.only(right: 24.0, bottom: 24.0),
          child: Center(
              child: DefaultTextStyle(
                  style: textTheme.caption.copyWith(fontSize: 15.0),
                  child: child))),
      const Divider(height: 1.0),
      Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
            Container(
                margin: const EdgeInsets.only(right: 8.0),
                child: FlatButton(
                    onPressed: onSave,
                    textTheme: ButtonTextTheme.normal,
                    child: const Text('Send'))),
            Container(
                margin: const EdgeInsets.only(right: 8.0),
                child: FlatButton(
                    onPressed: onCancel,
                child: const Text('Cancel')))
          ]))
    ]);
  }
}

class TransferEurekoinItem<T> {
  TransferEurekoinItem(
      {this.name, this.builder, this.error, this.valueToString});

  final String name;
  String error;
  final TransferEurekoinItemBodyBuilder<T> builder;
  final ValueToString<T> valueToString;
  bool isExpanded = false;
  bool isError = false;

  ExpansionPanelHeaderBuilder get headerBuilder {
    return (BuildContext context, bool isExpanded) {
      return DualHeaderWithHint(name: name, error: error, showHint: isExpanded);
    };
  }

  Widget build() => builder(this);
}

GlobalKey<FormState> formKey = GlobalKey<FormState>();

class EurekoinTransfer extends StatefulWidget {
  EurekoinTransfer({Key key, this.name, this.email, this.parent})
      : super(key: key);
  final String name;
  final String email;
  final EurekoinHomePageState parent;
  @override
  _EurekoinTransferState createState() => _EurekoinTransferState();
}

class _EurekoinTransferState extends State<EurekoinTransfer> {
  List<TransferEurekoinItem<dynamic>> _transferEurekoinItem;
  FirebaseUser currentUser;
  final loginKey = 'itsnotvalidanyways';

  TextEditingController amountController = new TextEditingController();
  TextEditingController emailController = new TextEditingController( );
  StreamSubscription<List> processingSuggestionList;
  List suggestionList = new List();

  @override
  void initState() {
    super.initState();

    _transferEurekoinItem = <TransferEurekoinItem<dynamic>>[
      TransferEurekoinItem<String>(
        name: 'Transfer Eurekoin',
        error: '',
        valueToString: (String value) => value,
        builder: (TransferEurekoinItem<String> item) {
          emailController.addListener(processingSuggestionListBuilder);
//          emailController.addListener(suggestionListBuilder);
          void close() {
            setState(() {
              item.isExpanded = false;
            });
          }

          return Form(
            key: formKey,
            child: Builder(
              builder: (BuildContext context) {
                return CollapsibleBody(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  onSave: () {
                    if (formKey.currentState.validate()) {
                      String debit = amountController.text;
                      String transfer = emailController.text;
                      Future<int> result = transferEurekoin(debit, transfer);
                      result.then((value) {
                        print(value);
                        if (value == 0) {
                          setState(() {
                            item.error = "Successful!";
                          });
                          widget.parent.getUserEurekoin();
                          widget.parent.transactionsHistory();
                        } else if (value == 2 || value == 5)
                          setState(() {
                            item.error = "Incorrect User!";
                          });
                        else if (value == 3)
                          setState(() {
                            item.error = "Insufficient Balance!";
                          });
                        else if (value == 4)
                          setState(() {
                            item.error = "Invalid Amount!";
                          });
                        setState(() {
                          amountController.text = '';
                          emailController.text = '';
                        });
                        Form.of(context).reset();
                        close();
                      });
                    }
                  },
                  onCancel: () {
                    setState(() {
                      item.error = '';
                      amountController.text = '';
                      emailController.text = '';
                    });
                    Form.of(context).reset();
                    close();
                  },
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            style: Theme.of(context).textTheme.subhead,
                              keyboardType: TextInputType.number,
                              controller: amountController,
                              decoration: InputDecoration(
                                //fillColor: Colors.black,
                                labelText: "Amount",//helperStyle:  TextStyle(color: Colors.blue),
                                labelStyle: TextStyle(color: Colors.grey),
                              ),
                              validator: (val) => val == "" ? val : null),
                          TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(
                                hintText: "Name",
                                labelText: "Transfer To",
                                labelStyle: TextStyle(color: Colors.grey),
                              ),
                              validator: (val) => val == "" ? val : null),
                          (suggestionList.length != 0)
                              ? Container(
                                  height: (suggestionList.length > 6)? 300.0: 150.0,
                                  child: ListView.builder(
                                      itemCount: suggestionList.length,
                                      itemBuilder: (context, index) {
                                        return  ListTile(
                                                  onTap: (){
                                                    setState(() {
                                                      emailController.text =
                                                      suggestionList[index][1];
                                                      suggestionList = new List();
                                                    });
                                                  },
                                                  title: Text(suggestionList[index][0]),
                                                  subtitle: Text(suggestionList[index][1]),
                                                  leading: CircleAvatar(
                                                    child: Image.network(suggestionList[index][2]),
                                                  ),
                                                );
                                      }))
                              : Container()
                        ],
                      )),
                );
              },
            ),
          );
        },
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData=Theme.of(context);
    return new Theme(
        data: themeData,
        child: SingleChildScrollView(
            child: new DefaultTextStyle(
          style: Theme.of(context).textTheme.subhead,
          child: SafeArea(
            top: false,
            bottom: false,
            child: Container(
              child: Theme(
                  data: themeData,
                  //.copyWith(cardColor: Colors.grey.shade50),
                  child: ExpansionPanelList(
                      expansionCallback: (int index, bool isExpanded) {
                        setState(() {
                          _transferEurekoinItem[index].isExpanded = !isExpanded;
                        });
                        if(_transferEurekoinItem[index].isExpanded==true)
                          widget.parent.moveDown();
                      },
                      children: _transferEurekoinItem
                          .map((TransferEurekoinItem<dynamic> item) {
                        return ExpansionPanel(
                          isExpanded: item.isExpanded,
                          headerBuilder: item.headerBuilder,
                          body: item.build(),
                        );
                      }).toList())),
            ),
          ),
        )));
  }

  Future<int> transferEurekoin(String amount, String transerTo) async {
    var email = widget.email;
    var bytes = utf8.encode("$email" + "$loginKey");
    var encoded = sha1.convert(bytes);
    String apiUrl =
        "https://ekoin.nitdgplug.org/api/transfer/?token=$encoded&amount=$amount&email=$transerTo";
    print(apiUrl);
    http.Response response = await http.get(apiUrl);
    print(response.body);
    var status = json.decode(response.body)['status'];
    return int.parse(status);
  }

  void processingSuggestionListBuilder() {
    processingSuggestionList?.cancel();
    processingSuggestionList =
        suggestionListBuilder().asStream().listen((onData) {
      setState(() {
        suggestionList = onData;
      });
    });
  }

  Future<List> suggestionListBuilder() async {
    if (emailController.text == '') {
      setState(() {
        suggestionList = new List();
      });
      return suggestionList;
    } else {
      String apiUrl =
          "https://ekoin.nitdgplug.org/api/users/?pattern=${emailController.text}";
      http.Response response = await http.get(apiUrl);
      return json.decode(response.body)['users'];
    }
  }
}
