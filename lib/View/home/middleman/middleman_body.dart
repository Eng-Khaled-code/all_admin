import 'package:flutter/material.dart';
import 'package:middleman_all/View/home/home_files/home_page.dart';
import 'package:middleman_all/View/home/middleman/place_view/places_page.dart';
import 'middleman_dashboard.dart';
import 'user_operations.dart';

class Middleman extends StatefulWidget {
   Middleman({Key? key}) : super(key: key);

  @override
  State<Middleman> createState() => _MiddlemanState();
}

class _MiddlemanState extends State<Middleman> {
  @override
  Widget build(BuildContext context) {
    return
      currentIndex ==2
          ?
      const UserOperations():
      currentIndex ==0
          ?
      MiddlemanDashboard()
          :
      PlacesPage();


  }
}

