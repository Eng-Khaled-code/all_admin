import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:middleman_all/Controller/data/courses_controller.dart';
import 'package:middleman_all/Models/courses/section_model.dart';
import 'package:middleman_all/View/widgets/constant2.dart';
import 'package:middleman_all/View/widgets/custom_text.dart';

import '../video_details/videos_page.dart';

class SectionCard extends StatelessWidget {
  const SectionCard({Key? key, this.sectionModel, this.coursesController})
      : super(key: key);
  final CoursesController? coursesController;
  final SectionModel? sectionModel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        coursesController!
            .videoOperations(type: "load", secId: sectionModel!.id);

        Get.to(VideosPage(
            coursesController: coursesController, sectionModel: sectionModel));
      },
      child: Card(
          child: ListTile(
        trailing: operationRow(() {
          //onPressUpdate
          showReasonDialog(
              title: "تعديل سكشن",
              initialValue: sectionModel!.name,
              lable: "السكشن",
              onPress: (secName) async {
                Get.back();
                await coursesController!.sectionOperations(
                    type: "update",
                    name: secName,
                    secId: sectionModel!.id,
                    courseId: sectionModel!.courseId);
              });
        }, () async {
          //onPressDelete
          if (sectionModel!.videoCount != "0") {
            Fluttertoast.showToast(
                msg: "لا يمكنك حذف هذا السكشن لانه يحتوي علي فيديوهات");
          } else {
            Get.back();
            await coursesController!.sectionOperations(
                type: "delete",
                courseId: sectionModel!.courseId,
                secId: sectionModel!.id);
          }
        }, true),
        title: CustomText(
          text: sectionModel!.name!,
          color: Colors.black,
          alignment: Alignment.topRight,
        ),
        subtitle: Text(sectionModel!.videoCount! +
            " فيديو \n " +
            sectionModel!.createdAt!.substring(0, 10)),
      )),
    );
  }
}
