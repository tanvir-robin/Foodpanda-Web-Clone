import 'package:flutter/material.dart';

import 'package:foodpanda_clone/screens/redtaurant_admin/home.dart';

class BacktoAdminButton extends StatelessWidget {
  const BacktoAdminButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
        onPressed: () {
          Navigator.of(context).pushNamed(RestaurantManagementPage.routeName);
        },
        icon: const Icon(
          Icons.home_mini,
          color: Colors.white,
        ),
        label: const Text(
          'Back to home',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
        ));
  }
}
