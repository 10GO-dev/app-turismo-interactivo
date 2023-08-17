import 'dart:convert' as convert;
class Location {
  double latitude = 0.0;
  double longitude = 0.0;
  String name = "";
  String address = "";
  String image = "";
  int average = 0;
  Location(this.latitude, this.longitude, this.name, this.address, this.image,
      this.average);
}


class Place {
  final String? placeId;
  final String? name;

  Place({this.placeId, this.name});


  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      placeId: json['place_id'] as String?,
      name: json['name'] as String?,
    );
  }

  static List<Place> parsePlaceList(String responseBody) {
    final parsed = convert.jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Place>((json) => Place.fromJson(json)).toList();
  }

}