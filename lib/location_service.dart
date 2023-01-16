import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as goa;

class LocationService {
  late Location location;
  bool _serviceEnabled = false;
  PermissionStatus? _grantedPermission;

  static double? latitude;
  static double? longitude;

  LocationService() {
    location = Location();
  }

  //kullanıcıdan konum erişimi sorgulama yoksa erişim isteme
  Future<bool> _checkPermission() async {
    if (await _checkService()) {
      _grantedPermission = await location.hasPermission();
      if (_grantedPermission == PermissionStatus.denied) {
        _grantedPermission = await location.requestPermission();
      }
    }

    return _grantedPermission == PermissionStatus.granted;
  }

  //konum servis kontrolü
  Future<bool> _checkService() async {
    try {
      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
      }
    } on PlatformException catch (error) {
      print('error code is ${error.code} and message = ${error.message}');
      _serviceEnabled = false;
      await _checkService();
    }

    return _serviceEnabled;
  }

  //konum verisi çekme
  Future<LocationData?> getLocation() async {
    if (await _checkPermission()) {
      final locationData = location.getLocation();

      return locationData;
    }

    return null;
  }
}
