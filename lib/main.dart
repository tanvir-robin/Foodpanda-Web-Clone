import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:foodpanda_clone/controllers/initializer.dart';
import 'package:foodpanda_clone/firebase_options.dart';
import 'package:foodpanda_clone/screens/checkout.dart';
import 'package:foodpanda_clone/screens/home_page.dart';
import 'package:foodpanda_clone/screens/login_screen.dart';
import 'package:foodpanda_clone/screens/my_orders.dart';
import 'package:foodpanda_clone/screens/nearest_restaurant.dart';
import 'package:foodpanda_clone/screens/redtaurant_admin/add_item.dart';
import 'package:foodpanda_clone/screens/redtaurant_admin/home.dart';
import 'package:foodpanda_clone/screens/redtaurant_admin/items.dart';
import 'package:foodpanda_clone/screens/redtaurant_admin/menu_card.dart';
import 'package:foodpanda_clone/screens/redtaurant_admin/restaurant_orders.dart';
import 'package:foodpanda_clone/screens/restaurant_login.dart';
import 'package:foodpanda_clone/screens/restaurant_map.dart';
import 'package:foodpanda_clone/screens/restaurant_signup.dart';
import 'package:foodpanda_clone/screens/sign_up_screen.dart';
import 'package:foodpanda_clone/utils/google_api_field.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // This is the last thing you need to add.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GetStorage.init();
  InitializeAll().init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FoodPanda',
      routes: {
        '/': (context) => const HomePage(),
        LoginPage.routeName: (context) => LoginPage(),
        SignUpPage.routeName: (context) => SignUpPage(),
        RestaurantSignUp.routeName: (context) => RestaurantSignUp(),
        RestaurantLogin.routeName: (context) => RestaurantLogin(),
        OrdersScreen.routeName: (context) => OrdersScreen(),
        RestaurantOrder.routeName: (context) => RestaurantOrder(),
        RestaurantMap.routeName: (context) => RestaurantMap(),
        NearestRestaurantsPage.routeName: (context) => NearestRestaurantsPage(),
        GMap.routeName: (context) => GMap(),
        RestaurantItemForm.routeName: (context) => RestaurantItemForm(),
        RestaurantMenu.routeName: (context) => RestaurantMenu(),
        CheckoutPage.routeName: (context) => CheckoutPage(),
        AllItems.routeName: (context) => const AllItems(),
        RestaurantManagementPage.routeName: (context) =>
            RestaurantManagementPage(),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
