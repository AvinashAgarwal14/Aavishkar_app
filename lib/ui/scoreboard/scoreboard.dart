import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../../util/drawer.dart';
import 'package:flutter/rendering.dart';


class User{
  User(this.rank,this.username,this.email,this.score);
  int rank;
  String username;
  String email;
  int score;
  set setRank(num value) => rank=value;
  set setUsername(String value) => username=value;
  set setEmail(String value) => email=value;
  set setScore(num value) => score=value;
}

List <dynamic> interficioUsers=List();
List <dynamic> othUsers=List();
List <User> _uSeR=List();
List <DropdownMenuItem<String>> eventList=[

  DropdownMenuItem(child: Text("Interficio",style: TextStyle(fontWeight: FontWeight.bold),),value: "Interficio",),
  DropdownMenuItem(child: Text("Online Treasure Hunt",style: TextStyle(fontWeight: FontWeight.bold),),value: "OTH",),
];


class UserDataSource extends DataTableSource {

  void _sort<T>(Comparable<T> getField(User d), bool ascending) {
    _uSeR.sort((User a, User b) {
      if (!ascending) {
        final User c = a;
        a = b;
        b = c;
      }
      final Comparable<T> aValue = getField(a);
      final Comparable<T> bValue = getField(b);
      return Comparable.compare(aValue, bValue);
    });
    notifyListeners();
  }

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= _uSeR.length)
      return null;
    final User temp=_uSeR[index];
    return DataRow.byIndex( index: index,cells: <DataCell>[
      DataCell(Text('${temp.rank}')),
      DataCell(Text('${temp.username}')),
      DataCell(Text('${temp.score}')),
      DataCell(Text('${temp.email}')),
    ]);
  }

  @override
  int get rowCount => _uSeR.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}


class Scoreboard extends StatefulWidget {
  // static const String routeName = '/material/data-table';
  @override
  _ScoreboardState createState() => _ScoreboardState();
}



class _ScoreboardState extends State<Scoreboard> {

