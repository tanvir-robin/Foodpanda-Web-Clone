import 'package:flutter/material.dart';
import 'package:foodpanda_clone/controllers/functions.dart';
import 'package:foodpanda_clone/screens/nearest_restaurant.dart';
import 'package:foodpanda_clone/utils/generate_invoice.dart';

import 'package:foodpanda_clone/utils/google_api_field.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class RoundedTextInput extends StatelessWidget {
  final String labelText;
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;

  const RoundedTextInput({
    Key? key,
    required this.labelText,
    required this.hintText,
    this.obscureText = false,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LocationData? current;
    double? lat;
    double? long;
    return Container(
      height: 80,
      width: 200,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26, // Adjust shadow color
            blurRadius: 4.0, // Adjust shadow blur
            offset: Offset(0, 2), // Adjust shadow offset
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: const TextStyle(fontWeight: FontWeight.bold),
              controller: controller,
              onTap: () async {
                Navigator.of(context)
                    .pushNamed(GMap.routeName)
                    .then((value) async {
                  LatLng picked = value as LatLng;
                  lat = picked.latitude;
                  long = picked.longitude;
                  controller.text =
                      await getCity(picked.latitude, picked.longitude);
                });
              },
              readOnly: true,
              obscureText: obscureText,
              decoration: InputDecoration(
                suffixIcon: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.black,
                      elevation: 0,
                    ),
                    onPressed: () async {
                      current = await getCurrentLocation();
                      lat = current!.latitude;
                      long = current!.longitude;
                      final city =
                          await getCity(current?.latitude, current?.longitude);
                      controller.text = city;
                    },
                    icon: const Icon(Icons.gps_fixed),
                    label: const Text('Locate Me')),
                labelText: labelText,
                hintText: hintText,
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(16.0), // Match container radius
                  borderSide: const BorderSide(
                    color: Colors.black,
                    width: 1.0,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          GestureDetector(
            onTap: () async {
              if (lat == null || long == null) {
                // current = await getCurrentLocation();
                lat = current!.latitude;
                long = current!.longitude;
              }
              Navigator.of(context).pushNamed(NearestRestaurantsPage.routeName,
                  arguments: {'lat': lat, 'long': long});
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 22),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Find',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
