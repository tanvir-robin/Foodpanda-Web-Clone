import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:foodpanda_clone/controllers/auth_controller.dart';
import 'package:foodpanda_clone/controllers/functions.dart';
import 'package:foodpanda_clone/screens/redtaurant_admin/home.dart';

import 'package:foodpanda_clone/screens/restaurant_login.dart';
import 'package:foodpanda_clone/utils/back_to_home.dart';
import 'package:foodpanda_clone/utils/google_api_field.dart';
import 'package:foodpanda_clone/utils/show_toast.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:image_picker_web/image_picker_web.dart';

class RestaurantSignUp extends StatefulWidget {
  static const routeName = 'ownersignup';
  @override
  _RestaurantSignUpState createState() => _RestaurantSignUpState();
}

class _RestaurantSignUpState extends State<RestaurantSignUp> {
  TextEditingController restaurantnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController pcikedMapController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cpasswordController = TextEditingController();
  AuthController auth = Get.find<AuthController>();
  Uint8List? bytesFromPicker;
  LatLng? restaurantCordinate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blueAccent,
              Colors.purpleAccent,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/res_gif2.gif',
                  height: 300,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 5.0,
                    child: Container(
                      width: MediaQuery.of(context).size.width * .25,
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: <Widget>[
                          const Text(
                            'Welcome Owner!',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          SizedBox(
                            height: 45,
                            child: TextField(
                              controller: restaurantnameController,
                              decoration: InputDecoration(
                                labelStyle: const TextStyle(fontSize: 14),
                                labelText: 'Restaurant Name',
                                hintText: 'Foodies Dine',
                                filled: true, // Add background color
                                fillColor: Colors
                                    .grey.shade200, // Set background color
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.black,
                                    width: 0.0,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Match container radius
                                ),
                              ),
                              keyboardType: TextInputType.text,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          SizedBox(
                            height: 45,
                            child: TextField(
                              controller: emailController,
                              decoration: InputDecoration(
                                labelStyle: const TextStyle(fontSize: 14),
                                labelText: 'Email',
                                hintText: 'john@example.net',
                                filled: true, // Add background color
                                fillColor: Colors
                                    .grey.shade200, // Set background color
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.black,
                                    width: 0.0,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Match container radius
                                ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          SizedBox(
                            height: 45,
                            child: TextField(
                              controller: addressController,
                              decoration: InputDecoration(
                                labelStyle: const TextStyle(fontSize: 14),
                                labelText: 'Address',
                                hintText: '12/C, New Street, NY',
                                filled: true, // Add background color
                                fillColor: Colors
                                    .grey.shade200, // Set background color
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.black,
                                    width: 0.0,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Match container radius
                                ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          SizedBox(
                            height: 45,
                            child: GestureDetector(
                              onTap: () async {
                                // final pickedFile =
                                //     await ImagePickerWeb.getImage(
                                //   source: ImageSource.gallery,
                                // );
                                // setState(() {
                                //   _imageFile = pickedFile;
                                // });
                                // _imageFile = await pickImageFromGallery();
                                bytesFromPicker =
                                    await ImagePickerWeb.getImageAsBytes();

                                setState(() {});
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          bytesFromPicker != null
                                              ? 'Picked'
                                              : 'Restaurant Cover Photo',
                                        ),
                                      ),
                                      const Icon(Icons.image),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          SizedBox(
                            height: 45,
                            child: TextField(
                              onTap: () async {
                                Navigator.of(context)
                                    .pushNamed(GMap.routeName)
                                    .then((value) async {
                                  LatLng picked = value as LatLng;
                                  restaurantCordinate = picked;
                                  pcikedMapController.text = await getCity(
                                      picked.latitude, picked.longitude);
                                });
                              },
                              controller: pcikedMapController,
                              decoration: InputDecoration(
                                labelStyle: const TextStyle(fontSize: 14),
                                labelText: 'Pick Address',
                                hintText: 'Pick from map',
                                filled: true, // Add background color
                                fillColor: Colors
                                    .grey.shade200, // Set background color
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.location_city),
                                  onPressed:
                                      () {}, // Implement password visibility toggling
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Match container radius
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          SizedBox(
                            height: 45,
                            child: TextField(
                              controller: passwordController,
                              decoration: InputDecoration(
                                labelStyle: const TextStyle(fontSize: 14),
                                labelText: 'Password',
                                hintText: 'Enter your password',
                                filled: true, // Add background color
                                fillColor: Colors
                                    .grey.shade200, // Set background color
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.visibility_off),
                                  onPressed:
                                      () {}, // Implement password visibility toggling
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Match container radius
                                ),
                              ),
                              obscureText: true,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          SizedBox(
                            height: 45,
                            child: TextField(
                              controller: cpasswordController,
                              decoration: InputDecoration(
                                labelStyle: const TextStyle(fontSize: 14),
                                labelText: 'Confirm Password',
                                hintText: 'Enter your password agin',
                                filled: true, // Add background color
                                fillColor: Colors
                                    .grey.shade200, // Set background color
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.visibility_off),
                                  onPressed:
                                      () {}, // Implement password visibility toggling
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Match container radius
                                ),
                              ),
                              obscureText: true,
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          ElevatedButton(
                            onPressed: () async {
                              if (restaurantnameController.text.isNotEmpty &&
                                  emailController.text.contains('@') &&
                                  passwordController.text ==
                                      cpasswordController.text) {
                                final user =
                                    await auth.createNewRestaurantAccount(
                                        emailController.text,
                                        passwordController.text,
                                        restaurantnameController.text,
                                        addressController.text,
                                        bytesFromPicker,
                                        restaurantCordinate);
                                if (user.user != null) {
                                  showToastMessage(
                                      'Restaurant Account has been created');
                                  if (context.mounted) {
                                    Navigator.of(context).pushNamed(
                                        RestaurantManagementPage.routeName);
                                  }
                                }
                              } else {
                                showToastMessage('Invalid Input');
                                return;
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.green),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                            child: const Text(
                              'Sign up',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(RestaurantLogin.routeName);
                  },
                  child: const Text(
                    'Already a owner? Log in instead',
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
                const BackToHome()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
