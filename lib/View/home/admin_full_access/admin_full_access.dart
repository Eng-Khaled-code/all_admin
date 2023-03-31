import 'package:flutter/material.dart';
import 'package:middleman_all/View/home/admin/admin_dashboard.dart';
import 'package:middleman_all/View/home/home_files/home_page.dart';
import 'books/books_page.dart';
import 'caegory/category_page.dart';
import 'users/users_page.dart';
class AdminFullAccess extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  AdminFullAccess({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      currentIndex==0
          ?
      AdminDashboard()
          :
      currentIndex==1
          ?
       UsersPage()
          :
      currentIndex==2
          ?
      BooksPage()
          :
      CategoryPage();

  }
}
