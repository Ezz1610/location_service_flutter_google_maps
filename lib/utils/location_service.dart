
import 'package:location/location.dart';

class LocationService{
  Location location=Location();
  Future<bool> checkAndRequestLocationServices()async {
    bool isServiceEnabled=await location.serviceEnabled();
    if(!isServiceEnabled){
      isServiceEnabled=await location.requestService();
      if(!isServiceEnabled){
        return false;
      }
    }
    return true;
  }
  Future<bool> checkAndRequestLocationPermission()async {
    var permissionStatus=await location.hasPermission();
    if(permissionStatus==PermissionStatus.denied){
      permissionStatus=await location.requestPermission();
     return permissionStatus == PermissionStatus.granted;
    }
    if(permissionStatus==PermissionStatus.deniedForever){
      return false;
    }
    return true;

  }
  getLocationData(void Function(LocationData)? onData){
    location.changeSettings(distanceFilter: 2);
    location.onLocationChanged.listen(onData);
  }
}