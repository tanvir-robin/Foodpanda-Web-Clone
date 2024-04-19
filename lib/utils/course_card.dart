import 'package:flutter/material.dart';
import 'package:foodpanda_clone/controllers/functions.dart';
import 'package:foodpanda_clone/screens/redtaurant_admin/menu_card.dart';

import 'package:google_fonts/google_fonts.dart';

class CourseCard extends StatelessWidget {
  CourseCard({
    super.key,
    required this.restaurantAddress,
    required this.restaurantCover,
    required this.restaurantName,
    required this.restaurantDocID,
    // required this.totalClass,
    // required this.project,
  });
  // final String imagePath;
  // final String seat;
  // final String totalClass;
  // final String project;
  // final String title;
  final String restaurantName;
  final String restaurantAddress;
  final String restaurantCover;
  final String restaurantDocID;

  // UserController userController = Get.find<UserController>();
  // void enrollToCourse() async {
  //   if (!userController.getStatus()) {
  //     showMessage('Please Login first');
  //     return;
  //   }
  //   Map<String, String> data = {
  //     'name': userController.userData['name'],
  //     'email': userController.userData['email'],
  //     'courseName': title,
  //     'userID': userController.userData['userID'] ?? 'Null house'
  //   };

  //   final response = await http
  //       .post(Uri.parse('http://localhost/api/enroll.php'), body: data);

  //   showMessage('Enrolled Succesfully');
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          margin: const EdgeInsets.all(15),
          height: 330,
          width: 280,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey, width: 1)),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(9),
                  topRight: Radius.circular(9),
                ),
                child: Image.memory(
                  base64ToUint8List(restaurantCover),
                  height: 150,
                  width: MediaQuery.of(context).size.width * .30,
                  fit: BoxFit
                      .cover, // BoxFit.cover ensures that the image covers the entire box
                  // width: double.infinity,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     const SizedBox(
              //       width: 9,
              //     ),
              //     NoteContainer(
              //       ic: Icons.people,
              //       msg: '$seat টি সিট',
              //     ),
              //     const SizedBox(
              //       width: 9,
              //     ),
              //     NoteContainer(
              //       ic: Icons.class_,
              //       msg: '$totalClass টি ক্লাস',
              //     ),
              //     const SizedBox(
              //       width: 9,
              //     ),
              //     NoteContainer(
              //       ic: Icons.task,
              //       msg: '$project টি প্রজেক্ট',
              //     ),
              //   ],
              // ),
              const Divider(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                height: 60,
                child: Text(
                  restaurantName,
                  overflow: TextOverflow.clip,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                //  height: 60,
                child: Text(
                  restaurantAddress,
                  overflow: TextOverflow.clip,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 15),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(RestaurantMenu.routeName,
                      arguments: {
                        'cover': restaurantCover,
                        'docID': restaurantDocID
                      });
                },
                child: Card(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.yellow),
                    height: 40,
                    width: 100,
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Menu',
                          overflow: TextOverflow.clip,
                          style: GoogleFonts.tiroBangla(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        const Icon(Icons.arrow_right_alt_rounded),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
