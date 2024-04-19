import 'dart:convert';
import 'dart:math';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodpanda_clone/utils/generate_invoice.dart';
import 'package:foodpanda_clone/utils/show_toast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import 'package:firebase_storage/firebase_storage.dart';

import 'package:location/location.dart';

Future<String?> uploadFileToFirebaseStorage(File file, String fileName) async {
  try {
    // Create a reference to the location you want to upload to in Firebase Storage
    Reference storageReference = FirebaseStorage.instance.ref().child(fileName);

    // Upload the file to Firebase Storage
    UploadTask uploadTask = storageReference.putFile(file);

    // Wait for the upload to complete
    TaskSnapshot storageTaskSnapshot = await uploadTask;

    // Once the upload is complete, get the download URL for the file
    String downloadURL = await storageTaskSnapshot.ref.getDownloadURL();

    // Return the download URL
    return downloadURL;
  } catch (e) {
    // If an error occurs, return null
    print('Error uploading file to Firebase Storage: $e');
    return 'https://firebasestorage.googleapis.com/v0/b/foodpanda-clone-bacba.appspot.com/o/360_F_324739203_keeq8udvv0P2h1MLYJ0GLSlTBagoXS48.jpg?alt=media&token=4ef5bd2e-4bb5-462a-a788-81254cd495a3';
  }
}

Future<String> fileToBase64(File file) async {
  final bytes = await file.readAsBytes();
  return base64Encode(bytes);
}

String uint8ListToBase64(Uint8List bytes) {
  return base64Encode(bytes);
}

Uint8List base64ToUint8List(String base64String) {
  return base64Decode(base64String);
}

Future<LocationData?> getCurrentLocation() async {
  // Position position = await Geolocator.getCurrentPosition(
  //     desiredAccuracy: LocationAccuracy.high);

  Location location = Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return null;
    }
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return null;
    }
  }

  _locationData = await location.getLocation();

  return _locationData;
}

Future<String> getCity(lat, lng) async {
  // List<Placemark> placemark = await placemarkFromCoordinates(lat, lng);
  // print(placemark[0]);
  final url = Uri.parse(
      'https://api.bigdatacloud.net/data/reverse-geocode-client?latitude=$lat&longitude=$lng&localityLanguage=en');
  final response = await http.get(url);
  final data = jsonDecode(response.body);

  // city = placemark[0].subAdministrativeArea.toString();
  String city = '${data["locality"].toString()}, ${data["city"].toString()}';

  return city;
}

Future<void> addItemToFirebase(
    String docID, Map<String, String> itemData) async {
  await FirebaseFirestore.instance
      .collection('restaurant')
      .doc(docID)
      .collection('items')
      .add(itemData);
  showToastMessage('Item has been added');
}

Future<void> placeOrder(
    String customerName,
    String paymentMethod,
    List<Map<String, dynamic>> cartItems,
    String restaurantDocID,
    String customerID,
    double total,
    String address) async {
  String orderId = generateRandomString();
  await FirebaseFirestore.instance.collection('orders').add({
    'items': cartItems.map((e) => e).toList(),
    'total': total,
    'address': address,
    'customer': customerID,
    'restaurant': restaurantDocID,
    'status': 'Placed',
    'time': DateTime.now(),
    'order_id': orderId
  });
  showToastMessage('Order has been pladed');

  await generateInvoicePDF(
      address: address,
      cartItems: cartItems,
      total: total,
      customerName: customerName,
      paymentMethod: paymentMethod,
      orderID: orderId);
}

Future<void> wirteOnCache(String key, dynamic value) async {
  final memory = GetStorage();
  await memory.write(key, value);
}

Future<dynamic> readFromCache(String key) async {
  final memory = GetStorage();
  var res = await memory.read(key);
  return res;
}

String generateRandomString() {
  Random random = Random();
  String result = '';
  for (var i = 0; i < 5; i++) {
    result += random.nextInt(10).toString();
  }
  return result;
}

double calculateDistance(lat1, lon1, lat2, lon2) {
  var p = 0.017453292519943295;
  var c = cos;
  var a = 0.5 -
      c((lat2 - lat1) * p) / 2 +
      c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
  return 12742 * asin(sqrt(a));
}
