import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:middleman_all/Controller/data/courses_controller.dart';
import 'package:middleman_all/Models/courses/question_model.dart';
import 'package:middleman_all/View/widgets/constant2.dart';
import 'package:middleman_all/View/widgets/custom_text.dart';

import 'add_question.dart';

class QuestionCard extends StatelessWidget {
  final QuestionModel? questionModel;
  final CoursesController? coursesController;

  const QuestionCard({Key? key, this.questionModel, this.coursesController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _questionWidget(),
            _resWidget(
                res: questionModel!.res1, value: questionModel!.trueIndex == 1),
            _resWidget(
                res: questionModel!.res2, value: questionModel!.trueIndex == 2),
            _resWidget(
                res: questionModel!.res3, value: questionModel!.trueIndex == 3),
            _resWidget(
                res: questionModel!.res4, value: questionModel!.trueIndex == 4),
            _operationWidget(),
          ],
        ),
      ),
    );
  }

  CustomText _questionWidget() {
    return CustomText(
      text: questionModel!.question!,
      color: Colors.black,
      fontWeight: FontWeight.bold,
      alignment: Alignment.topRight,
      textAlign: TextAlign.start,
      maxLine: 10,
    );
  }

  _resWidget({String? res, bool? value}) {
    return ListTile(
      leading:
          Radio<bool>(value: value!, onChanged: (value) {}, groupValue: true),
      title: CustomText(
        text: res!,
        color: Colors.black,
        alignment: Alignment.topRight,
        textAlign: TextAlign.start,
        maxLine: 10,
      ),
      subtitle: const Divider(),
    );
  }

  _operationWidget() {
    return operationRow(() {
      Get.to(AddQuestion(
        videoId: questionModel!.videoId,
        quesId: questionModel!.quesId,
        res1: questionModel!.res1,
        res2: questionModel!.res2,
        res3: questionModel!.res3,
        res4: questionModel!.res4,
        question: questionModel!.question,
        trueIndex: questionModel!.trueIndex,
        opeType: "update",
        coursesController: coursesController,
      ));
    }, () async {
      Get.back();
      await coursesController!.questionOperations(
          videoId: questionModel!.videoId,
          type: "delete",
          quesId: questionModel!.quesId);
    }, true);
  }
}
