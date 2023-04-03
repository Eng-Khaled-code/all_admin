// ignore_for_file: prefer_const_constructors_in_immutables
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:middleman_all/Controller/data/admin_controller.dart';
import 'package:middleman_all/Models/mps/missed_model.dart';
import 'package:middleman_all/View/widgets/constant.dart';
import 'package:middleman_all/View/widgets/constant2.dart';
import 'package:middleman_all/View/widgets/custom_text.dart';

class MissedCard extends StatelessWidget {
  MissedCard({Key? key, this.model, this.adminController}) : super(key: key);
  final MissedModel? model;
  final AdminController? adminController;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      decoration: customDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _topRow(context),
          imageWidget(image: model!.image!),
          _dataWidget(),
          model!.missedOrFound == "فقد" && model!.missedStatus == "مقبول"
              ? _suggestionsWidget()
              : Container()
        ],
      ),
    );
  }

  _topRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        adminProfileWidget(
            name: model!.username,
            image: model!.userImage,
            date: model!.createdAt),
        model!.missedStatus == "انتظار"
            ? _missedActionStatus()
            : model!.missedStatus == "مقبول" && model!.missedOrFound == "فقد"
                ? _suggestWidget()
                : Container()
      ],
    );
  }

  _dataWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          CustomText(
            text: model!.name!,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          CustomText(
            text:
                "النوع : ${model!.sex}   ||  العمر:  ${model!.age}   ||   لون العين : ${model!.eyeColor}   ||   لون البشرة :${model!.faceColor}   ||    لون الشعر:  ${model!.hairColor}",
            color: Colors.grey,
            alignment: Alignment.centerRight,
            textAlign: TextAlign.right,
          ),
          CustomText(
            text: "اخر مكان وجد به : ${model!.lastPlace}",
            color: Colors.grey,
            alignment: Alignment.centerRight,
            maxLine: 3,
            textAlign: TextAlign.right,
          ),
          CustomText(
            text:
                model!.missedOrFound == "فقد" && model!.missedStatus == "مقبول"
                    ? "الاقتراحات"
                    : model!.missedStatus == "مرفوض"
                        ? ("سبب الرفض : " + model!.refuseReason!)
                        : "",
            color: Colors.grey,
            alignment: Alignment.centerRight,
          ),
        ],
      ),
    );
  }

  _suggestionsWidget() {
    return model!.missedOrFound == "فقد" && model!.suggestions!.isEmpty
        ? const Padding(
            padding: EdgeInsets.all(8.0),
            child: CustomText(
              text: "لا توجد إقتراحات",
              color: Colors.grey,
              alignment: Alignment.centerRight,
            ),
          )
        : model!.missedOrFound == "فقد" && model!.suggestions!.isNotEmpty
            ? SizedBox(
                height: 250,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: model!.suggestions!.length,
                    itemBuilder: (context, position) {
                      return Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.all(5),
                        width: 250,
                        decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: [
                            _suggTopRow(position),
                            const SizedBox(height: 10),
                            imageWidget(
                                image: model!.suggestions![position]
                                    ['f_missed_image'],
                                height: 170),
                          ],
                        ),
                      );
                    }),
              )
            : Container();
  }

  _suggTopRow(int position) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        adminProfileWidget(
            name: model!.suggestions![position]['f_username'],
            image: model!.suggestions![position]['f_user_image'],
            date: model!.suggestions![position]['date']),
        model!.suggestions![position]['suggest_status'] == "identical"
            ? const Icon(Icons.check, color: Colors.white)
            : Container()
      ],
    );
  }

  Row _missedActionStatus() {
    return Row(
      children: [
        IconButton(
          onPressed: () => _showAcceptDialog(),
          icon: const Icon(
            Icons.check,
            color: Colors.blue,
          ),
        ),
        IconButton(
          onPressed: () => _showReasonDialog(),
          icon: const Icon(
            Icons.close,
            color: Colors.red,
          ),
        )
      ],
    );
  }

  void _showReasonDialog() {
    String _missedOrFoundEnglish =
        model!.missedOrFound == "فقد" ? "missed" : "found";
    showReasonDialog(
        title: "هل تريد رفض الطلب",
        onPress: (comingReason) async {
          Get.back();
          await adminController!.operations(
              id: model!.id,
              operationType: "refuse",
              moduleName: "mps",
              userStatusOrClinicStatus: "مرفوض",
              passwordOrStopReason: comingReason,
              emailOrAdminToken: model!.userToken,
              phoneOrMissedType: _missedOrFoundEnglish,
              countryImageName: model!.image!.split("/").last);
        });
  }

  void _showAcceptDialog() {
    String _missedOrFoundEnglish =
        model!.missedOrFound == "فقد" ? "missed" : "found";
    showDialogFor(
        contentText: "هل تريد الموافقة علي الطلب",
        title: "تأكيد",
        onPress: () async {
          Get.back();
          await adminController!.operations(
              id: model!.id,
              operationType: "accept",
              passwordOrStopReason: "",
              moduleName: "mps",
              userStatusOrClinicStatus: "مقبول",
              emailOrAdminToken: model!.userToken,
              phoneOrMissedType: _missedOrFoundEnglish,
              countryImageName: model!.image!.split("/").last);
        });
  }

  IconButton _suggestWidget() {
    return IconButton(
      onPressed: () => showDialogFor(
          title: "بحث",
          contentText: "هل تريد بدأ البحث عن هذا الشخص",
          onPress: () async {
            Get.back();
            await adminController!.operations(
                moduleName: "mps",
                id: model!.id,
                operationType: "add suggestion",
                countryImageName: model!.image!.split("/").last);
          }),
      icon: const Icon(
        Icons.search,
        color: Colors.blue,
      ),
    );
  }
}
