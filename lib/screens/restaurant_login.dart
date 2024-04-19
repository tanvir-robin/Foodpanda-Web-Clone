import 'package:flutter/material.dart';
import 'package:foodpanda_clone/controllers/auth_controller.dart';
import 'package:foodpanda_clone/screens/redtaurant_admin/home.dart';
import 'package:foodpanda_clone/screens/restaurant_signup.dart';
import 'package:foodpanda_clone/utils/back_to_home.dart';
import 'package:foodpanda_clone/utils/show_toast.dart';
import 'package:get/get.dart';

class RestaurantLogin extends StatefulWidget {
  static const routeName = 'reslogin';
  @override
  _RestaurantLoginState createState() => _RestaurantLoginState();
}

class _RestaurantLoginState extends State<RestaurantLogin> {
  AuthController auth = Get.find<AuthController>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
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
                  'assets/res_gif3.gif',
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
                            'Welcome Back Owner!',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
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
                              controller: passwordController,
                              decoration: InputDecoration(
                                labelStyle: const TextStyle(fontSize: 14),
                                labelText: 'Password',
                                hintText: 'Enter your password',
                                filled: true, // Add background color
                                fillColor: Colors
                                    .grey.shade200, // Set background color
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.visibility_off),
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
                              final user = await auth.loginReastaurant(
                                  emailController.text,
                                  passwordController.text);
                              if (user.user != null && context.mounted) {
                                showToastMessage('Success');
                                Navigator.of(context).pushNamed(
                                    RestaurantManagementPage.routeName);
                              } else {
                                showToastMessage('Error');
                              }
                            }, // Add your login action

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
                              'Login',
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
                    Navigator.of(context).pushNamed(RestaurantSignUp.routeName);
                  },
                  child: const Text(
                    'Don\'t have an account? Register here as an owner',
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