  String Selected;
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int _sortColumnIndex;
  bool _sortAscending = true, dataRecieved=false,comingsoon=true;
  UserDataSource _userDataSource = UserDataSource();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//  Future<Null> _handleRefresh() {
//    final Completer<Null> completer = Completer<Null>();
//    Timer(const Duration(seconds: 3), () { completer.complete(null); });
//    return completer.future.then((_) {
//      _scaffoldKey.currentState?.showSnackBar(SnackBar(
//          content: const Text('Refresh complete'),
//          action: SnackBarAction(
//              label: 'RETRY',
//              onPressed: () {
//                _refreshIndicatorKey.currentState.show();
//              }
//          )
//      ));
//      setState(() {
//        dataRecieved=false;
//        getData();
//      });
//    });
//  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Selected=null;
    getData();
    //Selected="None";
    createUserList("none");
  }

  void _sort<T>(Comparable<T> getField(User d), int columnIndex, bool ascending) {
    _userDataSource._sort<T>(getField, ascending);
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  @override
  Widget build(BuildContext context) {

    if(dataRecieved){
      return Scaffold(
          key: _scaffoldKey,
          drawer: NavigationDrawer(currentDisplayedPage: 2),
          appBar: AppBar(title:  const Text('Live Scoreboard'),elevation: 10.0,),
          body: Container(
            //height: MediaQuery.of(context).size.height,
            //width: MediaQuery.of(context).size.width/2,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/gifs/scorecard.gif"), fit: BoxFit.contain)
            ),
            child: RefreshIndicator(
             displacement: 100.0,
              backgroundColor: Colors.white,
              key: _refreshIndicatorKey,
              onRefresh: getDataOnRefresh,
              child: ListView(
                  padding: const EdgeInsets.all(10.0),
                  children: <Widget>[
                    comingsoon==false?Container(
                      padding: EdgeInsets.only(top: 12.0),
                      alignment: Alignment.topCenter,
                      child: DropdownButton(value:Selected ,iconSize: 13.0,hint: Text("Select Event"),
                        items:eventList,
                        elevation: 20,
                        onChanged: ((value){
                          setState(() {
                            Selected=value;
                            dataRecieved=false;
                          });
                          createUserList(value);
                        }),
                      ),
                    ):Padding(
                      padding: const EdgeInsets.all(50.0),
                      child: Center(child: Text("Coming Soon...",style: TextStyle(fontSize: 24.0),)),
                    ),
                    (comingsoon==false)?
                    ( (Selected!=null)?
                    Stack(alignment: AlignmentDirectional.topCenter,children: <Widget>[
                      Opacity(
                        opacity: 0.8,
                        child: PaginatedDataTable(
                            header: Center(child: const Text('Score Card')),
                            rowsPerPage:_rowsPerPage,
                            onRowsPerPageChanged: (int value) { setState(() { _rowsPerPage = value; }); },
                            sortColumnIndex: _sortColumnIndex,
                            sortAscending: _sortAscending,
                            columns: <DataColumn>[
                              DataColumn(
                                  label: const Text('Rank'),
                                  numeric: true,
                                  onSort: (int columnIndex, bool ascending) => _sort<num>((User d) => d.rank, columnIndex, ascending)
                              ),
                              DataColumn(
                                label: const Text('User'),
                               // tooltip: d.email,
                                numeric: true,
                              ),
                              DataColumn(
                                  label: const Text('Score'),
                                  numeric: true,
                                  onSort: (int columnIndex, bool ascending) => _sort<num>((User d) => d.score, columnIndex, ascending)
                              ),
                              DataColumn(
                                label: const Text('Email'),
                              ),
                            ],
                            source: _userDataSource
                        ),
                      )
                    ]):
                          Center(child: Text("Choose Your Event")))
                    :Container(),
                  ]
              ),
            ),
          )
      );}
    else
    {
      return Scaffold(
        body : Container(
//            height: MediaQuery.of(context).size.height,
//            width: MediaQuery.of(context).size.width,
//            decoration: BoxDecoration(
//                image: DecorationImage(
//                    image: AssetImage("images/gifs/score.gif"), fit: BoxFit.fill)),
//            child: Center(
//                child: CircularProgressIndicator())

          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: Theme.of(context).brightness==Brightness.light?
                  AssetImage("images/gifs/loaderlight.gif"):
                  AssetImage("images/gifs/loaderdark.gif"),
                  fit: BoxFit.fill)
          ),

      ),
        );
    }

  }

  Future <dynamic> getInterficioScoreData() async{
    String apiUrl="http://www.mocky.io/v2/5ba7b4153200004e00e2e9c0";
    http.Response response= await http.get(apiUrl);
    return json.decode(response.body)["standings"];
  }

  Future <dynamic> getOTHScoreData() async{
    String apiUrl="https://oth.pythonanywhere.com/api/leaderboard/";
    http.Response response= await http.get(apiUrl);
    return json.decode(response.body);
  }

  Future <Null> getData()async{
    _refreshIndicatorKey.currentState?.show();
    interficioUsers =await getInterficioScoreData();
    othUsers =await getOTHScoreData();
    await Future.delayed(Duration(seconds: 4));
    setState(() {
      dataRecieved=true;
    });
  }
  Future <Null> getDataOnRefresh()async{
    interficioUsers =await getInterficioScoreData();
    othUsers =await getOTHScoreData();
    createUserList(Selected);
    setState(() {
      dataRecieved=true;
    });
  }


  //optimize by calling setState once
  createUserList(String s){
    switch(s){
      case "Interficio":
        _uSeR=List();
        for(int i=0;i<interficioUsers.length;i++){
          User temp= new User(i+1, interficioUsers[i]["name"], interficioUsers[i]["email"], interficioUsers[i]["score"]);
          _uSeR.add(temp);
        }
        break;
      case "OTH":
        _uSeR=List();
        for(int i=0;i<othUsers.length;i++){
          User temp= new User(i+1, othUsers[i]["name"], "random", othUsers[i]["score"]);
          _uSeR.add(temp);
        }
        break;
      case "None":
        _uSeR=List ();
        break;
      default:
        break;
    }
    setState(() {
      _userDataSource =UserDataSource();
      dataRecieved=true;
    });
  }
}


//  Add another Item in DropDownMenu --> Add one more Future Function--> Add another entry in createUserList
//            gradient: new LinearGradient(
//              colors: <Color>[
//                const Color.fromRGBO(255,255,255, 1.0),
//                const Color.fromRGBO(0,0,0, 0.7),
//              ],
//              stops: [0.0, -1.0],
//              begin: const FractionalOffset(0.0, 0.0),
//              end: const FractionalOffset(0.0, 1.0),
//            ),