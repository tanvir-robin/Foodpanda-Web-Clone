import 'package:flutter/material.dart';
import 'package:foodpanda_clone/controllers/auth_controller.dart';

import 'package:foodpanda_clone/screens/login_screen.dart';
import 'package:foodpanda_clone/screens/my_orders.dart';
import 'package:foodpanda_clone/screens/sign_up_screen.dart';
import 'package:get/get.dart';

AppBar buildAppBar(BuildContext context, void Function() reload) {
  AuthController auth = Get.find<AuthController>();
  return AppBar(
    backgroundColor: Colors.grey.shade200,
    elevation: 0.0,
    title: Row(
      children: [
        Image.asset(
          'assets/foodpanda.png',
          height: 30,
        ),
      ],
    ),
    centerTitle: true,
    actions: <Widget>[
      if (auth.isLoggedIn != null && auth.isLoggedIn == true)
        PopupMenuButton(
          icon: Text('Hi, ${auth.fullName.toString()}'),
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: 'orders',
              child: Text('My Orders'),
            ),
            PopupMenuItem(
              value: 'account',
              child: Text('My Account'),
            ),
            PopupMenuItem(
              value: 'signout',
              child: Text('Sign out'),
            ),
          ],
          onSelected: (value) async {
            // Handle menu item selection here
            if (value == 'orders') {
              Navigator.of(context).pushNamed(OrdersScreen.routeName);
              // Handle My Orders option
            } else if (value == 'account') {
              // Handle My Account option
            } else if (value == 'signout') {
              // Handle Sign out option
              await auth.signOut();
              //  await auth.checkPreviousLogin();
              // if (context.mounted) {
              //   Navigator.of(context).pushNamed('/');
              // }
              print(auth.isLoggedIn);
              reload();
            }
          },
        ),
      const SizedBox(
        width: 14,
      ),
      if (auth.isLoggedIn != null && auth.isLoggedIn == true)
        IconButton(onPressed: () {}, icon: const Icon(Icons.shopping_cart)),
      if (auth.isLoggedIn == null || auth.isLoggedIn == false)
        createElevatedButton('Log in', () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => LoginPage()),
          // );
          Navigator.of(context).pushNamed(LoginPage.routeName);
        }),
      const SizedBox(
        width: 14,
      ),
      if (auth.isLoggedIn == null || auth.isLoggedIn == false)
        createElevatedButton('Sign up', () {
          Navigator.of(context).pushNamed(SignUpPage.routeName);
        }),
      const SizedBox(
        width: 50,
      ),
    ],
  );
}

ElevatedButton createElevatedButton(String title, void Function()? onpressed) {
  return ElevatedButton(
    onPressed: onpressed,
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: const BorderSide(
            color: Colors.pink,
            width: 1.3,
          ),
        ),
      ),
    ),
    child: Text(
      title,
      style: const TextStyle(color: Colors.black),
    ),
  );
}
