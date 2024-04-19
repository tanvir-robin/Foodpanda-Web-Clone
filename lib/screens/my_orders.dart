import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodpanda_clone/controllers/auth_controller.dart';
import 'package:foodpanda_clone/utils/back_to_home.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Import for date formatting

class OrdersScreen extends StatefulWidget {
  static const routeName = 'routeName';
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  AuthController auth = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'All Orders',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder(
        future: auth.checkPreviousLogin(),
        builder: (context, snapshot) {
          return Center(
            child: Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * .40,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('orders')
                        .where('customer', isEqualTo: auth.docID)
                        .orderBy('time', descending: true)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Error: ${snapshot.error}',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }
                      if (snapshot.data == null ||
                          snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Text(
                            'No orders found.',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        );
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final order = snapshot.data!.docs[index];
                          final List<Map<String, dynamic>> items =
                              List<Map<String, dynamic>>.from(order['items']);
                          return Card(
                            elevation: 3,
                            margin: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 16,
                            ),
                            child: ListTile(
                              title: Text(
                                'Order ID: ${order['order_id']}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Items:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: List.generate(
                                      items.length,
                                      (index) {
                                        final item = items[index];
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 2,
                                          ),
                                          child: Text(
                                            '${item['name']} x ${item['quantity']}',
                                            style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Total: \$${order['total']}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    'Date & Time: ${DateFormat.yMd().add_jm().format(order['time'].toDate())}',
                                  ),
                                ],
                              ),
                              trailing: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 4,
                                  horizontal: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(order['status']),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  '${order['status']}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              onTap: () {
                                // Add navigation to order details screen
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                const Expanded(child: SizedBox()),
                const BackToHome(),
                const SizedBox(
                  height: 45,
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Delivered':
        return Colors.green;
      case 'Processing':
        return Colors.orange;
      case 'Cancelled':
        return Colors.red;
      case 'On the way':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
