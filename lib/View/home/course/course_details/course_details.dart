import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:middleman_all/Controller/data/courses_controller.dart';
import 'package:middleman_all/Models/courses/course_model.dart';
import 'package:middleman_all/Models/courses/section_model.dart';
import 'package:middleman_all/View/home/course/course_details/section_card.dart';
import 'package:middleman_all/View/widgets/constant.dart';
import 'package:middleman_all/View/widgets/constant2.dart';
import 'package:middleman_all/View/widgets/custom_text.dart';

import '../../../utilities/strings.dart';

class CourseDetails extends StatelessWidget {
  final CourseModel? courseModel;

  const CourseDetails({Key? key, this.courseModel, this.coursesController})
      : super(key: key);
  final CoursesController? coursesController;

  @override
  Widget build(BuildContext context) {
    coursesController!
        .sectionOperations(type: "load", courseId: courseModel!.id);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () => showReasonDialog(
                title: "إضافة سكشن",
                initialValue: "",
                lable: "السكشن",
                onPress: (secName) async {
                  Get.back();
                  await coursesController!.sectionOperations(
                      type: "add", name: secName, courseId: courseModel!.id);
                }),
            icon: const Icon(CupertinoIcons.book),
            label: const Text("إضافة سكشن")),
        body: RefreshIndicator(
            onRefresh: () async {
              await coursesController!
                  .sectionOperations(type: "load", courseId: courseModel!.id);
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  imageWidget(
                      image: Strings.coursesImagesDirectoryUrl +
                          courseModel!.imageUrl!),
                  const SizedBox(height: 10),
                  CustomText(
                    text: courseModel!.name!,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomText(
                        text: courseModel!.desc!,
                        color: Colors.black,
                        textAlign: TextAlign.start,
                        maxLine: 50),
                  ),
                  const Divider(color: Colors.white, thickness: 5),
                  const CustomText(
                    text: "السكاشن",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  _dataWidget(),
                ],
              ),
            )),
      ),
    );
  }

  Widget _dataWidget() {
    return Obx(() => coursesController!.isSectionLoading.value
        ? loadingWidget()
        : coursesController!.sectionsList.isEmpty
            ? noDataCard(text: "لا توجد سكاشن", icon: CupertinoIcons.book)
            : ListView.builder(
                padding: const EdgeInsets.only(bottom: 50),
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: coursesController!.sectionsList.length,
                itemBuilder: (context, position) {
                  SectionModel _model = SectionModel.fromSnapshot(
                      coursesController!.sectionsList[position]);
                  return SectionCard(
                      sectionModel: _model,
                      coursesController: coursesController);
                }));
  }
}
