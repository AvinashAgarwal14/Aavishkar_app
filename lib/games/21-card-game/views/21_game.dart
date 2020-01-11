import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:dio/dio.dart';

class CardGame extends StatefulWidget {
  @override
  _CardGameState createState() => _CardGameState();
}

class _CardGameState extends State<CardGame> {
  var player;
  var card='C2';
  var card2='D4';

  bool hit1=false;
  bool hit2=false;
  var api=[];
  

  @override
   

  void initState() {
    // TODO: implement initState
    super.initState();
    void getHttp() async {
  try {
    Response response = await Dio().post("https://jt7zv80o0l.execute-api.ap-south-1.amazonaws.com/latest/posts");
    print(response);
    api=response.data['Items'];
  } catch (e) {
    print(e);
  }
}
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            systemNavigationBarIconBrightness: Brightness.dark));
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/fcards.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: SafeArea(
              child: Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(20.0)
                        ),
                    margin: EdgeInsets.all(10.0),
                    padding: EdgeInsets.all(10.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(20.0)),
                      margin: EdgeInsets.all(10.0),
                      padding: EdgeInsets.all(10.0),
                      child:Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(child:Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(20.0)),
                            margin: EdgeInsets.all(4.0),
                            padding: EdgeInsets.all(2.0),
                            child: Column(
                              children: <Widget>[
                              Expanded(child:_card(1,2)),          
                              ]
                              )
                          ),),
                          Expanded( child:Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(20.0)),
                            margin: EdgeInsets.all(4.0),
                            padding: EdgeInsets.all(2.0),
                            child: Column(
                              children: <Widget>[
                              Expanded(child:_card(1,2)),
                              ]
                              )
                            
                          ),),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: <Widget>[
                          //     _button(Colors.green, 'HIT',1),
                          //     SizedBox(
                          //       width: 10,
                          //     ),
                          //     _button(Colors.red, 'STAND',1),
                          //   ],
                          // ),
                          _chipsLay()
                        ],
                      ),
                    )
                  ),
                  FlatButton(
                    padding: EdgeInsets.fromLTRB(0, 40.0, 0, 0),
                    onPressed: () {
                      Navigator.pop(context);
                      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                          statusBarColor: Colors.white,
                          systemNavigationBarIconBrightness: Brightness.dark));
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Color(0xffff9e80),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }



Widget _button(Color color, String label, var player)
{
  return Expanded(child:RaisedButton(
    color: color,
    child: Text(
      '$label',
    ),
    onPressed: (){
      setState((){
      
      });
    },
  )
  );
}
Hit(var player){
  setState(()
      {
      });
}
Stand(){}


Widget _start()
{
  return FlatButton(
    color: Colors.black,
    onPressed: ()
    {
      setState(()
      {
           
      });
    },
    child: Text('START'),
  );
}

Widget _card( var cardnumber1, var cardnumber2)
{
  return  Center(
            widthFactor: MediaQuery.of(context).size.width,
            child:Stack(
              children: <Widget>[
                Positioned(
                  left:0,
                  bottom: 2,
                  top: 2,
                  child:Image.asset('assets/$card.png'),
                ),
                Positioned(
                  left: 50,
                  bottom: 2,
                  top: 2,
                  child:Image.asset('assets/$card2.png'),
                ),
              ],
              overflow: Overflow.clip,
            )
         );
}

  Widget _chipsLay()
{
  return Container(
  width: MediaQuery.of(context).size.width,
  child:Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      SizedBox(width: 10,),
      _chips(5, Colors.yellow,'assets/sky.png'),
      SizedBox(width: 10,),
      _chips(10, Colors.greenAccent,'assets/blue.png'),
      SizedBox(width: 10,),
      _chips(20, Colors.orange,'assets/violet.png'),
      SizedBox(width: 10,),
    ],
  )
  );
}

Widget _chips(var value,Color chip_color, String chip_image)
{
  return Expanded(child:CircleAvatar(
    radius: 50,
    backgroundImage: AssetImage('$chip_image'),
        child:InkWell(
          onTap: (){},
        
      ),),);
}

}