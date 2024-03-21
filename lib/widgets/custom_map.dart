import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_with_google_maps_app/models/places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui'as ui;

import 'package:location/location.dart';

import '../utils/location_service.dart';
class CustomGoogleMap extends StatefulWidget {
  const CustomGoogleMap({Key? key}) : super(key: key);
  @override
  State<CustomGoogleMap> createState() => _CustomGoogleMapState();
}

class _CustomGoogleMapState extends State<CustomGoogleMap> {
 late CameraPosition initialCameraPosition;
  GoogleMapController ?googleMapController;
 Set<Marker> markers = {};
 Set<Marker> customMarkers = {};
 Set<Polyline> polyLines = {};
 Set<Polygon> polyGon = {};
 Set<Circle> circles={};
 late Location location;
 late LocationService locationService;
 @override
  void initState() {
   initialCameraPosition=const CameraPosition(
       target: LatLng(30.364264289272377, 31.374694545902308),
       zoom: 0
   );
   // initMarkers();
   // initPolyLine();
   // initPolyGon();
   // initCircle();
   location =Location();
   locationService=LocationService();
   updateMyLocation();
    super.initState();
  }
  @override
  void dispose() {
    googleMapController!.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            // circles: circles,
            // polygons: polyGon,
            // polylines: polyLines,
            zoomControlsEnabled: false,
            markers: markers,
            mapType: MapType.normal,
            onMapCreated: (controller){
              googleMapController=controller;
              initMapStyle();
            },
            // cameraTargetBounds: CameraTargetBounds(
            //     LatLngBounds(
            //         southwest: const LatLng(30.358368134970583, 31.380595348354923),
            //         northeast: const LatLng(30.37106888869547, 31.36317171919298)
            //     )
            // ),
            initialCameraPosition:initialCameraPosition,

          ),
          Positioned(
            bottom: 16,
            right: 16,
            left: 16,
              child: ElevatedButton(
              onPressed: (){
                var myMarker=const Marker(
                    markerId: MarkerId("myMarkerLocation"),
                    position:LatLng(31.28982612861943, 30.026643527372592)
                );
                markers.add(myMarker);
                googleMapController!.animateCamera(
                    // CameraUpdate.newLatLng(const LatLng(30.023355415995916, 31.26722451020442))
                    CameraUpdate.newCameraPosition(const CameraPosition(
                        target: LatLng(31.28982612861943, 30.026643527372592),
                        zoom: 12
                    ))
                    // CameraUpdate.scrollBy(1000, 10)
                    // CameraUpdate.scrollBy(-1000, 10)

                );
              },
              child: const Text("Change location")))
        ],
      ),
    );
  }


  void initMarkers() async{
   var customMarkerIcon= BitmapDescriptor.fromBytes(await getImageFromRawData("assets/images/marker.jpg",100));
   // var customMarker=await BitmapDescriptor.fromAssetImage(ImageConfiguration(), "assets/images/marker.jpg");
  var myMarkers=  places.map((placeModel) => Marker(
      icon:customMarkerIcon ,
      infoWindow:InfoWindow(
        title: placeModel.name
      ),
        markerId: MarkerId("${placeModel.id}"),
        position: placeModel.latLng
    )).toSet();
   customMarkers.addAll(myMarkers);
  setState(() {

  });
  }
 void initMapStyle() async{
   var mapStyle=  await DefaultAssetBundle.of(context).loadString("assets/google_maps_style/google_maps_theme_night.json");
   googleMapController!.setMapStyle(mapStyle);
 }

 Future<Uint8List>getImageFromRawData(String image,double width) async{
   var imageData=await rootBundle.load(image);
   var imageCodec= await ui.instantiateImageCodec(
     imageData.buffer.asUint8List(),
     targetWidth: width.round()
   );
   var imageFrameInfo= await imageCodec.getNextFrame();
   var imageBytData= await imageFrameInfo.image.toByteData(
       format: ui.ImageByteFormat.png);
   return imageBytData!.buffer.asUint8List();
  }

  void initPolyLine() {
   Polyline polyline=const Polyline(
     zIndex: 2,
     width: 5,
     startCap: Cap.roundCap,
     color: Colors.red,
       polylineId: PolylineId("1"),
       points: [
         LatLng(31.20948592802463, 29.923969906770736),
         LatLng(31.310442926522935, 30.05855242499564),

       ],
   );
   Polyline polyline3=const Polyline(
     geodesic:true,
     zIndex: 2,
     width: 5,
     startCap: Cap.roundCap,
     color: Colors.red,
       polylineId: PolylineId("1"),
       points: [
         LatLng(84.08245738094911, 45.29521604938953),
         LatLng(-83.80430283581339, -36.09150223992384),

       ],
   );
   Polyline polyline2=const Polyline(
     zIndex: 1,
     width: 5,
     startCap: Cap.roundCap,
     color: Colors.black,
       polylineId: PolylineId("1"),
       points: [
         LatLng(31.285198296753595, 30.025868369001458),
         LatLng(31.290119515447994, 30.0228750237626),
         LatLng(31.29042665331531, 30.02898777808653),
         LatLng(31.285198296753595, 30.025868369001458),
       ],
   );
   polyLines.add(polyline);
   polyLines.add(polyline2);
   polyLines.add(polyline3);
  }

  void initPolyGon() {
   Polygon polygon = Polygon(
     holes: const [
       [
         LatLng(29.31351446669005, 30.84288751690845),
         LatLng(29.31269121902489, 30.860826130625934),
         LatLng(29.30984722144509, 30.84855234229292),
       ],
     ],
      strokeWidth: 5,
        fillColor: Colors.red.withOpacity(.5),
        polygonId: const PolygonId("1"),
        points: const [
          LatLng(29.320549221302045, 30.83327447989239),
          LatLng(29.31299058258065, 30.871469135893715),
          LatLng(29.293679835004507, 30.83147203545188),
        ],
   );
   polyGon.add(polygon);
  }

  void initCircle() {
     Circle circleElobour= Circle(
         circleId: const CircleId("1"),
         center: const LatLng(30.186776869480756, 31.446448915508814),
         radius: 1000,
         fillColor: Colors.black.withOpacity(.3)
         
     );
     circles.add(circleElobour);
  }
//inquire about location service

  void updateMyLocation() async{
   await locationService.checkAndRequestLocationServices();
  bool hasPermission= await locationService.checkAndRequestLocationPermission();
  if(hasPermission){
    locationService.getLocationData((locationData){
      createMyCameraPosition(locationData);

      print("wwwwwwwwwwww");
    });

  }else{}
  }

  void createMyCameraPosition(LocationData locationData) {
    var cameraPosition=CameraPosition(target: LatLng(locationData.latitude!, locationData.longitude!),zoom: 15);
    googleMapController?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    createMyMarkerLocation(locationData);
  }

  void createMyMarkerLocation(LocationData locationData) {
     var myMarker=Marker(
        infoWindow:const InfoWindow(
            title:"هنا يرقد فينوووووو"
        ),
        markerId: const MarkerId("myMarkerLocation"),
        position:LatLng(locationData.latitude!, locationData.longitude!)
    );
    markers.add(myMarker);
    setState(() {});
  }



}
