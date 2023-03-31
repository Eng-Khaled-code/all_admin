
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

List<BottomNavigationBarItem> getFullAccessAdminList()=>[
  _bottomNavBarItem(Icons.home),
  _bottomNavBarItem(Icons.person),
  _bottomNavBarItem(CupertinoIcons.book),
  _bottomNavBarItem(Icons.category),
];
List<BottomNavigationBarItem> getDoctorsList()=>[
  _bottomNavBarItem(Icons.home),
  _bottomNavBarItem(Icons.date_range),
  _bottomNavBarItem(Icons.library_books),];
List<BottomNavigationBarItem> getAdminList()=>[
  _bottomNavBarItem(Icons.home),
  _bottomNavBarItem(Icons.shopping_basket),
  _bottomNavBarItem(CupertinoIcons.book),
  _bottomNavBarItem(Icons.account_balance),
  _bottomNavBarItem(Icons.person_search),
  _bottomNavBarItem(Icons.person_search),];
List<BottomNavigationBarItem> getEcommerceList()=>[
  _bottomNavBarItem(Icons.home),
  _bottomNavBarItem(Icons.shopping_basket),
  _bottomNavBarItem(Icons.add),
  _bottomNavBarItem(Icons.library_books),
  _bottomNavBarItem(Icons.money_off),];
List<BottomNavigationBarItem> getCoursesList()=>[
  _bottomNavBarItem(Icons.home),
  _bottomNavBarItem(Icons.money_off),];
List<BottomNavigationBarItem> getMiddlemanList()=>[
  _bottomNavBarItem(Icons.home),
  _bottomNavBarItem(Icons.home_max_sharp),
  _bottomNavBarItem(Icons.add),
  _bottomNavBarItem(Icons.account_balance),
  _bottomNavBarItem(Icons.crop_square),];

BottomNavigationBarItem _bottomNavBarItem(IconData icon){
  return BottomNavigationBarItem(
      label:"" ,
      icon: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Icon(icon)));
}

