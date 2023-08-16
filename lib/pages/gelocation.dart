import 'package:app_final/config/routes.dart';
import 'package:app_final/pages/location_search_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:app_final/pages/location_service.dart';
import 'package:app_final/models/location.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key})
      : super(
          key: key,
        );
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  LatLng _initialCameraPosition =
      LatLng(18.495957435360776, -69.93450931777639);
  Location? lg;
  Marker _marker = Marker(
    markerId: const MarkerId('marker_id'),
    position: const LatLng(18.495957435360776, -69.93450931777639),
    infoWindow: const InfoWindow(
      title: 'Santo Domingo',
      snippet: 'Capital de la República Dominicana',
    ),
    icon: BitmapDescriptor.defaultMarker,
  );

  @override
  void initState() {
    super.initState();
    //initialize();
  }

  void setCurrentLocation() {
    LocationService().getCurrentLocation().then((value) {
      setState(() {
        _initialCameraPosition = LatLng(value.latitude, value.longitude);
      });
    });
  }

  void initialize() {
    setCurrentLocation();
    _mapController!.moveCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: _initialCameraPosition,
        zoom: 15,
      ),
    ));
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  Future<Location> getPlaceDetails(String placeId) async {
    LocationService ls = LocationService();
    var place = await ls.getPlace(placeId);
    final double lat = place['geometry']['location']['lat'];
    final double lng = place['geometry']['location']['lng'];
    return Location(lat, lng, place['name']);
  }

  @override
  Widget build(BuildContext context) {
    // Verify life cycle type OnMounted
    var placeId = ModalRoute.of(context)!.settings.arguments;
    if (placeId != null) {
      getPlaceDetails(placeId as String).then((lg) {
        setState(() {
          this._marker = Marker(
            markerId: const MarkerId('marker_id'),
            position: LatLng(lg.latitude, lg.longitude),
            infoWindow: InfoWindow(
              title: lg.name,
              snippet: 'Capital de la República Dominicana',
            ),
            icon: BitmapDescriptor.defaultMarker,
          );
        });

        setState(() {
          this._initialCameraPosition = LatLng(lg.latitude, lg.longitude);
        });

        _mapController!.moveCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            target: _initialCameraPosition,
            zoom: 15,
          ),
        ));
      });
    }

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
            markers: {this._marker},
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
                heroTag: "search",
                backgroundColor: Colors.green[700],
                child: const Icon(
                  Icons.search,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.searchLocation),
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
