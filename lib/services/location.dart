

import 'package:geolocator/geolocator.dart';

class Location { //LOCATION class so the location of the user isn't grabbed every time new data needs to be accessed concerning the location

  late Position _current;

  Location() {
    _current = new Position(longitude: 5,
        latitude: 5,
        timestamp: null,
        heading: 5,
        accuracy: 5,
        altitude: 5,
        speed: 5,
        speedAccuracy: 5); //dummy position
  }

  Future<void> _getCurrentLocation() async {
    if(_current.longitude == 5.0) {
      await Geolocator
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.best,
          forceAndroidLocationManager: true)
          .then((Position position) async {
          _current = position;
      }).catchError((e) {
        print(e);
      });
    }
  }

  Future<double> getLatitude() async {
    if(_current.latitude == 5) {
      await _getCurrentLocation();
    }
    return _current.latitude;
  }

  Future<double> getLongitude() async {
    if(_current.latitude == 5) {
      await _getCurrentLocation();
    }
    return _current.longitude;
  }

}