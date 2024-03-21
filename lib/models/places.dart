import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceModel{
final int id;
final String name;
final LatLng latLng;
PlaceModel({required this.id,required this.latLng,required this.name});
}

List<PlaceModel>places=[
  PlaceModel(
      id: 1,
      latLng: const LatLng(31.285198296753595, 30.025868369001458),
      name: "Samar"),
  PlaceModel(
      id: 2,
      latLng: const LatLng(31.290119515447994, 30.0228750237626),
      name: " شاطيء المنتزه السياحي"),
  PlaceModel(
      id: 3,
      latLng: const LatLng(31.29042665331531, 30.02898777808653),
      name: "شاطيء المعموره"),
];