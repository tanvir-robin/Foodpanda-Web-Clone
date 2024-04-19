import 'package:flutter/material.dart';
import 'package:foodpanda_clone/controllers/auth_controller.dart';
import 'package:foodpanda_clone/controllers/functions.dart';
import 'package:get/get.dart';

class CheckoutPage extends StatefulWidget {
  static const routeName = 'checkout';

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String? _paymentMethod;
  AuthController auth = Get.find<AuthController>();
  TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cartItems = ModalRoute.of(context)!.settings.arguments
        as List<Map<String, dynamic>>;
    double total = 0;
    for (var item in cartItems) {
      total += item['quantity'] * double.parse(item['price']);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: FutureBuilder(
          future: auth.checkPreviousLogin(),
          builder: (context, snapshot) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Items:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 8),
                        Expanded(
                          child: ListView.builder(
                            itemCount: cartItems.length,
                            itemBuilder: (context, index) {
                              final item = cartItems[index];
                              return Container(
                                margin: EdgeInsets.only(bottom: 8),
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
                                child: ListTile(
                                  title: Text(
                                    '${item['name']} x ${item['quantity']}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Price: \$${item['price']}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      // Add functionality to remove item from cart
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Address:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Container(
                          color: Colors.grey[200],
                          padding: const EdgeInsets.all(8),
                          child: TextField(
                            controller: addressController,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Additional Note:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Container(
                          color: Colors.grey[200],
                          padding: EdgeInsets.all(8),
                          child: TextField(
                            maxLines: 3,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Payment Method:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Column(
                          children: [
                            RadioListTile<String>(
                              title: Text(
                                'Cash on Delivery',
                                style: TextStyle(
                                  color: Colors.black87,
                                ),
                              ),
                              value: 'COD',
                              groupValue: _paymentMethod,
                              onChanged: (value) {
                                setState(() {
                                  _paymentMethod = value;
                                });
                              },
                            ),
                            RadioListTile<String>(
                              title: Text(
                                'Online Payment',
                                style: TextStyle(
                                  color: Colors.black87,
                                ),
                              ),
                              value: 'Online',
                              groupValue: _paymentMethod,
                              onChanged: (value) {
                                setState(() {
                                  _paymentMethod = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
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
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Total: \$${total.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: 200,
                            child: Center(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue),
                                onPressed: () async {
                                  final resdocID =
                                      await readFromCache('selectedRes');
                                  final customerID = auth.docID;

                                  await placeOrder(
                                      auth.fullName!,
                                      _paymentMethod!,
                                      cartItems,
                                      resdocID,
                                      customerID.toString(),
                                      total,
                                      addressController.text);
                                  Navigator.of(context).pushNamed('/');
                                },
                                child: const Text(
                                  'Checkout',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
