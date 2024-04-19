import 'package:foodpanda_clone/controllers/auth_controller.dart';
import 'package:get/get.dart';

class InitializeAll {
  void init() {
    Get.lazyPut(
      () => AuthController(),
    );
  }
}
