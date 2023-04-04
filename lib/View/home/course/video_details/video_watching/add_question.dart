import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:middleman_all/Controller/data/courses_controller.dart';
import 'package:middleman_all/View/widgets/constant.dart';
import 'package:middleman_all/View/widgets/custom_button.dart';
import 'package:middleman_all/View/widgets/custom_text.dart';
import 'package:middleman_all/View/widgets/custom_textfield.dart';

import '../../../../widgets/helper_methods.dart';

// ignore: must_be_immutable
class AddQuestion extends StatefulWidget {
  final int? videoId;
  final int? quesId;
  String? question;
  String? res1;
  String? res2;
  String? res3;
  String? res4;
  int? trueIndex;
  final String? opeType;
  final CoursesController? coursesController;
  AddQuestion(
      {Key? key,
      this.coursesController,
      this.quesId = 0,
      this.question,
      this.videoId = 0,
      this.trueIndex = 1,
      this.res1 = "",
      this.res2 = "",
      this.res3 = "",
      this.res4 = "",
      this.opeType = "add"})
      : super(key: key);

  @override
  State<AddQuestion> createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor:
            Helper.isDarkMode(context) ? Colors.black : Colors.white,
        appBar: customAppbar(
            title: widget.opeType == "add" ? "إضافة سؤال" : "تعديل السؤال",
            actions: Container()),
        body: Obx(
          () => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: widget.coursesController!.isQuestionLoading.value
                  ? loadingWidget()
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          CustomTextField(
                            initialValue: widget.question,
                            lable: "السؤال",
                            onSave: (value) {
                              widget.question = value;
                            },
                          ),
                          const SizedBox(height: 10.0),
                          CustomTextField(
                            initialValue: widget.res1,
                            lable: "الاجابة الاولي",
                            onSave: (value) {
                              widget.res1 = value;
                            },
                          ),
                          const SizedBox(height: 10.0),
                          CustomTextField(
                            initialValue: widget.res2,
                            lable: "الاجابة الثانية",
                            onSave: (value) {
                              widget.res2 = value;
                            },
                          ),
                          const SizedBox(height: 10.0),
                          CustomTextField(
                            initialValue: widget.res3,
                            lable: "الاجابة الثالثة",
                            onSave: (value) {
                              widget.res3 = value;
                            },
                          ),
                          const SizedBox(height: 10.0),
                          CustomTextField(
                            initialValue: widget.res4,
                            lable: "الاجابة الرابعة",
                            onSave: (value) {
                              widget.res4 = value;
                            },
                          ),
                          const SizedBox(height: 10.0),
                          _resRowWidget(),
                          const SizedBox(height: 25.0),
                          _addButton(),
                        ],
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Column _resRowWidget() {
    return Column(
      children: [
        const CustomText(
            text: "   رقم الإجابة الصحيحة",
            color: Colors.black,
            alignment: Alignment.topRight),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _resItem(value: 1),
            _resItem(value: 2),
            _resItem(value: 3),
            _resItem(value: 4),
          ],
        ),
      ],
    );
  }

  _resItem({int? value}) {
    return Row(
      children: [
        Radio<int>(
            value: value!,
            onChanged: (value) {
              setState(() {
                widget.trueIndex = value;
              });
            },
            groupValue: widget.trueIndex),
        Text(value.toString())
      ],
    );
  }

  CustomButton _addButton() {
    return CustomButton(
        color: const [
          primaryColor,
          Color(0xFF0D47A1),
        ],
        text: widget.opeType == "add" ? "إضافة" : "تعديل",
        onPress: () async {
          _formKey.currentState!.save();

          if (_formKey.currentState!.validate()) {
            await widget.coursesController!.questionOperations(
                type: widget.opeType,
                question: widget.question,
                trueIndex: widget.trueIndex,
                res1: widget.res1,
                res2: widget.res2,
                res3: widget.res3,
                res4: widget.res4,
                videoId: widget.videoId,
                quesId: widget.quesId);
          }
        },
        textColor: Colors.white);
  }
}
