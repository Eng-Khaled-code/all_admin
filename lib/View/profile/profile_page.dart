import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:middleman_all/Controller/data/user_controller.dart';
import 'package:middleman_all/View/widgets/constant.dart';
import 'package:middleman_all/View/widgets/constant2.dart';
import 'package:middleman_all/View/widgets/custom_text.dart';
import '../utilities/strings.dart';
import '../widgets/helper_methods.dart';
import 'custom_dropdown_button.dart';
import 'profile_constant.dart';

// ignore: must_be_immutable
class ProfilePage extends StatelessWidget {
  final UserController _userController = Get.find();

  ProfilePage({Key? key}) : super(key: key);

  String? _userType;
  @override
  Widget build(BuildContext context) {
    _userType = Strings.userInformation!.value.userType;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar:
            customAppbar(title: "تحديث البيانات الشخصية", actions: Container()),
        backgroundColor:
            Helper.isDarkMode(context) ? Colors.black : Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Obx(
              () => Column(
                children: <Widget>[
                  _imageWidget(),
                  const SizedBox(height: 4.0),
                  _topUsernameWidget(),
                  _userType == "doctor" ? _topAboutWidget() : Container(),
                  CustomText(
                    text: "${Strings.userInformation!.value.email}",
                  ),
                  _userType != "full_access" ? _rateWidget() : Container(),
                  _userType != "full_access"
                      ? _dataWidget(context)
                      : Container(),
                  _userType != "full_access"
                      ? _typeWidgets(context)
                      : Container(),
                  _phoneWidget(context),
                  Strings.userInformation!.value.userType == "doctor"
                      ? _workDaysWidget(context)
                      : Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _phoneWidget(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
          color:
              Helper.isDarkMode(context) ? Get.theme.cardColor : primaryColor,
          borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      margin: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const CustomText(
                text: "ارقام التليفون",
                color: Colors.white,
                alignment: Alignment.centerRight,
              ),
              const SizedBox(width: 15),
              IconButton(
                icon: const Icon(
                  Icons.add_ic_call_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  myCustomDialog(
                      type: "phone",
                      addOrUpdateOrDelete: "add",
                      fieldValue: "",
                      fieldId: "");
                },
              )
            ],
          ),
          _userController.isPhoneLoading.value
              ? Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  width: 25,
                  height: 25,
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 0.7,
                  ))
              : Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  height: 30,
                  child: _userController.userPhones.isEmpty
                      ? const CustomText(
                          text: "لا يوجد",
                          color: Colors.white,
                          alignment: Alignment.centerRight,
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _userController.userPhones.length,
                          itemBuilder: (context, position) => InkWell(
                            onTap: () {
                              myCustomDialog(
                                  type: "phone",
                                  addOrUpdateOrDelete: "update",
                                  fieldValue: _userController
                                      .userPhones[position]["number"],
                                  fieldId: _userController.userPhones[position]
                                          ["phone_id"]
                                      .toString());
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              padding: const EdgeInsets.only(left: 10),
                              height: 30,
                              decoration: BoxDecoration(
                                  color: Helper.isDarkMode(context)
                                      ? Get.theme.cardColor
                                      : primaryColor,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.white)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.red,
                                    ),
                                    onTap: () {
                                      myCustomDialog(
                                          type: "phone",
                                          addOrUpdateOrDelete: "delete",
                                          fieldValue: _userController
                                              .userPhones[position]["number"],
                                          fieldId: _userController
                                              .userPhones[position]["phone_id"]
                                              .toString());
                                    },
                                  ),
                                  CustomText(
                                    text: _userController.userPhones[position]
                                        ["number"],
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                )
        ],
      ),
    );
  }

  Row _workDaysTopRow(BuildContext context) {
    return Row(
      children: [
        const CustomText(
          text: "ايام العمل",
          color: Colors.white,
          alignment: Alignment.centerRight,
        ),
        const SizedBox(width: 15),
        IconButton(
          icon: const Icon(
            Icons.calendar_today,
            color: Colors.white,
          ),
          onPressed: () {
            _showWorkOperationDialog(
                context: context, type: "إضافة", from: "", to: "", dayId: 0);
          },
        )
      ],
    );
  }

  Widget _workDaysBody(BuildContext context) {
    return _userController.isWorkDaysLoading.value
        ? prfileLoadingWidget(Colors.white)
        : Container(
            margin: const EdgeInsets.only(bottom: 10),
            height: 180,
            child: _userController.userWorkDays.isEmpty
                ? const CustomText(
                    text: "لا يوجد",
                    color: Colors.white,
                    alignment: Alignment.centerRight,
                  )
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _userController.userWorkDays.length,
                    itemBuilder: (context, position) => _item(
                        day: _userController.userWorkDays[position]["day"],
                        from: _userController.userWorkDays[position]
                            ["start_time"],
                        to: _userController.userWorkDays[position]["end_time"],
                        itemId: _userController.userWorkDays[position]["id"],
                        context: context),
                  ));
  }

  Widget _workDaysWidget(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
          color:
              Helper.isDarkMode(context) ? Get.theme.cardColor : primaryColor,
          borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      margin: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [_workDaysTopRow(context), _workDaysBody(context)],
      ),
    );
  }

  Widget _item(
      {String? day,
      String? from,
      String? to,
      int? itemId,
      BuildContext? context}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(10.0),
        elevation: 1,
        child: Container(
          padding: const EdgeInsets.only(top: 8.0),
          margin: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
              border: Border.all(color: primaryColor),
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: day!,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              CustomText(
                text: "من " +
                    from!.substring(0, 5) +
                    "\n إلي " +
                    to!.substring(0, 5),
                color: Colors.grey,
                fontSize: 14,
              ),
              _operationRow(
                  context: context, from: from, to: to, itemId: itemId)
            ],
          ),
        ),
      ),
    );
  }

  Widget _operationRow(
      {BuildContext? context, String? from, String? to, int? itemId}) {
    return operationRow(
        () => _showWorkOperationDialog(
            context: context,
            type: "تحديث",
            from: from!.substring(0, 5),
            to: to!.substring(0, 5),
            dayId: itemId!), () async {
      Get.back();
      await _userController.workDaysOperations(
          type: "delete", dayId: itemId, startTime: "", endTime: "");
    }, true);
  }

  Widget _dataWidget(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
          color:
              Helper.isDarkMode(context) ? Get.theme.cardColor : primaryColor,
          borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            children: [
              const CustomText(
                text: "الاسم     ",
                color: Colors.white,
                alignment: Alignment.centerRight,
              ),
              const SizedBox(width: 15),
              _userController.isUsernameLoading.value
                  ? prfileLoadingWidget(Colors.white)
                  : _nameAddressField(
                      nameOrAddress: "username",
                      value: Strings.userInformation!.value.userName!,
                      context: context)
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const CustomText(
                text: "العنوان   ",
                color: Colors.white,
                alignment: Alignment.centerRight,
              ),
              const SizedBox(width: 15),
              _userController.isAddressLoading.value
                  ? prfileLoadingWidget(Colors.white)
                  : _nameAddressField(
                      nameOrAddress: "address",
                      value: Strings.userInformation!.value.address!,
                      context: context)
            ],
          ),
          const SizedBox(height: 10),
          _userController.isAboutDoctor.value
              ? Row(
                  children: [
                    const CustomText(
                      text: "التخصص",
                      color: Colors.white,
                      alignment: Alignment.centerRight,
                    ),
                    const SizedBox(width: 15),
                    _userController.isAboutDoctor.value
                        ? prfileLoadingWidget(Colors.white)
                        : _nameAddressField(
                            nameOrAddress: "about_doctor",
                            value: Strings.userInformation!.value.aboutDoctor!,
                            context: context)
                  ],
                )
              : Container()
        ],
      ),
    );
  }

  Widget _nameAddressField(
      {String? nameOrAddress, String? value, BuildContext? context}) {
    return InkWell(
      onTap: () {
        myCustomDialog(
            type: nameOrAddress,
            addOrUpdateOrDelete: "update",
            fieldValue: value,
            fieldId: "");
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.only(left: 10, right: 10),
        height: 30,
        decoration: BoxDecoration(
            color: Helper.isDarkMode(context!)
                ? Get.theme.cardColor
                : primaryColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white)),
        child: CustomText(
          text: value!.length > 30 ? value.substring(0, 30) : value,
          maxLine: 1,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _rateWidget() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          const Text("التقييم : "),
          const Text("5/"),
          CustomText(
              text: Strings.userInformation!.value.ratingValue!,
              fontSize: 30,
              fontWeight: FontWeight.bold),
          const SizedBox(
            width: 15,
          ),
          RatingBar.builder(
            initialRating:
                double.parse(Strings.userInformation!.value.ratingValue!),
            ignoreGestures: true,
            itemSize: 25,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {},
          )
        ],
      ),
    );
  }

  Widget _typeWidgets(BuildContext context) => Container(
      decoration: BoxDecoration(
          color:
              Helper.isDarkMode(context) ? Get.theme.cardColor : primaryColor,
          borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
      margin: const EdgeInsets.all(5),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            text: "الدول المستهدفة",
            alignment: Alignment.centerRight,
            color: Colors.white,
          ),
          _userController.isCountryLoading.value
              ? Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  width: 25,
                  height: 25,
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 0.7,
                  ))
              : SizedBox(
                  height: 50,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: countries.length,
                    itemBuilder: (context, position) {
                      Color selectColor = Colors.transparent;
                      if (position < _userController.userCountries.length) {
                        selectColor = countries.contains(_userController
                                .userCountries[position]["country"])
                            ? Colors.blueGrey
                            : Colors.transparent;
                      }

                      return InkWell(
                          onTap: () {
                            if (_userController.userCountries.length > 1 &&
                                selectColor != Colors.blueGrey) {
                              Fluttertoast.showToast(
                                  msg: "لا يمكنك استهداف اكثر من دولتين");
                            } else if (_userController.userCountries.length ==
                                    1 &&
                                selectColor == Colors.blueGrey) {
                              Fluttertoast.showToast(
                                  msg: "يجب ان تستهدف دولة واحدة علي الاقل");
                            } else {
                              selectColor == Colors.blueGrey
                                  ? _userController.countryOperations(
                                      type: "delete",
                                      countryId: _userController
                                          .userCountries[position]["country_id"]
                                          .toString(),
                                      country: "")
                                  : _userController.countryOperations(
                                      type: "add",
                                      countryId: "",
                                      country: countries[position]);
                            }
                          },
                          child: _countryItem(
                              text: countries[position],
                              selectionColor: selectColor));
                    },
                  ),
                ),
        ],
      ));

  Widget _countryItem({String? text, Color? selectionColor}) => Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: selectionColor,
          border: Border.all(color: Colors.white)),
      padding: const EdgeInsets.all(5),
      child: CustomText(text: text!, color: Colors.white));

  Widget _imageWidget() {
    String imageUrl = Strings.userImagesDirectoryUrl +
        Strings.userInformation!.value.imageUrl!;
    return InkWell(
        onTap: () {
          _userType == "full_access" ? () {} : _uploadImage();
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(110),
          child: Container(
            width: 180,
            height: 180,
            decoration: const BoxDecoration(color: Colors.grey),
            child: _userController.isImageLoading.value
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                : Image.network(
                    Strings.userInformation!.value.imageUrl == "" ||
                            Strings.userInformation!.value.imageUrl == null
                        ? Strings.appIconUrl
                        : imageUrl,
                    fit: BoxFit.cover),
          ),
        ));
  }

  void _uploadImage() {
    getImageFile(onFileSelected: (File file) {
      String addOrUpdate = Strings.userInformation!.value.imageUrl == "" ||
              Strings.userInformation!.value.imageUrl == null
          ? "add"
          : "update";
      _userController.updateImage(image: file, addOrUpdatePhoto: addOrUpdate);
    });
  }

  Widget _topUsernameWidget() {
    return _userController.isUsernameLoading.value
        ? prfileLoadingWidget(primaryColor)
        : CustomText(
            text: "${Strings.userInformation!.value.userName}",
            fontSize: 25,
            fontWeight: FontWeight.bold,
          );
  }

  Widget _topAboutWidget() {
    return _userController.isAboutDoctor.value
        ? prfileLoadingWidget(primaryColor)
        : CustomText(
            text: "${Strings.userInformation!.value.aboutDoctor}",
            fontWeight: FontWeight.bold,
          );
  }

  void _showWorkOperationDialog(
      {BuildContext? context,
      String? type,
      String? from,
      String? to,
      int? dayId}) {
    final _formKey = GlobalKey<FormState>();
    TextEditingController toCon = TextEditingController(text: to);
    TextEditingController fromCon = TextEditingController(text: from);
    Get.dialog(
      Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            scrollable: true,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: Text(type!),
            content: Form(
              key: _formKey,
              child: Column(
                children: [
                  const CustomDropdownButton(),
                  TextFormField(
                    onTap: () => _showDatePacker(fromCon, context!),
                    controller: fromCon,
                    readOnly: true,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "موعد البداية";
                      }
                    },
                    decoration: const InputDecoration(
                        labelText: "من", labelStyle: TextStyle(fontSize: 13)),
                  ),
                  TextFormField(
                    onTap: () => _showDatePacker(toCon, context!),
                    controller: toCon,
                    readOnly: true,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "موعد الانتهاء";
                      }
                    },
                    decoration: const InputDecoration(
                        labelText: "الي", labelStyle: TextStyle(fontSize: 13)),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      Get.back();
                      await _userController.workDaysOperations(
                          type: type == "تحديث" ? "update" : "add",
                          dayId: dayId,
                          startTime: fromCon.text,
                          endTime: toCon.text);
                    }
                  },
                  child: Text(type, style: const TextStyle(fontSize: 13))),
              TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text("إلغاء",
                      style: TextStyle(fontSize: 13, color: Colors.red))),
            ],
          )),
      barrierDismissible: false,
    );
  }

  void _showDatePacker(
      TextEditingController timeController, BuildContext context) async {
    TimeOfDay _startTime = timeController.text == ""
        ? TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute)
        : TimeOfDay(
            hour: int.parse(timeController.text.split(":")[0]),
            minute: int.parse(timeController.text.split(":")[1]));

    final TimeOfDay? picked =
        await showTimePicker(initialTime: _startTime, context: context);

    if (picked != null) {
      timeController.text =
          picked.hour.toString() + ":" + picked.minute.toString();
    }
  }
}
