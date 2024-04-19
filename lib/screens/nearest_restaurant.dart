import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodpanda_clone/controllers/auth_controller.dart';
import 'package:foodpanda_clone/controllers/functions.dart';
import 'package:foodpanda_clone/utils/course_card.dart';

import 'package:get/get.dart';

class NearestRestaurantsPage extends StatefulWidget {
  static const routeName = 'near';
  @override
  _NearestRestaurantsPageState createState() => _NearestRestaurantsPageState();
}

class _NearestRestaurantsPageState extends State<NearestRestaurantsPage> {
  AuthController auth = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    final current =
        ModalRoute.of(context)!.settings.arguments as Map<String, double?>;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Nearest Restaurants',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.orange,
      ),
      body: FutureBuilder(
          future: auth.checkPreviousLogin(),
          builder: (context, snapshot) {
            return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('restaurant')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final responses = snapshot.data!.docs;
                List<QueryDocumentSnapshot<Map<String, dynamic>>>
                    filteredResponses = [];
                for (var element in responses) {
                  final distance = calculateDistance(
                      current['lat'],
                      current['long'],
                      element['location_lat'],
                      element['location_long']);

                  if (distance <= 10) {
                    filteredResponses.add(element);
                  }
                }

                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4),
                  shrinkWrap: true,
                  itemCount: filteredResponses.length,
                  itemBuilder: (context, index) {
                    return CourseCard(
                        restaurantDocID: filteredResponses[index].id,
                        restaurantName: filteredResponses[index]['name'],
                        restaurantCover: filteredResponses[index]['coverPhoto'],
                        restaurantAddress: filteredResponses[index]['address']);
                  },
                );
              },
            );
          }),
    );
  }
}
