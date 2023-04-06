import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:middleman_all/Controller/data/admin_controller.dart';
import 'package:middleman_all/View/widgets/constant.dart';
import 'package:middleman_all/View/widgets/constant2.dart';
import 'package:middleman_all/View/widgets/custom_button.dart';
import 'package:middleman_all/View/widgets/custom_textfield.dart';

import '../../../widgets/helper_methods.dart';

class AddBook extends StatefulWidget {
  const AddBook({Key? key}) : super(key: key);

  @override
  State<AddBook> createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  final _formKey = GlobalKey<FormState>();

  final AdminController _adminController = Get.find();

  String _name = "";

  File? _image;

  File? _book;
  final TextEditingController _bookFileName = TextEditingController(text: "");
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor:
            Helper.isDarkMode(context) ? Colors.black : Colors.white,
        appBar: customAppbar(title: "إضافة كتاب جديد", actions: Container()),
        body: Obx(
          () => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: _adminController.isLoading.value
                  ? loadingWidget()
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          _bookImage(),
                          const SizedBox(height: 10.0),
                          _bookFileWidget(),
                          const SizedBox(height: 10.0),
                          CustomTextField(
                            initialValue: _name,
                            lable: "اسم الكتاب",
                            onSave: (value) {
                              _name = value;
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
              _adminController.operations(
                  moduleName: "books",
                  operationType: "add",
                  usernameOrCategory: _name,
                  bookFile: _book,
                  imageFile: _image);
            }
          }
        },
        textColor: Colors.white);
  }

  _bookImage() {
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

  TextFormField _bookFileWidget() {
    return TextFormField(
      onTap: () => getBookFile(
          onFileSelected: (File file) => setState(() {
                _book = file;
                _bookFileName.text = file.path.split('/').last;
              })),
      readOnly: true,
      controller: _bookFileName,
      validator: (String? value) {
        if (value!.isEmpty) {
          return "يجب ان تختار ملف الكتاب";
        }
      },
      decoration: InputDecoration(
        prefixIcon: const Padding(
          padding: EdgeInsets.only(right: 10.0),
          child: Icon(Icons.attach_file),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        labelText: "ملف الكتاب",
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _image = null;
    _book = null;
  }
}
