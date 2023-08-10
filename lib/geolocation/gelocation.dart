import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';


class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  final TextEditingController _searchController = TextEditingController();
  Location _location = Location();

  LatLng _initialCameraPosition = LatLng(0, 0);

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    final LocationData locationData = await _location.getLocation();
    setState(() {
      _initialCameraPosition = LatLng(locationData.latitude!, locationData.longitude!);
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _getLocation(); // Aquí obtenemos la ubicación actual al momento de iniciar la aplicación.
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
          markers: {
            Marker(
              markerId: MarkerId('myMarker'),
              position: _initialCameraPosition,
              infoWindow: InfoWindow(title: 'Mi Ubicación actual'),
            ),
          },
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
