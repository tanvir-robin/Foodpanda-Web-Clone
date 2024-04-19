import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:foodpanda_clone/controllers/auth_controller.dart';
import 'package:foodpanda_clone/controllers/functions.dart';
import 'package:foodpanda_clone/utils/show_toast.dart';
import 'package:get/get.dart';
import 'package:image_picker_web/image_picker_web.dart';

class RestaurantItemForm extends StatefulWidget {
  static const routeName = 'itemadd';
  @override
  _RestaurantItemFormState createState() => _RestaurantItemFormState();
}

class _RestaurantItemFormState extends State<RestaurantItemForm> {
  TextEditingController itemNameController = TextEditingController();
  TextEditingController itemPriceController = TextEditingController();
  TextEditingController imagePickerController = TextEditingController();
  TextEditingController mainIngredientsController = TextEditingController();
  Uint8List? bytesFromPicker;
  // Function to handle image picking
  void pickImage() async {
    bytesFromPicker = await ImagePickerWeb.getImageAsBytes();
    imagePickerController.text = 'Image Selected';
  }

  AuthController auth = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Item'),
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * .30,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'New Item',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: itemNameController,
                decoration: const InputDecoration(
                  labelText: 'Item Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: itemPriceController,
                decoration: const InputDecoration(
                  labelText: 'Item Price',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: mainIngredientsController,
                decoration: const InputDecoration(
                  labelText: 'Main Ingredients',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                onTap: pickImage,
                readOnly: true,
                controller: imagePickerController,
                decoration: const InputDecoration(
                  labelText: 'Image of the Item',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  // Add functionality to handle adding the item
                  String itemName = itemNameController.text;
                  String itemPrice = itemPriceController.text;
                  String mainIngredients = mainIngredientsController.text;
                  String? imageOfTheItem;
                  if (bytesFromPicker != null) {
                    imageOfTheItem = uint8ListToBase64(bytesFromPicker!);
                  }
                  print('--------------');
                  print(auth.docID);
                  await addItemToFirebase(auth.docID!, {
                    'name': itemName,
                    'price': itemPrice,
                    'main_ing': mainIngredients,
                    'image': imageOfTheItem ?? ''
                  });
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                  showToastMessage('Item has been added');
                },
                child: Text('Add'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
