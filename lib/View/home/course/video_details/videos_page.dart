import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:middleman_all/Controller/data/courses_controller.dart';
import 'package:middleman_all/Models/courses/section_model.dart';
import 'package:middleman_all/Models/courses/video_model.dart';
import 'package:middleman_all/View/widgets/constant.dart';
import 'package:middleman_all/View/widgets/constant2.dart';

import 'add_video.dart';
import 'video_card.dart';

class VideosPage extends StatelessWidget {
  final SectionModel? sectionModel;
  const VideosPage({Key? key, this.sectionModel, this.coursesController})
      : super(key: key);

  final CoursesController? coursesController;

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: _myAppar(),
          floatingActionButton: _myFloatAB(),
          body: RefreshIndicator(
              onRefresh: () async {
                await coursesController!
                    .videoOperations(type: "load", secId: sectionModel!.id);
              },
              child: _dataWidget()),
        ));
  }

  AppBar _myAppar() {
    return customAppbar(
      title: sectionModel!.name,
      actions: likeWidget(
          counter: sectionModel!.videoCount.toString(),
          icon: Icons.video_library,
          iconColor: Colors.orange),
    );
  }

  Widget _dataWidget() {
    return Obx(() => coursesController!.isVideoLoading.value
        ? loadingWidget()
        : coursesController!.videoList.isEmpty
            ? noDataCard(text: "لا توجد فيديوهات", icon: Icons.video_library)
            : ListView.builder(
                padding: const EdgeInsets.only(bottom: 50),
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: coursesController!.videoList.length,
                itemBuilder: (context, position) {
                  VideoModel _model = VideoModel.fromSnapshot(
                      coursesController!.videoList[position]);
                  return VideoCard(
                      model: _model,
                      coursesController: coursesController,
                      courseId: sectionModel!.courseId);
                }));
  }

  FloatingActionButton _myFloatAB() {
    return FloatingActionButton.extended(
        onPressed: () => Get.to(AddVideo(
            coursesController: coursesController,
            courseId: sectionModel!.courseId,
            secId: sectionModel!.id,
            opeType: "add")),
        icon: const Icon(Icons.video_library),
        label: const Text("إضافة فيديو"));
  }
}
