import 'package:app_final/config/routes.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:app_final/pages/location_service.dart';




class MapScreen extends StatefulWidget {
  
  const MapScreen({Key? key}) : super(key: key, );
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  LatLng _initialCameraPosition = LatLng(18.495957435360776, -69.93450931777639);

  @override
  void initState() {
    super.initState();
    setCurrentLocation();
    
  }
  void setCurrentLocation(){
    LocationService().getCurrentLocation().then((value) {
      setState(() {
        _initialCameraPosition = LatLng(value.latitude, value.longitude);
      });
    });
  }

  void initialize(){
    setCurrentLocation();
    _mapController!.moveCamera(
      CameraUpdate.newCameraPosition(
      CameraPosition(
        target: _initialCameraPosition,
        zoom: 15,
        ),
      ));
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
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FloatingActionButton(
                    backgroundColor: Colors.green[700],
                    child: const Icon(Icons.search, color: Colors.white,size: 30,),
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.searchLocation),
                  ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: const Icon(Icons.location_searching),
        onPressed: () {
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
