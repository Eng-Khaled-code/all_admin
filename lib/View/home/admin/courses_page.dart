import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:middleman_all/Controller/data/admin_controller.dart';
import 'package:middleman_all/Models/courses/course_model.dart';
import 'package:middleman_all/View/home/course/course_card/course_card.dart';
import 'package:middleman_all/View/widgets/constant.dart';
import 'search_field.dart';

class CoursesAdminPage extends StatefulWidget {
  const CoursesAdminPage({Key? key}) : super(key: key);

  @override
  State<CoursesAdminPage> createState() => _CoursesAdminPageState();
}

String? selectedCourseCategory;

class _CoursesAdminPageState extends State<CoursesAdminPage> {
  final AdminController _adminController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [_searchWidget(), _dataWidget()],
    );
  }

  _dataWidget() {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async {
          await _adminController.operations(
              moduleName: "courses_list", operationType: "load");
        },
        child: Obx(
          () => _adminController.isLoading.value
              ? loadingWidget()
              : _adminController.courses.isEmpty
                  ? noDataCard(
                      text: "لا توجد كورسات", icon: CupertinoIcons.book)
                  : ListView.builder(
                      itemCount: _adminController.courses.length,
                      itemBuilder: (context, position) {
                        CourseModel _model = CourseModel.fromSnapshot(
                            _adminController.courses[position]);
                        return CourseCard(
                            model: _model,
                            adminController: _adminController,
                            screenType: "admin");
                      }),
        ),
      ),
    );
  }

  SearchField _searchWidget() {
    return SearchField(
      lable: "بحث بإسم الكورس ...",
      onChange: (value) {
        _adminController.coursesSearch(value: value);
        setState(() {});
      },
    );
  }
}
