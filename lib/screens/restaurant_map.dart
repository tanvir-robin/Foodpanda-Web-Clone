import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodpanda_clone/controllers/functions.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class RestaurantMap extends StatefulWidget {
  static const routeName = 'map2';

  @override
  _RestaurantMapState createState() => _RestaurantMapState();
}

class _RestaurantMapState extends State<RestaurantMap> {
  CameraPosition? _initialCameraPosition;
  Set<Marker> _markers = {};
  LatLng? pickedlatLn;

  bool isLoaded = false;
  @override
  void initState() {
    super.initState();
    if (!isLoaded) {
      getUserLocation();
    }
  }

  Future<bool> getUserLocation() async {
    //LocationData? position = await getCurrentLocation();
    setState(() {
      _initialCameraPosition = const CameraPosition(
        target: LatLng(22.4661683, 90.381775),
        zoom: 16,
      );
    });

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Explore in Map')),
        body: _initialCameraPosition == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('restaurant')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final response = snapshot.data!.docs;
                  _markers.clear();
                  for (var element in response) {
                    _markers.add(Marker(
                        markerId: MarkerId(element.id),
                        position: LatLng(
                            element['location_lat'], element['location_long']),
                        infoWindow: InfoWindow(
                            title: element['name'],
                            snippet: element['address']),
                        visible: true));
                  }
                  return GoogleMap(
                    initialCameraPosition: _initialCameraPosition!,
                    markers: _markers,
                  );
                }));
  }
}
