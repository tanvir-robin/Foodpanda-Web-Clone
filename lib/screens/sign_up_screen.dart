import 'package:flutter/material.dart';
import 'package:foodpanda_clone/controllers/auth_controller.dart';
import 'package:foodpanda_clone/screens/login_screen.dart';
import 'package:foodpanda_clone/utils/back_to_home.dart';
import 'package:foodpanda_clone/utils/show_toast.dart';
import 'package:get/get.dart';

class SignUpPage extends StatefulWidget {
  static const routeName = '/signup';
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController fullnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cpasswordController = TextEditingController();
  AuthController auth = Get.find<AuthController>();
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
                  'assets/logo_gif2.gif', // Replace with your logo
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
                            'Welcome Onboard!',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          SizedBox(
                            height: 45,
                            child: TextField(
                              controller: fullnameController,
                              decoration: InputDecoration(
                                labelStyle: const TextStyle(fontSize: 14),
                                labelText: 'Full Name',
                                hintText: 'John Doe',
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
                              if (fullnameController.text.isNotEmpty &&
                                  emailController.text.contains('@') &&
                                  passwordController.text ==
                                      cpasswordController.text) {
                                final user = await auth.createNewAccount(
                                    emailController.text,
                                    passwordController.text,
                                    fullnameController.text);
                                if (user.user != null) {
                                  showToastMessage('Account has been created');
                                  if (context.mounted) {
                                    Navigator.of(context).pushNamed('/');
                                  }
                                }
                              } else {
                                showToastMessage('Invalid Input');
                                return;
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
                    Navigator.of(context).pushNamed(LoginPage.routeName);
                  },
                  child: const Text(
                    'Already have an account? Log in instead',
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
