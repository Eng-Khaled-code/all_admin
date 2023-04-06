import 'package:flutter/cupertino.dart';
import 'package:middleman_all/View/home/admin_full_access/admin_full_access.dart';
import 'package:middleman_all/View/home/middleman/middleman_body.dart';
import '../admin/admin.dart';

import 'package:middleman_all/View/home/course/courses_body.dart';
import 'package:middleman_all/View/home/doctor/doctor.dart';
import 'package:middleman_all/View/home/ecommerce/ecommerce_body.dart';

loadingAppBody({String? userType,Widget? middlemanAddOrUpdate}) {
  switch (userType) {
    case "middleman":
      return  Middleman(addOrUpdateWidget:middlemanAddOrUpdate);
    case "course_admin":
      return CoursesSwitch();
    case "ecommerce":
      return Ecommerce(addOrUpdateWidget: middlemanAddOrUpdate);
    case "doctor":
      return Doctor();
    case "admin":
      return Admin();
    case "full_access":
      return AdminFullAccess();
  }
}
