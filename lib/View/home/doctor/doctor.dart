import 'package:flutter/material.dart';
import 'package:middleman_all/View/home/home_files/home_page.dart';
import 'booking/booking_page.dart';
import 'day_operations/day_ope_page.dart';
import 'doctor_dashboard.dart';

class Doctor extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  Doctor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return currentIndex == 2
        ? const BookingPage()
        : currentIndex == 1
            ? DayOperationPage()
            : DoctorDashboard();
  }
}
