import 'package:flutter/material.dart';
import 'package:middleman_all/View/home/admin/courses_page.dart';
import 'package:middleman_all/View/home/admin/ecommerce_page.dart';
import 'package:middleman_all/View/home/home_files/home_page.dart';
import 'admin_dashboard.dart';
import 'middleman_page.dart';
import 'missed/missed_page.dart';

class Admin extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  Admin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return currentIndex == 0
        ? AdminDashboard()
        : currentIndex == 1
            ? EcommercePage()
            : currentIndex == 2
                ? const CoursesAdminPage()
                : currentIndex == 3
                    ? MiddlemanPage()
                    : currentIndex == 4 || currentIndex == 5
                        ? MissedPage()
                        : Container();
  }
}
