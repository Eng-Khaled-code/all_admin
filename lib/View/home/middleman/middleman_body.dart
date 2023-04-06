import 'package:flutter/material.dart';
import 'package:middleman_all/View/home/home_files/home_page.dart';
import 'package:middleman_all/View/home/middleman/place_view/places_page.dart';
import 'middleman_dashboard.dart';

class Middleman extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  Middleman({Key? key,this.addOrUpdateWidget}) : super(key: key);
  final Widget? addOrUpdateWidget;
  @override
  Widget build(BuildContext context) {
    return currentIndex == 2
        ? addOrUpdateWidget!
        : currentIndex == 0
            ? MiddlemanDashboard()
            : PlacesPage();
  }
}
