import 'package:get/get.dart';
import 'package:middleman_all/Controller/data/admin_controller.dart';
import 'package:middleman_all/Controller/data/courses_controller.dart';
import 'package:middleman_all/Controller/data/doctor_controller.dart';
import 'package:middleman_all/Controller/data/ecommerce_controller.dart';
import 'package:middleman_all/Controller/data/middleman_controller.dart';
import 'package:middleman_all/Controller/data/user_controller.dart';

import '../Controller/data/theme_controller.dart';
class MyBindings implements Bindings
{
  @override
  void dependencies() {
    //data controllers
   Get.put(UserController(),permanent: true);
   //Get.put(ThemeController(),permanent: true);
   Get.lazyPut(() => MiddlemanController(),fenix: true);
   Get.lazyPut(() => EcommerceController(),fenix: true);
   Get.lazyPut(() => DoctorController(),fenix: true);
   Get.lazyPut(() => AdminController(),fenix: true);
   Get.lazyPut(() => CoursesController(),fenix: true);

  }

}