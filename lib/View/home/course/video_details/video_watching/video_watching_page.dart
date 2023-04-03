import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:middleman_all/Controller/data/courses_controller.dart';
import 'package:middleman_all/Models/courses/question_model.dart';
import 'package:middleman_all/Models/courses/video_model.dart';
import 'package:middleman_all/View/widgets/constant.dart';
import 'package:middleman_all/View/widgets/custom_text.dart';
import 'package:video_player/video_player.dart';
import 'add_question.dart';
import 'question_card.dart';
import 'video/video_widget.dart';

class VideoWatchingPage extends StatelessWidget {
  final VideoModel? model;
  final CoursesController? coursesController;
  final VideoPlayerController? videoPlayerController;

  const VideoWatchingPage(
      {Key? key,
      this.model,
      this.coursesController,
      this.videoPlayerController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          floatingActionButton: _floatAB(),
          body: RefreshIndicator(
              onRefresh: () async {
                await coursesController!
                    .questionOperations(type: "load", videoId: model!.id);
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    VideoWidget(videoPlayerController: videoPlayerController),
                    const SizedBox(height: 10),
                    CustomText(
                      text: "  " + model!.name!,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      alignment: Alignment.topRight,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomText(
                          text: model!.desc!,
                          color: Colors.black,
                          textAlign: TextAlign.start,
                          maxLine: 10),
                    ),
                    const Divider(color: Colors.white, thickness: 5),
                    const CustomText(
                        text: "   الاسئلة",
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        alignment: Alignment.topRight),
                    _dataWidget(),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Widget _dataWidget() {
    return Obx(() => coursesController!.isQuestionLoading.value
        ? loadingWidget()
        : coursesController!.questionList.isEmpty
            ? noDataCard(text: "لا توجد اسئلة", icon: Icons.question_mark)
            : ListView.builder(
                padding: const EdgeInsets.only(bottom: 50),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: coursesController!.questionList.length,
                itemBuilder: (context, position) {
                  QuestionModel _model = QuestionModel.fromSnapshot(
                      coursesController!.questionList[position]);
                  return QuestionCard(
                    questionModel: _model,
                    coursesController: coursesController,
                  );
                }));
  }

  FloatingActionButton _floatAB() {
    return FloatingActionButton.extended(
        onPressed: () {
          videoPlayerController!.pause();
          Get.to(AddQuestion(
            videoId: model!.id,
            coursesController: coursesController,
          ));
        },
        icon: const Icon(Icons.question_mark),
        label: const Text("إضافة سؤال"));
  }
}
