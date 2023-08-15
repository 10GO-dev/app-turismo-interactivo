import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart' hide Location;
import 'package:location/location.dart';



class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  final TextEditingController _searchController = TextEditingController();
  Location _location = Location();
  LatLng _initialCameraPosition = LatLng(18.495957435360776, -69.93450931777639);
  late GoogleMapsPlaces _places;
  List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    _initializeMap();
    _places = GoogleMapsPlaces(apiKey: 'AIzaSyCfL8qyelx3t3P1M7VJhwiOQJ4DrZ0qeCs');

  }

  Future<void> _searchPlaces(String query) async {
    final response = await _places.searchByText(query);
    
  }

  Future<void> _initializeMap() async {
    await _getLocation();
    _mapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: _initialCameraPosition,
          zoom: 15,
        ),
      ),
    );
  }

  Future<void> _getLocation() async {
    final LocationData locationData = await _location.getLocation();
    setState(() {
      _initialCameraPosition = LatLng(locationData.latitude!, locationData.longitude!);
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('UrbanQuest'),
      ),
      body: Stack(
        children: [
          GoogleMap(
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _initialCameraPosition,
            zoom: 15,
          ),
          myLocationEnabled: true,
        ), // Reemplaza esto con tu widget de mapa
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: const EdgeInsets.all(16.0),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: TextFormField(
                    controller: _searchController,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      hintText: 'Busca un lugar',
                      border: InputBorder.none,
                      icon: Icon(Icons.search, color: Colors.green,),
                    ),
                    onChanged: (value) {
                      _searchPlaces(value);
                    },
                  ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: const Icon(Icons.location_searching),
        onPressed: () {
          _getLocation();
          _mapController!.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: _initialCameraPosition,
                zoom: 15,
              ),
            ),
          );
        },
      ),
    );
  }
}
