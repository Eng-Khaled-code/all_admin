import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:middleman_all/Controller/data/courses_controller.dart';
import 'package:middleman_all/Models/courses/course_category_model.dart';
import 'package:middleman_all/View/widgets/constant.dart';
import 'package:middleman_all/View/widgets/constant2.dart';
import 'package:middleman_all/View/widgets/custom_button.dart';
import 'package:middleman_all/View/widgets/custom_text.dart';
import 'package:middleman_all/View/widgets/custom_textfield.dart';
import '../../widgets/helper_methods.dart';

class AddCourse extends StatefulWidget {
  const AddCourse({Key? key}) : super(key: key);

  @override
  State<AddCourse> createState() => _AddCourseState();
}

String? courseCategory;
String? courseCategoryId;

class _AddCourseState extends State<AddCourse> {
  final _formKey = GlobalKey<FormState>();

  final CoursesController _coursesController = Get.find();

  String _name = "";

  File? _image;

  String? _desc = "";
  String? _price = "";

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor:
            Helper.isDarkMode(context) ? Colors.black : Colors.white,
        appBar: customAppbar(title: "إضافة كورس", actions: Container()),
        body: Obx(
          () => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: _coursesController.isLoading.value
                  ? loadingWidget()
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          _courseImage(),
                          const SizedBox(height: 10.0),
                          _categoryWidget(),
                          const SizedBox(height: 10.0),
                          CustomTextField(
                            initialValue: _name,
                            lable: "اسم الكورس",
                            onSave: (value) {
                              _name = value;
                            },
                          ),
                          const SizedBox(height: 10.0),
                          CustomTextField(
                            initialValue: _price,
                            lable: "السعر",
                            onSave: (value) {
                              _price = value;
                            },
                          ),
                          const SizedBox(height: 10.0),
                          CustomTextField(
                            initialValue: _desc,
                            lable: "الشرح",
                            onSave: (value) {
                              _desc = value;
                            },
                          ),
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

  CustomButton _addButton() {
    return CustomButton(
        color: const [
          primaryColor,
          Color(0xFF0D47A1),
        ],
        text: "إضافة",
        onPress: () {
          _formKey.currentState!.save();

          if (_formKey.currentState!.validate()) {
            if (_image == null) {
              Fluttertoast.showToast(msg: "يجب ان تختار صورة للكتاب");
            } else {
              _coursesController.courseOperations(
                  operationType: "add",
                  name: _name,
                  desc: _desc,
                  price: _price,
                  categoryId: int.parse(courseCategoryId!),
                  image: _image);
            }
          }
        },
        textColor: Colors.white);
  }

  _courseImage() {
    return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
            height: MediaQuery.of(Get.context!).size.height * 0.3,
            width: double.infinity,
            child: _image != null
                ? InkWell(
                    onTap: () => getImageFile(
                        onFileSelected: (File file) =>
                            setState(() => _image = file)),
                    child: Image.file(_image!, fit: BoxFit.cover))
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlinedButton(
                      onPressed: () => getImageFile(
                          onFileSelected: (File file) =>
                              setState(() => _image = file)),
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(
                              color: Colors.grey.withOpacity(0.5), width: 1)),
                      child: Icon(Icons.add_a_photo,
                          size: 80, color: Colors.grey.withOpacity(.5)),
                    ))));
  }

  Container _categoryWidget() {
    return Container(
        margin: const EdgeInsets.all(10),
        height: 41,
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: _coursesController.coursesCategories.length,
          itemBuilder: (context, position) => _typeItem(
              model: CourseCategoryModel.fromSnapshot(
                  _coursesController.coursesCategories[position])),
        ));
  }

  Widget _typeItem({CourseCategoryModel? model}) {
    bool con = courseCategory == model!.name;
    return InkWell(
        onTap: () {
          setState(() {
            courseCategory = model.name!;
            courseCategoryId = model.id.toString();
          });
        },
        child: Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: con ? primaryColor : Colors.transparent),
            child: CustomText(
              text: model.name!,
              color: con ? Colors.white : Colors.grey,
              alignment: Alignment.topCenter,
            )));
  }

  @override
  void dispose() {
    super.dispose();
    _image = null;
  }
}
