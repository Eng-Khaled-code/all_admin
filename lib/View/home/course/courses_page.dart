// ignore_for_file: prefer_const_constructors_in_immutables
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:middleman_all/Controller/data/admin_controller.dart';
import 'package:middleman_all/Controller/data/courses_controller.dart';
import 'package:middleman_all/Models/courses/course_model.dart';
import 'package:middleman_all/Models/main_admin/book_model.dart';
import 'package:middleman_all/View/home/admin/search_field.dart';
import 'package:middleman_all/View/widgets/constant.dart';
import 'package:middleman_all/View/home/course/course_card/course_card.dart';

class CoursesPage extends StatefulWidget {

  CoursesPage({Key? key}) : super(key: key);

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  final CoursesController _coursesController=Get.find();
  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        _searchWidget(),
        const SizedBox(height: 10),
        _dataWidget()
      ],

    );
  }


  Widget _dataWidget() {

    return Expanded(
      child: Obx(
              ()=>RefreshIndicator(
              onRefresh: ()async{
                await _coursesController.courseOperations(operationType: "load");
                setState(() {});
              },
              child:_coursesController.isLoading.value
                  ?
              loadingWidget()
                  :
              _coursesController.courses.isEmpty?noDataCard(text:  "لا توجد كورسات",icon: CupertinoIcons.book):

    ListView.builder(
                  itemCount: _coursesController.courses.length,
                  itemBuilder: (context,position){
                    CourseModel _model=CourseModel.fromSnapshot(_coursesController.courses[position]);
                    return CourseCard(model: _model,coursesController: _coursesController);
                  }

              ))

      ),
    );
  }


  SearchField _searchWidget() {
    return SearchField(lable: "بحث بإسم الكورس ...",onChange: (value){
      _coursesController.coursesSearch(value: value);
      setState((){});
    },);

  }
}