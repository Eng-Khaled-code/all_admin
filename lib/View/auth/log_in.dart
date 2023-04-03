import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:middleman_all/Controller/data/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:middleman_all/View/widgets/constant.dart';
import 'package:middleman_all/View/widgets/custom_button.dart';
import 'package:middleman_all/View/widgets/custom_selection_list.dart';
import 'package:middleman_all/View/widgets/custom_text.dart';
import 'package:middleman_all/View/widgets/custom_textfield.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utilities/strings.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final _formKey = GlobalKey<FormState>();

  String _txtUsername = "";

  String _txtPassword = "";

  final UserController _userController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    ClipRRect(
                        borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20)),
                        child: Image.asset(
                          "assets/images/icon.jpg",
                          fit: BoxFit.fill,
                        )),
                    Obx(() => _userController.page == "log_in".obs
                        ? dataColumn()
                        : loading())
                  ],
                )),
          ),
        ),
      ),
    );
  }

  Padding loading() {
    return Padding(
      padding: const EdgeInsets.only(top: 100.0, left: 10, right: 10),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _userController.isLoading.value ? loadingWidget() : Container(),
            const SizedBox(
              height: 20,
            ),
            InkWell(
                onTap: () {
                  if (_userController.splachError != null) {
                    _userController.openMyHomePage(
                        email: "",
                        password: "",
                        type: "load",
                        userId: "${Strings.globalUserId}",
                        userType: "");
                  }
                },
                child: _userController.isLoading.value
                    ? Container()
                    : CustomText(
                        text: _userController.splachError == null
                            ? "إنتظر لحظة"
                            : (_userController.splachError!.value +
                                " \n إضغط للتحديث"),
                        maxLine: 4,
                      ))
          ]),
    );
  }

  Widget dataColumn() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Column(
        children: [
          _userTypesList(),
          const SizedBox(height: 15.0),
          CustomTextField(
            initialValue: _txtUsername,
            lable: "الإيميل",
            onSave: (value) {
              _txtUsername = value;
            },
          ),
          const SizedBox(height: 15.0),
          CustomTextField(
            initialValue: _txtPassword,
            lable: "كلمة المرور",
            onSave: (value) {
              _txtPassword = value;
            },
          ),
          const SizedBox(height: 15.0),
          __buildForgetPasswordWidget(),
          const SizedBox(height: 15.0),
          CustomButton(
              color: const [
                primaryColor,
                Color(0xFF0D47A1),
              ],
              text: "تسجيل الدخول",
              onPress: () {
                _formKey.currentState!.save();
                if (_formKey.currentState!.validate()) {
                  String _userType = Strings.userType == "عقارات"
                      ? "middleman"
                      : Strings.userType == "تسوق"
                          ? "ecommerce"
                          : Strings.userType == "اطباء"
                              ? "doctor"
                              : Strings.userType == "مسئول"
                                  ? "admin"
                                  : "course_admin";
                  _userController.openMyHomePage(
                      email: _txtUsername,
                      password: _txtPassword,
                      type: "log_in",
                      userId: "",
                      userType: _userType);
                }
              },
              textColor: Colors.white),
          const SizedBox(height: 30.0),
          __buildConnectUsWidget()
        ],
      ),
    );
  }

  Widget __buildForgetPasswordWidget() {
    return Container(
      alignment: Alignment.centerRight,
      child: TextButton(
        child: const CustomText(
          text: "هل نسيت كلمة المرور؟",
          fontSize: 14,
        ),
        onPressed: () {
          //goTo(context: context,to:ForgetPassword());
        },
      ),
    );
  }

  Widget __buildConnectUsWidget() {
    return TextButton(
      child: const CustomText(
        text: "للتواصل إضغط هنا",
        fontSize: 16,
      ),
      onPressed: () async => await launchUrl(Uri(scheme: "tel://01159245717")),
    );
  }

  _userTypesList() {
    return CustomSelectionList(
        list: Strings.userTypesList,
        listType: "userType",
        onTap: (String? text) {
          setState(() => Strings.userType = text!);
        });
  }
}
