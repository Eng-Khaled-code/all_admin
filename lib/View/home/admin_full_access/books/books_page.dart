// ignore_for_file: prefer_const_constructors_in_immutables
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:middleman_all/Controller/data/admin_controller.dart';
import 'package:middleman_all/Models/main_admin/book_model.dart';
import 'package:middleman_all/View/home/admin/search_field.dart';
import 'package:middleman_all/View/widgets/constant.dart';
import 'books_card.dart';

class BooksPage extends StatefulWidget {

  BooksPage({Key? key}) : super(key: key);

  @override
  State<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  final AdminController _adminController=Get.find();
  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        _searchWidget(),
        _dataWidget()
      ],

    );
  }


  Widget _dataWidget() {

    return Expanded(
      child: Obx(
              ()=>RefreshIndicator(
              onRefresh: ()async{
                await _adminController.operations(operationType: "load",moduleName: "books");
                setState(() {});
              },
              child:_adminController.isLoading.value
                  ?
              loadingWidget()
                  :
               _adminController.books.isEmpty?noDataCard(text:  "لا يوجد كتب",icon: CupertinoIcons.book):

    ListView.builder(
                  itemCount: _adminController.books.length,
                  itemBuilder: (context,position){
                    BookModel _model=BookModel.fromSnapshot(_adminController.books[position]);
                    return BookCard(model: _model,adminController: _adminController);
                  }

              ))

      ),
    );
  }


  SearchField _searchWidget() {
    return SearchField(lable: "بحث بإسم الكتاب ...",onChange: (value){
      _adminController.booksSearch(value: value);
      setState((){});
    },);

  }
}