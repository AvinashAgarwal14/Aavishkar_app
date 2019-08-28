// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'package:map_view/map_view.dart';
// import '../../util/drawer.dart';

// var api_key = "AIzaSyCP6FN-suegsEoCh1MiONTl-yokBLR266I";
// int shown=0;
// class MapPage extends StatefulWidget {
//   @override
//   _MapPageState createState() => new _MapPageState();
// }

// class _MapPageState extends State<MapPage> {
//   MapView mapView = new MapView();
//   Location myUserLocation=null;
//   CameraPosition cameraPosition;
//   var staticMapProvider = new StaticMapProvider(api_key);
//   Uri staticMapUri;

//   List<Marker> markers = <Marker>[
//     new Marker("1", "Lorde's", 23.546576, 87.291463, color: Colors.red),
//     new Marker("2", "Ovals", 23.549968, 87.292022, color: Colors.red),
//     new Marker("3", "Old Academic Building", 23.547954, 87.291439, color: Colors.red),
//     new Marker("4", "New Academic Building", 23.548013, 87.293336, color: Colors.red),
//   ];

//   Future _currentLocation(){
//     mapView.onLocationUpdated.listen((location) {
//       setState(() {
//         myUserLocation = location;
//       });
//     });
//     return null;
//   }

//   showMap() {
//     shown=1;
//     _currentLocation();

//     mapView.show(new MapOptions(
//         initialCameraPosition:
//         new CameraPosition((myUserLocation==null)?new Location(23.32515, 87.17353):myUserLocation, 19.0),
//         mapViewType: MapViewType.normal,
//         showUserLocation: true,
//         showMyLocationButton: true,
//         hideToolbar: true,showCompassButton: true,
//         title: "Recent Location"),
//       toolbarActions: null,
//     );

//     mapView.setMarkers(markers);
//     mapView.zoomToFit(padding: 100);

//     mapView.onMapReady.listen((_) {
//       setState(() {

//         mapView.setMarkers(markers);
//         mapView.zoomToFit(padding: 100);
//       });
//     });



//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     MapView.setApiKey(api_key);
//   }

//   @override
//   Widget build(BuildContext context) {
//     if(shown==0){
//       return Scaffold(
//           drawer: NavigationDrawer(currentDisplayedPage: 6),
//           body:showMap()
//       );
//       }
//     else
//       {
//       shown=0;
//       Navigator.pop(context);
//       return Container(height: 0.0,width: 0.0,);
//       }
//   }

// }