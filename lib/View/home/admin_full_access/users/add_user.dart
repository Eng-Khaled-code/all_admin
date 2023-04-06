import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:middleman_all/Controller/data/admin_controller.dart';
import 'package:middleman_all/View/profile/profile_constant.dart';
import 'package:middleman_all/View/widgets/constant.dart';
import 'package:middleman_all/View/widgets/custom_button.dart';
import 'package:middleman_all/View/widgets/custom_selection_list.dart';
import 'package:middleman_all/View/widgets/custom_textfield.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../../../utilities/strings.dart';
import '../../../widgets/custom_text.dart';
import '../../../widgets/helper_methods.dart';
import 'open_google_map.dart';

class AddUser extends StatefulWidget {
  const AddUser({Key? key}) : super(key: key);

  @override
  State<AddUser> createState() => _AddUserState();
}

String selectedCountry = "مصر";

class _AddUserState extends State<AddUser> {
  final _formKey = GlobalKey<FormState>();
  final AdminController _adminController = Get.find();

  String name = "";
  String email = "";
  String password = "";
  String phone = "";

  Color addressTextColor = primaryColor;
  @override
  void dispose() {
    super.dispose();
    _adminController.setMapData(lat: 0.0, long: 0.0, address: "");
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor:
            Helper.isDarkMode(context) ? Colors.black : Colors.white,
        appBar: customAppbar(title: "إضافة مستخدم جديد", actions: Container()),
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
                          _userTypesWidget(),
                          CustomTextField(
                            initialValue: name,
                            lable: "الاسم",
                            onSave: (value) {
                              name = value;
                            },
                          ),
                          const SizedBox(height: 10.0),
                          CustomTextField(
                            initialValue: email,
                            lable: "الإيميل",
                            onSave: (value) {
                              email = value;
                            },
                          ),
                          const SizedBox(height: 10.0),
                          CustomTextField(
                            initialValue: password,
                            lable: "كلمة المرور",
                            onSave: (value) {
                              password = value;
                            },
                          ),
                          const SizedBox(height: 10.0),
                          CustomTextField(
                            initialValue: phone,
                            lable: "رقم التليفون",
                            onSave: (value) {
                              phone = value;
                            },
                          ),
                          const SizedBox(height: 10.0),
                          GestureDetector(
                              onTap: () async {
                                if (_adminController.rxAddress.value == "") {
                                  Position? _currentPosition =
                                      await Geolocator.getCurrentPosition();

                                  List<Placemark> places =
                                      await placemarkFromCoordinates(
                                          _currentPosition.latitude,
                                          _currentPosition.longitude);
                                  String title = places.first.country! +
                                      "-" +
                                      places.first.administrativeArea! +
                                      "-" +
                                      places.first.locality!;
                                  _adminController.setMapData(
                                      lat: _currentPosition.latitude,
                                      long: _currentPosition.longitude,
                                      address: title);
                                  await openMyMap(
                                      tapType: "get_address",
                                      lat: _currentPosition.latitude,
                                      long: _currentPosition.longitude,
                                      title: title);
                                } else {
                                  await openMyMap(
                                      tapType: "get_address",
                                      lat: _adminController.rxLat.value,
                                      long: _adminController.rxLong.value,
                                      title: _adminController.rxAddress.value);
                                }
                              },
                              child: CustomText(
                                  color: _adminController
                                          .rxAddress.value.isNotEmpty
                                      ? primaryColor
                                      : addressTextColor,
                                  fontSize: 16,
                                  text: _adminController.rxAddress.value == ""
                                      ? "اختر العنوان"
                                      : _adminController.rxAddress.value)),
                          const SizedBox(height: 10.0),
                          const Align(
                              alignment: Alignment.centerRight,
                              child: Text("   الدولة المستهدفة")),
                          _countryWidget(),
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

  CustomSelectionList _userTypesWidget() {
    return CustomSelectionList(
        list: Strings.userTypesList,
        listType: "userType",
        onTap: (String? text) {
          setState(() => Strings.userType = text!);
        });
  }

  CustomButton _addButton() {
    return CustomButton(
        color: const [
          primaryColor,
          Color(0xFF0D47A1),
        ],
        text: "إضافة",
        onPress: () async {
          _formKey.currentState!.save();
          if (_adminController.rxAddress.value == "") {
            Get.snackbar("خطا", "يجب ان تدخل العنوان",
                snackPosition: SnackPosition.BOTTOM);
          }

          if (_formKey.currentState!.validate() &&
              _adminController.rxAddress.value != "") {
            await _adminController.operations(
                moduleName: "users",
                operationType: "add",
                addressOrCategoryDescription: _adminController.rxAddress.value,
                passwordOrStopReason: password,
                userType: Strings.userType == "محاضر"
                    ? "course_admin"
                    : Strings.userType == "اطباء"
                        ? "doctor"
                        : Strings.userType == "تسوق"
                            ? "ecommerce"
                            : Strings.userType == "مسئول"
                                ? "admin"
                                : "middleman",
                phoneOrMissedType: phone,
                usernameOrCategory: name,
                userStatusOrClinicStatus:
                    Strings.userType == "اطباء" ? "1" : "0",
                countryImageName: selectedCountry,
                emailOrAdminToken: email,
                lat: _adminController.rxLat.value.toString(),
                long: _adminController.rxLong.value.toString());
          }
        },
        textColor: Colors.white);
  }

  CustomSelectionList _countryWidget() {
    return CustomSelectionList(
        list: countries,
        listType: "country",
        onTap: (String? text) {
          setState(() => selectedCountry = text!);
        });
  }
}
