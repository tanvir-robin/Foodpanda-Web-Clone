import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodpanda_clone/controllers/auth_controller.dart';

import 'package:foodpanda_clone/screens/redtaurant_admin/items.dart';
import 'package:foodpanda_clone/screens/redtaurant_admin/restaurant_orders.dart';
import 'package:foodpanda_clone/utils/show_toast.dart';
import 'package:get/get.dart';

class RestaurantManagementPage extends StatefulWidget {
  static const routeName = 'admin_res';
  @override
  _RestaurantManagementPageState createState() =>
      _RestaurantManagementPageState();
}

class _RestaurantManagementPageState extends State<RestaurantManagementPage> {
  int ordersCount = 0;
  int runningOrdersCount = 0;
  int itemsCount = 9;
  AuthController auth = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: auth.checkPreviousLogin(),
          builder: (context, snapshot) {
            return Row(
              children: <Widget>[
                Drawer(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      DrawerHeader(
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                        ),
                        child: Text(
                          'Welcome, \n${auth.fullName.toString()}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 19),
                        ),
                      ),
                      ListTile(
                        title: Text('Dashboard'),
                        onTap: () {},
                      ),
                      ListTile(
                        title: Text('Orders'),
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(RestaurantOrder.routeName);
                        },
                      ),
                      ListTile(
                        title: Text('Items'),
                        onTap: () {
                          Navigator.of(context).pushNamed(AllItems.routeName);
                        },
                      ),
                      ListTile(
                        title: Text('Profits'),
                        onTap: () {},
                      ),
                      ListTile(
                        title: Text('Sign Out'),
                        onTap: () async {
                          await auth.signOut();
                          Navigator.of(context).pushNamed('/');
                          showToastMessage('Signed Out');
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('orders')
                                .where('restaurant', isEqualTo: auth.docID)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              runningOrdersCount = 0;
                              final response = snapshot.data!.docs;
                              for (var element in response) {
                                if (element['status'] != 'Delivered' &&
                                    element['status'] != 'Cancelled') {
                                  runningOrdersCount++;
                                }
                              }
                              return _buildDashboardBox('Running Orders',
                                  runningOrdersCount.toString());
                            }),
                        StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('orders')
                                .where('restaurant', isEqualTo: auth.docID)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              ordersCount = snapshot.data!.docs.length;
                              return _buildDashboardBox(
                                  'Total Orders', ordersCount.toString());
                            }),
                        StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('restaurant')
                                .doc(auth.docID)
                                .collection('items')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              itemsCount = snapshot.data!.docs.length;
                              return _buildDashboardBox(
                                  'Items', itemsCount.toString());
                            }),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }

  Widget _buildDashboardBox(String title, String count) {
    return Container(
      width: MediaQuery.of(context).size.width * .30,
      height: MediaQuery.of(context).size.height * .20,
      margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              fontSize: 35.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10.0),
          Text(
            count,
            style: const TextStyle(
              fontSize: 35.0,
            ),
          ),
        ],
      ),
    );
  }
}
