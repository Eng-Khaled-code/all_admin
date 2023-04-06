import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:middleman_all/Controller/data/admin_controller.dart';
import 'package:middleman_all/Controller/data/middleman_controller.dart';
import 'package:middleman_all/Models/middleman/discuss_model.dart';
import 'package:middleman_all/Models/middleman/place_model.dart';
import 'package:middleman_all/View/home/home_files/home_page.dart';
import 'package:middleman_all/View/widgets/constant.dart';
import 'package:middleman_all/View/widgets/constant2.dart';
import 'package:middleman_all/View/widgets/custom_text.dart';
import '../user_operations.dart';

// ignore: must_be_immutable
class PlaceCard extends StatelessWidget {
  final PlaceModel? model;
  final String? type;
  late MiddlemanController? middlemanController;
  late AdminController? adminController;
  PlaceCard(
      {Key? key,
      this.model,
      this.type = "user",
      this.adminController,
      this.middlemanController})
      : super(key: key);

  String? roufNum, myType;

  @override
  Widget build(BuildContext context) {
    roufNum = model!.type == "flat"
        ? "رقم الطابق : "
        : model!.type == "block"
            ? "عدد الطوابق"
            : "";
    myType = model!.type == "flat"
        ? "شقة"
        : model!.type == "block"
            ? "عمارة"
            : model!.type == "ground"
                ? "قطعة ارض"
                : "محل";
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      decoration: customDecoration(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [_topRow(), _stopWidget(), _dataWidget(), _bottomRow()],
      ),
    );
  }

  Row _topRow() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: type == "user"
            ? [
                coloredContainer(text: myType),
                Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: customDateWidget(date: model!.date)),
                _operationRow(),
              ]
            : [
                adminProfileWidget(
                  name: model!.adminName,
                  image: model!.adminImage,
                  opertionType:
                      "${model!.operation} ${model!.type == "flat" ? "شقة" : model!.type == "ground" ? "قطعة ارض" : model!.type == "block" ? "عمارة" : "محل"}",
                  date: model!.date,
                ),
                _placeAdminStatus()
              ]);
  }

  Widget _placeAdminStatus() {
    return IconButton(
        onPressed: () => model!.mainAdminStatus == 1
            ? _showReasonDialog()
            : _showAcceptDialog(),
        icon: Icon(model!.mainAdminStatus == 0
            ? Icons.visibility_off
            : Icons.visibility));
  }

  void _showReasonDialog() {
    showReasonDialog(
        title: "هل تريد إيقاف عرض هذا العقار",
        onPress: (comingReason) async {
          Get.back();
          await adminController!.operations(
            id: model!.placeId,
            operationType: "change status",
            moduleName: "middleman",
            userStatusOrClinicStatus: "0",
            passwordOrStopReason: comingReason,
            emailOrAdminToken: model!.adminToken,
          );
        });
  }

  void _showAcceptDialog() {
    showDialogFor(
        contentText: "هل تريد إعادة عرض هذا العقار",
        title: "تأكيد",
        onPress: () async {
          Get.back();
          await adminController!.operations(
            id: model!.placeId,
            operationType: "change status",
            passwordOrStopReason: "",
            moduleName: "middleman",
            userStatusOrClinicStatus: "1",
            emailOrAdminToken: model!.adminToken,
          );
        });
  }

  Widget _operationRow() {
    return operationRow(() {
      currentIndex = 2;
      Get.offAll(() => HomePage(middleManAddOrUpdate: UserOperations(
        txtAddress:model!.address ,
         operationId:  model!.placeId,
         selectedMiddlemanType: myType!,
         selectedOperation:model!.operation! ,
         txtPrice: model!.metrePrice.toString(),
         txtArea: model!.size,
         txtMoreDetails: model!.moreDetails,
         txtRoufNum: model!.roufNum.toString(),
         addOrUpdate: "تعديل",
      ) ));

    }, () async {
      Get.back();
      await middlemanController!.addOrUpdateDeleteOperation(
          opeId: model!.placeId,
          roufNum: "0",
          addOrUpdate: "delete",
          operation: "no",
          moreDetails: "no",
          address: "d",
          adminId: 0,
          type: model!.type,
          metrePrice: "d",
          size: "d");
    }, model!.status == 0 ? true : false);
  }

  Padding _dataWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          CustomText(
            text:
                "الإجمالي \$  ${double.tryParse(model!.totalPrice!)!.toStringAsFixed(3)}",
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 10),
          CustomText(
            text: myType! +
                (model!.type == "flat" || model!.type == "block"
                    ? roufNum! + "${model!.roufNum}"
                    : "") +
                " || المساحة : ${model!.size}  ||  " +
                "سعر المتر :  ${model!.metrePrice}",
            color: Colors.grey,
            alignment: Alignment.centerRight,
            textAlign: TextAlign.right,
          ),
          CustomText(
              text: "العنوان :  ${model!.address}",
              color: Colors.grey,
              maxLine: 2,
              alignment: Alignment.centerRight,
              textAlign: TextAlign.right),
          CustomText(
            text: "تفاصيل اكثر : ${model!.moreDetails}",
            color: Colors.grey,
            alignment: Alignment.centerRight,
            maxLine: 3,
            textAlign: TextAlign.right,
          ),
          type == "user"
              ? CustomText(
                  text: model!.status == 0
                      ? "اشخاص يتم التفاوض معهم"
                      : "تفاصيل المشتري",
                  color: Colors.grey,
                  alignment: Alignment.centerRight,
                )
              : Container(),
          const SizedBox(height: 10),
          type == "user" ? _discussWidget() : Container()
        ],
      ),
    );
  }

  Widget _discussWidget() {
    return model!.status == 0 && model!.discussUserList!.isEmpty
        ? const CustomText(
            text: "لا يوجد مشتري حتي الان",
            color: Colors.grey,
            alignment: Alignment.centerRight,
          )
        : _discusListWidget();
  }

  SizedBox _discusListWidget() {
    return SizedBox(
      height: 110,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: model!.discussUserList!.length,
          itemBuilder: (context, position) {
            DiscussModel discussModel = DiscussModel.fromSnapshot(
                model!.discussUserList![position]);
            return GestureDetector(
              onTap: () {
                if (model!.status == 0) {
                  showDialogFor(
                      contentText:
                          "هل تم التوصل لإتفاق مع ${discussModel.userName} بالفعل",
                      title: "موافقة",
                      onPress: () async {
                        Get.back();
                        await middlemanController!.addBuyer(
                            opeId: model!.placeId,
                            buyerId: discussModel.userId);
                      });
                }
              },
              child: Container(
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.only(left: 5, top: 5, bottom: 5),
                width: model!.status == 1 ? 320 : 250,
                decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        adminProfileWidget(
                            name: "${discussModel.userName}",
                            image: discussModel.imageUrl,
                            date: discussModel.date),
                        discussModel.status == "buy"
                            ? const Icon(Icons.check, color: Colors.white)
                            : Container()
                      ],
                    ),
                    phonesWidget(
                        adminName: discussModel.userName,
                        color: Colors.white,
                        phones: discussModel.discusPhones)
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget _stopWidget() {
    return type == "user" && model!.mainAdminStatus == 0
        ? CustomText(
            text: "تم إيقاف العرض لان " + model!.stopReason!,
            color: Colors.red,
          )
        : Container();
  }

  Column _bottomRow() {
    return Column(
      children: [
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            likeWidget(
                counter: "${model!.likeCount}",
                icon: Icons.favorite,
                iconColor: Colors.pink),
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                height: 30,
                child: CustomText(
                  text: "     ${model!.operation}",
                  color: Colors.grey,
                )),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              height: 30,
              child: Row(
                children: [
                  CustomText(
                    text: model!.status == 0
                        ? "معروض الان"
                        : "تم ال${model!.operation}",
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 10),
                  Icon(model!.status == 0 ? Icons.more : Icons.check,
                      color: model!.status == 0
                          ? primaryColor
                          : Colors.green),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}
