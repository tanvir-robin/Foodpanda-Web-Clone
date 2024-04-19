import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class GMap extends StatefulWidget {
  static const routeName = 'map';

  @override
  _GMapState createState() => _GMapState();
}

class _GMapState extends State<GMap> {
  CameraPosition? _initialCameraPosition;
  Set<Marker> _markers = {};
  LatLng? pickedlatLn;
  var response;
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
    response = await FirebaseFirestore.instance.collection('restaurant').get();
    isLoaded = true;
    return true;
  }

  void _handleTap(LatLng latLng) {
    setState(() {
      pickedlatLn = latLng;
      _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId(latLng.toString()),
          position: latLng,
          visible: true,
          infoWindow: const InfoWindow(
            title: "Marker Details",
            snippet: "This location is selected",
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Expanded(child: Text('Pick from Map')),
              IconButton(
                  onPressed: () {
                    if (pickedlatLn == null) {
                      Navigator.of(context).pop();
                    } else {
                      Navigator.pop(context, pickedlatLn);
                    }
                  },
                  icon: const Icon(Icons.done))
            ],
          ),
        ),
        body: _initialCameraPosition == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : GoogleMap(
                initialCameraPosition: _initialCameraPosition!,
                markers: _markers,
                onTap: _handleTap,
              ));
  }
}
