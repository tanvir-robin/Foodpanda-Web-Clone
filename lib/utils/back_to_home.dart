import 'package:flutter/material.dart';

class BackToHome extends StatelessWidget {
  const BackToHome({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
        onPressed: () {
          Navigator.of(context).pushNamed('/');
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
