import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodpanda_clone/controllers/auth_controller.dart';
import 'package:foodpanda_clone/controllers/functions.dart';
import 'package:foodpanda_clone/screens/redtaurant_admin/add_item.dart';
import 'package:foodpanda_clone/utils/back_to_admin.dart';
import 'package:get/get.dart';

class AllItems extends StatefulWidget {
  static const routeName = 'allites';
  const AllItems({super.key});

  @override
  State<AllItems> createState() => _AllItemsState();
}

class _AllItemsState extends State<AllItems> {
  AuthController auth = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: auth.checkPreviousLogin(),
          builder: (context, snapshot) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton.icon(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(RestaurantItemForm.routeName);
                    },
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Add Item',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Colors.white),
                    )),
                const SizedBox(
                  height: 30,
                ),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * .40,
                    child: StreamBuilder(
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

                        final listOfItems = snapshot.data!.docs;

                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: listOfItems.length,
                          itemBuilder: (context, index) {
                            return Card(
                              elevation: 3,
                              child: ListTile(
                                leading: listOfItems[index]['image'] != null ||
                                        listOfItems[index]['image']
                                            .toString()
                                            .isNotEmpty
                                    ? Image.memory(
                                        base64ToUint8List(
                                            listOfItems[index]['image']),
                                        height: 50,
                                        width: 50,
                                        fit: BoxFit.cover,
                                      )
                                    : const Icon(Icons.image),
                                title: Text(listOfItems[index]['name']),
                                trailing: Text(
                                  'BDT ${listOfItems[index]['price']}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24),
                                ),
                                subtitle: Text(
                                  'Ingredients: ${listOfItems[index]['main_ing']}',
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
                const Expanded(child: SizedBox()),
                const BacktoAdminButton(),
                const SizedBox(
                  height: 40,
                ),
              ],
            );
          }),
    );
  }
}
