
import 'package:app_final/config/routes.dart';
import 'package:app_final/constants.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:app_final/pages/location_service.dart';
import 'package:app_final/models/location.dart';

class MapScreen extends StatefulWidget { 
  const MapScreen({Key? key,})
      : super(key: key,);
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  String? placeId; //lugar seleccionado
  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  GoogleMapController? _mapController;

  LatLng _initialCameraPosition = LatLng(18.495957435360776, -69.93450931777639);
  Location? lg;
  Marker? _marker;
  
  Set<Marker> _markers = Set<Marker>();
  

  @override
  void initState() {
    super.initState();
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  // }

  void setCurrentLocation() async{
    await LocationService().getCurrentLocation().then((value) {
      setState(() {
        _initialCameraPosition = LatLng(value.latitude, value.longitude);
      });
      _customInfoWindowController.googleMapController!.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: _initialCameraPosition,
                zoom: 15,
              ),
            ),
          );
    });
  }

  void initialize() {
    setCurrentLocation();
  }

  void _onMapCreated(GoogleMapController controller) {
    _customInfoWindowController.googleMapController = controller;
  }

  Future<Location> getPlaceDetails(String placeId) async {
    LocationService ls = LocationService();
    var place = await ls.getPlace(placeId);
    final double lat = place['geometry']['location']['lat'];
    final double lng = place['geometry']['location']['lng'];
    var average = 0;
    int counter = 0;
    if(place['reviews'] != null){
      for (var element in place["reviews"]) {
        average += element["rating"] as int;
        counter++;
      }
    }

    return Location(lat, lng, place['name'], place["formatted_address"],
        place["photos"][0]["photo_reference"], ((counter> 0)?(average ~/ counter): 0));
  }

  Container _createLocationBox(
      String name, String address, String img, int average) {
    List<Icon> stars = [];
    for (var i = 0; i < average; i++) {
      stars.add( const Icon(
        Icons.star,
        color: Colors.amber,
      ));
    }
    return Container(
      width: 300,
      height: 220,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 300,
            height: 100,
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      "https://maps.googleapis.com/maps/api/place/photo?maxwidth=300&photo_reference=${img}&key=${apiKey}"),
                  fit: BoxFit.fitWidth,
                  filterQuality: FilterQuality.high,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                color: Colors.white),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
            child: Row(
              children: [
                SizedBox(
                  width: 150,
                  child: Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const Spacer(),
                 const Icon(Icons.add_location, size: 30, color: Colors.blue,)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
            child: Text(
              address,
              maxLines: 2,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
            child: Row(children: stars),
          )
        ],
      ),
    );
  }

  void _goToLocation() {
    _customInfoWindowController.hideInfoWindow!();
    if (placeId != null) {
      getPlaceDetails(placeId as String).then((lg) {
        setState(() {
          _marker = Marker(
            markerId: const MarkerId('marker_id'),
            position: LatLng(lg.latitude, lg.longitude),
            onTap: () {
              _customInfoWindowController.addInfoWindow!(
                  _createLocationBox(lg.name, lg.address, lg.image, lg.average),
                  LatLng(lg.latitude, lg.longitude));
            },
            icon: BitmapDescriptor.defaultMarker,
          );
        });

        if(!_markers.contains(_marker)){
          _markers.add(_marker!);
        }

        setState(() {
          _initialCameraPosition = LatLng(lg.latitude, lg.longitude);
        });

        _customInfoWindowController.googleMapController!
            .moveCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            target: _initialCameraPosition,
            zoom: 13,
          ),
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor40LightTheme,
        title: const Text('UrbanQuest'),
        actions: [
          IconButton(onPressed: () =>_navigateToSearchLocationScreen(), icon: const Icon(
                  Icons.search,
                  color: Colors.white,
                  size: 35,
                ),),
          IconButton(
            iconSize: 35,
            onPressed: () => Navigator.pushNamed(context, AppRoutes.myPlaces), icon: const Icon(Icons.location_history))
        ]
      ),
      body: Stack(
        children: [
          GoogleMap(
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            onMapCreated: _onMapCreated,
            markers: _markers,
            onTap: (position) {
              _customInfoWindowController.hideInfoWindow!();
            },
            onCameraMove: (position) {
              _customInfoWindowController.onCameraMove!();
            },
            initialCameraPosition: CameraPosition(
              target: _initialCameraPosition,
              zoom: 15,
            ),
            myLocationEnabled: true,
          ),
          CustomInfoWindow(
            controller: _customInfoWindowController,
            height: 220,
            width: 300,
            offset: 35,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: const Icon(Icons.location_searching),
        onPressed: () {
          setCurrentLocation();
        },
      ),
    );
  }

  _navigateToSearchLocationScreen() async {
    final result = await Navigator.pushNamed(
      context,
      AppRoutes.searchLocation,
    );

    if (result != null) {
      setState(() {
        placeId = result as String;
      });
      _goToLocation();
    }
  } 
    
}
