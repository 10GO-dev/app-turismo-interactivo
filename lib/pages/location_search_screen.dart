import 'package:app_final/components/network_utils.dart';
import 'package:app_final/config/routes.dart';
import 'package:app_final/models/autocomplete_prediction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../components/location_list_tile.dart';
import '../../constants.dart';
import '../models/place_auto_complete_response.dart';
import 'package:app_final/pages/location_service.dart';

class SearchLocationScreen extends StatefulWidget {
  const SearchLocationScreen({Key? key}) : super(key: key);

  @override
  State<SearchLocationScreen> createState() => _SearchLocationScreenState();
}

class _SearchLocationScreenState extends State<SearchLocationScreen> {
  LocationService locationService = LocationService();
  List<AutoCompletePrediction> placePredictions = [];


  void getPlaceDetails(String placeId) async {
    var place = await locationService.getPlace(placeId);
    final double lat = place['result']['geometry']['location']['lat'];
    final double lng = place['result']['geometry']['location']['lng'];
      print("lat: $lat, lng: $lng");
  }

  void placeAutoComplete(String query) async {

    LatLng location = await locationService.getCurrentLocation();
    
    Uri uri = Uri.https(
      "maps.googleapis.com",
      'maps/api/place/autocomplete/json',
      {"input": query,
      "locationbias": "circle:3000@${location.latitude},${location.longitude}",
      "key": apiKey,}
    );

    String? response = await NetworkUtility.fetchUrl(uri);
    if( response != null ){
      PlaceAutocompleteResponse result = PlaceAutocompleteResponse.parseAutocompleteResult(response);
      if(result.predictions != null){
        setState(() {
          placePredictions = result.predictions!;
        });
    }
  }}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: defaultPadding),
          child: CircleAvatar(
            backgroundColor: secondaryColor10LightTheme,
            child: SvgPicture.asset(
              "assets/icons/location.svg",
              height: 16,
              width: 16,
              colorFilter:const ColorFilter.mode(secondaryColor40LightTheme, BlendMode.srcIn),
            ),
          ),
        ),
        title: const Text(
          "Selecciona una ubicación",
          style: TextStyle(color: textColorLightTheme),
        ),
        actions: [
          CircleAvatar(
            backgroundColor: secondaryColor10LightTheme,
            child: IconButton(
              onPressed: () {
                Navigator.popAndPushNamed(context, AppRoutes.home);
              },
              icon: const Icon(Icons.close, color: Colors.black),
            ),
          ),
          const SizedBox(width: defaultPadding)
        ],
      ),
      body: Column(
        children: [
          Form(
            child: Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: TextFormField(
                onChanged: (value) {
                  if(value.isNotEmpty){
                    placeAutoComplete(value);
                  }
                },
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: "Buscar ubicación",
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: SvgPicture.asset(
                      "assets/icons/location_pin.svg",
                      colorFilter: const ColorFilter.mode(secondaryColor40LightTheme, BlendMode.srcIn),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Divider(
            height: 4,
            thickness: 4,
            color: secondaryColor5LightTheme,
          ),
          Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: ElevatedButton.icon(
              onPressed: () {
                
              },
              icon: SvgPicture.asset(
                "assets/icons/location.svg",
                height: 16,
              ),
              label: const Text("Use my Current Location"),
              style: ElevatedButton.styleFrom(
                backgroundColor: secondaryColor10LightTheme,
                foregroundColor: textColorLightTheme,
                elevation: 0,
                fixedSize: const Size(double.infinity, 40),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
          ),
          const Divider(
            height: 4,
            thickness: 4,
            color: secondaryColor5LightTheme,
          ),
          Expanded(child: 
          ListView.builder(
            itemCount: placePredictions.length,
            itemBuilder: (context, index) => LocationListTile(
            press: () {
              getPlaceDetails(placePredictions[index].placeId!);
            },
            location: placePredictions[index].description!,
            )
          ),
          )
        ],
      ),
    );
}
}