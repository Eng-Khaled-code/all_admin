// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:middleman_all/View/home/home_files/home_page.dart';

import 'courses_page.dart';
import 'discount/discount_page_course.dart';

class CoursesSwitch extends StatelessWidget {
  CoursesSwitch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return

      currentIndex==0
          ?
      CoursesPage()
          :

    CourseDiscountPage();


  }
}

