// ignore_for_file: prefer_const_constructors_in_immutables
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:middleman_all/Controller/data/admin_controller.dart';
import 'package:middleman_all/Models/users/user_model.dart';
import 'package:middleman_all/View/widgets/constant.dart';
import 'package:middleman_all/View/widgets/constant2.dart';
import 'package:middleman_all/View/widgets/custom_text.dart';

import 'open_google_map.dart';

class UserCard extends StatelessWidget {
  UserCard({Key? key, this.model, this.adminController}) : super(key: key);
  final UserModel? model;
  final AdminController? adminController;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      decoration: customDecoration(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _topRow(),
          _dataWidget(),
        ],
      ),
    );
  }

  _topRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        adminProfileWidget(
            name: model!.userName,
            image: model!.imageUrl,
            date: model!.createdAt),
        _topLeftActionRow(),
      ],
    );
  }

  Padding _dataWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          CustomText(
            text: model!.email!,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          model!.userType == "admin" || model!.userType == "user"
              ? Container()
              : _rateWidget(),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
                onTap: () async {
                  await openMyMap(
                      tapType: "show_map",
                      lat: double.parse(model!.lat!),
                      long: double.parse(model!.long!),
                      title: model!.address);
                },
                child: CustomText(
                  text:
                      "العنوان : ${model!.address}${model!.userType == "doctor" ? ("\n" + model!.aboutDoctor!) : ""}",
                  color: Colors.grey,
                  alignment: Alignment.centerRight,
                  textAlign: TextAlign.right,
                )),
          ),
          phonesWidget(phones: model!.phones, color: Colors.white),
          phonesWidget(
              phones: model!.coutries, color: Colors.white, type: "country"),
        ],
      ),
    );
  }

  RatingBar _rateWidget() {
    return RatingBar.builder(
        initialRating: double.parse(model!.ratingValue!),
        ignoreGestures: true,
        itemSize: 25,
        direction: Axis.horizontal,
        allowHalfRating: true,
        itemCount: 5,
        onRatingUpdate: (value) {},
        itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ));
  }

  Row _topLeftActionRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
            onPressed: () => _showActionDialogDialog(),
            icon: Icon(model!.userStatus == 0
                ? Icons.visibility_off
                : Icons.visibility)),
        GestureDetector(
            onTapDown: (details) =>
                model!.userType == "admin" || model!.userType == "user"
                    ? () {}
                    : _showPopUpMenue(details),
            child: coloredContainer(
                text: model!.userType == "course_admin"
                    ? "محاضر"
                    : model!.userType == "admin"
                        ? "مسئول"
                        : model!.userType == "middleman"
                            ? "عقارات"
                            : model!.userType == "ecommerce"
                                ? "تسوق"
                                : model!.userType == "doctor"
                                    ? "طبيب"
                                    : "مستخدم"))
      ],
    );
  }

  void _showActionDialogDialog() {
    showDialogFor(
        contentText: model!.userStatus == 1
            ? "هل تريد إيقاف حساب هذا المستخدم"
            : "هل تريد تشغيل حساب هذا المستخدم",
        title: "تأكيد",
        onPress: () async {
          Get.back();
          await adminController!.operations(
            id: model!.userId,
            operationType: "change status",
            moduleName: "users",
            userStatusOrClinicStatus: model!.userStatus == 0 ? "1" : "0",
          );
        });
  }

  _showPopUpMenue(TapDownDetails details) {
    final List<String> _userTypes = ["عقارات", "تسوق", "اطباء"];
    String _userType = model!.userType == "middleman"
        ? "عقارات"
        : model!.userType == "ecommerce"
            ? "تسوق"
            : "اطباء";
    showMenu(
        context: Get.context!,
        position: RelativeRect.fromLTRB(
          details.globalPosition.dx,
          details.globalPosition.dy,
          details.globalPosition.dx,
          details.globalPosition.dy,
        ),
        elevation: 3.2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        items: _userTypes.map((String choice) {
          return PopupMenuItem(
            value: choice,
            onTap: () async {
              if (_userType == choice) {
                Fluttertoast.showToast(msg: "هذا هو نوع المستخدم الحالي");
              } else {
                await adminController!.operations(
                  moduleName: "users",
                  userType: choice == "عقارات"
                      ? "middleman"
                      : choice == "تسوق"
                          ? "ecommerce"
                          : "doctor",
                  id: model!.userId,
                  operationType: "change user type",
                );
              }
            },
            child: Text(
              choice,
              style: const TextStyle(fontSize: 12),
            ),
          );
        }).toList());
  }
}
