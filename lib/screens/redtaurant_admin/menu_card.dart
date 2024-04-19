import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodpanda_clone/controllers/auth_controller.dart';
import 'package:foodpanda_clone/controllers/functions.dart';
import 'package:foodpanda_clone/screens/checkout.dart';
import 'package:foodpanda_clone/screens/login_screen.dart';
import 'package:foodpanda_clone/utils/show_toast.dart';
import 'package:get/get.dart';

class RestaurantMenu extends StatefulWidget {
  static const routeName = 'menucard';
  @override
  _RestaurantMenuState createState() => _RestaurantMenuState();
}

class _RestaurantMenuState extends State<RestaurantMenu> {
  AuthController auth = Get.find<AuthController>();
  List<Map<String, dynamic>> cartItems = [];
  String resDocID = '';

  @override
  Widget build(BuildContext context) {
    final coverPhoto =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    resDocID = coverPhoto['docID'].toString();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Menu'),
      ),
      body: Column(
        children: [
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: MemoryImage(
                  base64ToUint8List(coverPhoto['cover'].toString()),
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: _buildMenu(coverPhoto),
                ),
                VerticalDivider(),
                Expanded(
                  flex: 2,
                  child: _buildCart(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenu(Map<String, String> coverPhoto) {
    return FutureBuilder(
      future: auth.checkPreviousLogin(),
      builder: (context, snapshot) {
        return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('restaurant')
              .doc(coverPhoto['docID'])
              .collection('items')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final List<DocumentSnapshot> documents = snapshot.data!.docs;

            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                final item = documents[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 3,
                    child: ListTile(
                      leading: item['image'] != null
                          ? Image.memory(
                              base64ToUint8List(item['image']),
                              height: 80,
                              width: 80,
                              fit: BoxFit.cover,
                            )
                          : const Placeholder(
                              fallbackHeight: 80,
                              fallbackWidth: 80,
                            ),
                      title: Text(
                        item['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            'Price: ${item['price']}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[800],
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Ingredients: ${item['main_ing']}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _addItemToCart(item);
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.orange,
                        ),
                        child: Text(
                          'Add to Cart',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildCart() {
    double subtotal = 0;
    for (var item in cartItems) {
      subtotal += item['quantity'] * double.parse(item['price']);
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Cart',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['name'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Price: BDT ${item['price']}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          if (item['quantity'] > 1) {
                                            item['quantity']--;
                                          }
                                        });
                                      },
                                      icon: const Icon(Icons.remove),
                                    ),
                                    Text(item['quantity'].toString()),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          item['quantity']++;
                                        });
                                      },
                                      icon: Icon(Icons.add),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          cartItems.removeAt(index);
                                        });
                                      },
                                      icon: const Icon(Icons.delete),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(),
                  ],
                );
              },
            ),
          ),
          const Divider(),
          Text(
            'Subtotal: \$${subtotal.toStringAsFixed(2)}',
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 200,
            child: Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: () async {
                  await wirteOnCache('selectedRes', resDocID);
                  Navigator.of(context)
                      .pushNamed(CheckoutPage.routeName, arguments: cartItems);
                },
                child: const Text(
                  'Checkout',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addItemToCart(DocumentSnapshot item) {
    if (auth.isLoggedIn == null || auth.isLoggedIn == false) {
      {
        showToastMessage('Please Login first');
        Navigator.of(context).pushNamed(LoginPage.routeName);
        return;
      }
    }
    bool exists = false;
    for (var cartItem in cartItems) {
      if (cartItem['id'] == item.id) {
        cartItem['quantity']++;
        exists = true;
        break;
      }
    }
    if (!exists) {
      cartItems.add({
        'id': item.id,
        'name': item['name'],
        'price': item['price'],
        'quantity': 1,
      });
    }
  }
}
