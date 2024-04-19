import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodpanda_clone/controllers/auth_controller.dart';
import 'package:foodpanda_clone/screens/restaurant_map.dart';
import 'package:foodpanda_clone/screens/restaurant_signup.dart';
import 'package:foodpanda_clone/utils/common_appbar.dart';
import 'package:foodpanda_clone/utils/course_card.dart';
import 'package:foodpanda_clone/utils/search_box_home.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchText = TextEditingController();
  AuthController auth = Get.find<AuthController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // auth.checkPreviousLogin();
  }

  void reloadPage() {
    print('Reloaded');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: auth.checkPreviousLogin(),
        builder: (context, snapshot) {
          return Scaffold(
            appBar: buildAppBar(context, reloadPage),
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'It\'s the food and groceries you love, \ndelivered',
                              style: TextStyle(
                                  fontWeight: FontWeight.w800, fontSize: 30),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .40,
                              child: RoundedTextInput(
                                controller: searchText,
                                hintText: 'Your location',
                                labelText: 'Search your location',
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, RestaurantMap.routeName);
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 17, vertical: 12),
                                  primary:
                                      Colors.blue, // Change the color as needed
                                ),
                                child: const Text(
                                  'View All Restaurant in Map',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Image.asset(
                          'assets/home_image.jpeg',
                          height: MediaQuery.of(context).size.height * .60,
                        )
                      ],
                    ),
                  ),
                  if (auth.isLoggedIn == null || auth.isLoggedIn == false)
                    Container(
                      width: MediaQuery.of(context).size.width * .75,
                      height: 300,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              'assets/res.jpeg'), // Replace 'assets/restaurant_image.jpg' with your actual image path
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () {
                            // Add your onPressed action here
                            Navigator.pushNamed(
                                context, RestaurantSignUp.routeName);
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            primary: Colors.blue, // Change the color as needed
                          ),
                          child: const Text(
                            'Join as a Restaurant',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(
                    height: 50,
                  ),
                  const Text(
                    'Explore All Available Restaurants',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('restaurant')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final responses = snapshot.data!.docs;

                        return Center(
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4),
                            shrinkWrap: true,
                            itemCount: responses.length,
                            itemBuilder: (context, index) {
                              return CourseCard(
                                  restaurantDocID: responses[index].id,
                                  restaurantName: responses[index]['name'],
                                  restaurantCover: responses[index]
                                      ['coverPhoto'],
                                  restaurantAddress: responses[index]
                                      ['address']);
                            },
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
