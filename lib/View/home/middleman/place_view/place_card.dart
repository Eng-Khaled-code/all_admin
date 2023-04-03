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
class PlaceCard extends StatefulWidget {
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

  @override
  State<PlaceCard> createState() => _PlaceCardState();
}

class _PlaceCardState extends State<PlaceCard> {
  String? roufNum, myType;

  @override
  Widget build(BuildContext context) {
    roufNum = widget.model!.type == "flat"
        ? "رقم الطابق : "
        : widget.model!.type == "block"
            ? "عدد الطوابق"
            : "";
    myType = widget.model!.type == "flat"
        ? "شقة "
        : widget.model!.type == "block"
            ? "عمارة "
            : widget.model!.type == "ground"
                ? "قطعة ارض"
                : "محل ";
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.white),
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
        children: widget.type == "user"
            ? [
                coloredContainer(text: myType),
                Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: customDateWidget(date: widget.model!.date)),
                _operationRow(),
              ]
            : [
                adminProfileWidget(
                  name: widget.model!.adminName,
                  image: widget.model!.adminImage,
                  opertionType:
                      "${widget.model!.operation} ${widget.model!.type == "flat" ? "شقة" : widget.model!.type == "ground" ? "قطعة ارض" : widget.model!.type == "block" ? "عمارة" : "محل"}",
                  date: widget.model!.date,
                ),
                _placeAdminStatus()
              ]);
  }

  Widget _placeAdminStatus() {
    return IconButton(
        onPressed: () => widget.model!.mainAdminStatus == 1
            ? _showReasonDialog()
            : _showAcceptDialog(),
        icon: Icon(widget.model!.mainAdminStatus == 0
            ? Icons.visibility_off
            : Icons.visibility));
  }

  void _showReasonDialog() {
    showReasonDialog(
        title: "هل تريد إيقاف عرض هذا العقار",
        onPress: (comingReason) async {
          Navigator.pop(context);
          await widget.adminController!.operations(
            id: widget.model!.placeId,
            operationType: "change status",
            moduleName: "middleman",
            userStatusOrClinicStatus: "0",
            passwordOrStopReason: comingReason,
            emailOrAdminToken: widget.model!.adminToken,
          );
        });
  }

  void _showAcceptDialog() {
    showDialogFor(
        contentText: "هل تريد إعادة عرض هذا العقار",
        title: "تأكيد",
        onPress: () async {
          Navigator.pop(context);
          await widget.adminController!.operations(
            id: widget.model!.placeId,
            operationType: "change status",
            passwordOrStopReason: "",
            moduleName: "middleman",
            userStatusOrClinicStatus: "1",
            emailOrAdminToken: widget.model!.adminToken,
          );
        });
  }

  Widget _operationRow() {
    return operationRow(() {
      currentIndex = 2;

      UserOperations.addOrUpdate = "تعديل";
      selectedOperation = widget.model!.operation!;
      selectedMiddlemanType = myType!;
      UserOperations.operationId = widget.model!.placeId;
      UserOperations.txtAddress = widget.model!.address;
      UserOperations.txtArea = widget.model!.size;
      UserOperations.txtMoreDetails = widget.model!.moreDetails;
      UserOperations.txtPrice = widget.model!.metrePrice;
      UserOperations.txtRoufNum = widget.model!.roufNum.toString();
      setState(() {});
    }, () async {
      Get.back();
      await widget.middlemanController!.addOrUpdateDeleteOperation(
          opeId: widget.model!.placeId,
          roufNum: "0",
          addOrUpdate: "delete",
          operation: "no",
          moreDetails: "no",
          address: "d",
          adminId: 0,
          type: widget.model!.type,
          metrePrice: "d",
          size: "d");
    }, widget.model!.status == 0 ? true : false);
  }

  Padding _dataWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          CustomText(
            text:
                "الإجمالي \$  ${double.tryParse(widget.model!.totalPrice!)!.toStringAsFixed(3)}",
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 10),
          CustomText(
            text: myType! +
                (widget.model!.type == "flat" || widget.model!.type == "block"
                    ? roufNum! + "${widget.model!.roufNum}"
                    : "") +
                " || المساحة : ${widget.model!.size}  ||  " +
                "سعر المتر :  ${widget.model!.metrePrice}",
            color: Colors.grey,
            alignment: Alignment.centerRight,
            textAlign: TextAlign.right,
          ),
          CustomText(
              text: "العنوان :  ${widget.model!.address}",
              color: Colors.grey,
              maxLine: 2,
              alignment: Alignment.centerRight,
              textAlign: TextAlign.right),
          CustomText(
            text: "تفاصيل اكثر : ${widget.model!.moreDetails}",
            color: Colors.grey,
            alignment: Alignment.centerRight,
            maxLine: 3,
            textAlign: TextAlign.right,
          ),
          widget.type == "user"
              ? CustomText(
                  text: widget.model!.status == 0
                      ? "اشخاص يتم التفاوض معهم"
                      : "تفاصيل المشتري",
                  color: Colors.grey,
                  alignment: Alignment.centerRight,
                )
              : Container(),
          const SizedBox(height: 10),
          widget.type == "user" ? _discussWidget() : Container()
        ],
      ),
    );
  }

  Widget _discussWidget() {
    return widget.model!.status == 0 && widget.model!.discussUserList!.isEmpty
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
          itemCount: widget.model!.discussUserList!.length,
          itemBuilder: (context, position) {
            DiscussModel discussModel = DiscussModel.fromSnapshot(
                widget.model!.discussUserList![position]);
            return GestureDetector(
              onTap: () {
                if (widget.model!.status == 0) {
                  showDialogFor(
                      contentText:
                          "هل تم التوصل لإتفاق مع ${discussModel.userName} بالفعل",
                      title: "موافقة",
                      onPress: () async {
                        Get.back();
                        await widget.middlemanController!.addBuyer(
                            opeId: widget.model!.placeId,
                            buyerId: discussModel.userId);
                      });
                }
              },
              child: Container(
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.only(left: 5, top: 5, bottom: 5),
                width: widget.model!.status == 1 ? 320 : 250,
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
                            date: discussModel.date,
                            color: Colors.white),
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
    return widget.type == "user" && widget.model!.mainAdminStatus == 0
        ? CustomText(
            text: "تم إيقاف العرض لان " + widget.model!.stopReason!,
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
                counter: "${widget.model!.likeCount}",
                icon: Icons.favorite,
                iconColor: Colors.pink),
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                height: 30,
                child: CustomText(
                  text: "     ${widget.model!.operation}",
                  color: Colors.grey,
                )),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              height: 30,
              child: Row(
                children: [
                  CustomText(
                    text: widget.model!.status == 0
                        ? "معروض الان"
                        : "تم ال${widget.model!.operation}",
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 10),
                  Icon(widget.model!.status == 0 ? Icons.more : Icons.check,
                      color: widget.model!.status == 0
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
