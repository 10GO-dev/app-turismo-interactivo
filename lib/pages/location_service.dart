import 'package:app_final/constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:location/location.dart';

class LocationService {
  static final _location = Location();

  Future<LatLng> getCurrentLocation() async {
    final LocationData locationData = await _location.getLocation();

    return LatLng(locationData.latitude!, locationData.longitude!);
  }

  Future<Map<String, dynamic>> getPlace(String input) async {
    LatLng location = await getCurrentLocation();

    print(location.latitude.toString() + " " + location.longitude.toString());
    Uri uri = Uri.https("maps.googleapis.com", 'maps/api/place/details/json', {
      "place_id": input,
      "fields": "name,formatted_address,geometry,photos,reviews",
      "key": apiKey,
    });
    var response = await http.get(uri);
    var json = convert.jsonDecode(response.body);
    var results = json['result']! as Map<String, dynamic>;

    //print(results);
    return results;
  }
}
