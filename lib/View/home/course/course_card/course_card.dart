import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:middleman_all/Controller/data/admin_controller.dart';
import 'package:middleman_all/Controller/data/courses_controller.dart';
import 'package:middleman_all/Models/courses/course_model.dart';
import 'package:middleman_all/View/home/course/course_details/course_details.dart';
import 'package:middleman_all/View/home/ecommerce/discount/operation_dialog.dart';
import 'package:middleman_all/View/widgets/constant.dart';
import 'package:middleman_all/View/widgets/constant2.dart';
import 'package:middleman_all/View/widgets/custom_text.dart';

import '../../../utilities/strings.dart';

// ignore: must_be_immutable
class CourseCard extends StatefulWidget {
  final CourseModel? model;
  final CoursesController? coursesController;
  late AdminController? adminController;
  final String? screenType;
  CourseCard(
      {Key? key,
      this.model,
      this.coursesController,
      this.screenType = "user",
      this.adminController})
      : super(key: key);

  @override
  State<CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  bool showDiscountRow = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => CourseDetails(
            coursesController: widget.coursesController,
            courseModel: widget.model));
      },
      child: Card(
        margin: const EdgeInsets.all(5),
        child: Padding(
            padding: const EdgeInsets.only(
                top: 10.0, left: 10, right: 10, bottom: 5),
            child: Column(
              children: [
                _stopWidget(),
                _topRowWidget(),
                const Divider(),
                _middleRowWidget(),
                _discountWidget(),
                _hiddenDiscountRow(),
                const Divider(),
                _bottomRow(),
              ],
            )),
      ),
    );
  }

  Row _middleRowWidget() {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_courseImage(), const SizedBox(width: 5), _dataColumn()]);
  }

  GestureDetector _courseImage() {
    return GestureDetector(
      onTapDown: (details) =>
          widget.screenType == "user" ? _showPopUpMenue(details) : () {},
      child: Container(
        height: Get.height * .2,
        width: Get.width * .3,
        decoration: BoxDecoration(
          border: Border.all(color: primaryColor),
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            image: NetworkImage(
                Strings.coursesImagesDirectoryUrl + widget.model!.imageUrl!),
            fit: BoxFit.cover,
            onError: (k, l) => Image.asset(
              "assets/images/errorimage.png",
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }

  Expanded _dataColumn() {
    return Expanded(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _courseTitle(),
            _courseDescription(),
            _dateWidget(),
            _priceRow(),
          ]),
    );
  }

  Row _priceRow() {
    return Row(
      children: [
        _priceContainer(),
        _priceAfterDiscountContainer(),
      ],
    );
  }

  InkWell _priceContainer() {
    return InkWell(
      onTap: () {
        if (widget.screenType == "user") {
          showReasonDialog(
              title: "تعديل سعر الكورس",
              onPress: (String price) async => await widget.coursesController!
                  .courseOperations(
                      price: price,
                      operationType: "update course price",
                      id: widget.model!.id),
              initialValue: widget.model!.price,
              lable: "السعر");
        }
      },
      child: Container(
        margin: const EdgeInsets.only(left: 10),
        padding: const EdgeInsets.all(5),
        child: Text(
          "${widget.model!.price}\$",
          style: TextStyle(
              decoration: widget.model!.discountStatus == 1
                  ? TextDecoration.lineThrough
                  : TextDecoration.none),
        ),
        decoration: BoxDecoration(
          color: widget.model!.discountStatus == 1
              ? Colors.red
              : Colors.greenAccent,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Container _priceAfterDiscountContainer() {
    return widget.model!.discountStatus == 1
        ? _specialColoredContainer(
            text: "${widget.model!.priceAfterDiscount}\$")
        : Container();
  }

  Container _specialColoredContainer({String? text}) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: Text(
        text!,
        style: const TextStyle(color: Colors.white),
      ),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _stopWidget() {
    return widget.model!.mainAdminStatus == 0
        ? CustomText(
            text: "تم إيقاف العرض لان " + widget.model!.mainAdminStopReason!,
            color: Colors.red,
            maxLine: 3,
            alignment: Alignment.topRight,
            textAlign: TextAlign.start,
          )
        : Container();
  }

  InkWell _courseTitle() {
    return InkWell(
      onTap: () {
        if (widget.screenType == "user") {
          showReasonDialog(
              title: "تغيير اسم الكورس",
              initialValue: widget.model!.name,
              lable: "اسم الكورس",
              onPress: (name) {
                Get.back();
                widget.coursesController!.courseOperations(
                    operationType: "update course name",
                    name: name,
                    id: widget.model!.id!);
              });
        }
      },
      child: CustomText(
        text: widget.model!.name!,
        color: Colors.black,
        fontWeight: FontWeight.bold,
        maxLine: 1,
        textAlign: TextAlign.right,
        alignment: Alignment.topRight,
      ),
    );
  }

  Text _courseDescription() {
    return Text(
      widget.model!.desc!,
      maxLines: 3,
      textAlign: TextAlign.start,
      style: const TextStyle(overflow: TextOverflow.ellipsis),
    );
  }

  Row _bottomRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        likeWidget(
            counter: widget.model!.likeCount.toString(),
            icon: Icons.favorite,
            iconColor: Colors.pink),
        likeWidget(
            counter: widget.model!.blackCount.toString(),
            icon: Icons.disabled_by_default,
            iconColor: Colors.grey),
        likeWidget(
            counter: widget.model!.usersCount.toString(),
            icon: Icons.person,
            iconColor: Colors.green),
        likeWidget(
            counter: widget.model!.rate.toString(),
            icon: Icons.star,
            iconColor: Colors.orange),
        likeWidget(
            counter: widget.model!.videosCount.toString(),
            icon: Icons.video_library,
            iconColor: Colors.orange),
      ],
    );
  }

  _showPopUpMenue(TapDownDetails details) {
    final List<String> _updateTypes = ["تغيير الصورة"];
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
        items: _updateTypes.map((String choice) {
          return PopupMenuItem(
            value: choice,
            onTap: () {
              if (choice == "تغيير الصورة") {
                getImageFile(onFileSelected: (file) async {
                  await widget.coursesController!.courseOperations(
                    operationType: "update course image",
                    id: widget.model!.id,
                    image: file,
                    oldImageName: widget.model!.imageUrl!.split('/').last,
                  );
                });
              }
            },
            child: Text(
              choice,
              style: const TextStyle(fontSize: 12),
            ),
          );
        }).toList());
  }

  _discountWidget() {
    return Row(
      children: [
        GestureDetector(
            onTapDown: (details) => widget.screenType == "user"
                ? setState(() => showDiscountRow = !showDiscountRow)
                : () {},
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              height: 40,
              child: Row(
                children: [
                  CustomText(
                    text: widget.model!.discountStatus == 0
                        ? "لا يوجد خصم"
                        : "${widget.model!.descountPercentage}%",
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                  const SizedBox(width: 10),
                  const Icon(
                    Icons.money_off,
                    color: Colors.green,
                  ),
                ],
              ),
            )),
        widget.model!.discountStatus == 1
            ? Text(" ينتهي " + widget.model!.discountEndsIn!.substring(0, 10))
            : Container(),
      ],
    );
  }

  _onPressDelete() {
    showDialogFor(
        contentText: "هل تريد حذف هذا الكورس",
        title: "تأكيد",
        onPress: () async {
          Navigator.pop(context);
          await widget.coursesController!.courseOperations(
              id: widget.model!.id,
              operationType: "delete",
              oldImageName: widget.model!.imageUrl!.split("/").last);
        });
  }

  _topRowWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _specialColoredContainer(text: widget.model!.category),
        _specialColoredContainer(
            text: "مقيمين:" + widget.model!.usersCountRattings.toString()),
        widget.screenType == "user" ? _showWidget() : _showWidgetForAdmin(),
        widget.model!.videosCount == "0" ? _deleteWidget() : Container(),
      ],
    );
  }

  Widget _hiddenDiscountRow() {
    return showDiscountRow
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.model!.discountStatus == 0
                  ? TextButton.icon(
                      onPressed: () =>
                          _showAddUpdateDiscountDialog("إختيار عرض"),
                      icon: const Icon(
                        Icons.add_rounded,
                        size: 20,
                        color: Colors.blue,
                      ),
                      label: const CustomText(
                        text: "إضافة عرض",
                        fontSize: 12,
                      ))
                  : Row(children: [
                      TextButton.icon(
                          onPressed: () =>
                              _showAddUpdateDiscountDialog("إختيار عرض اخر"),
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.blue,
                            size: 20,
                          ),
                          label: const CustomText(
                              text: "إختيار عرض اخر", fontSize: 12)),
                      TextButton.icon(
                          onPressed: () => showDialogFor(
                              contentText:
                                  "هل بالفعل تريد إلغاء العرض  حيث ان نسبةالخصم تساوي   : " +
                                      widget.model!.descountPercentage! +
                                      " % ",
                              title: "إلغاء العرض",
                              onPress: () async {
                                Get.back();
                                await widget.coursesController!
                                    .addOrUpdateDeleteCourseDiscount(
                                        discountId: widget.model!.discountId,
                                        type: "delete",
                                        courseId: widget.model!.id);
                              }),
                          icon: const Icon(
                            Icons.close,
                            color: Colors.blue,
                            size: 20,
                          ),
                          label: const CustomText(
                              text: "إيقاف العرض", fontSize: 12))
                    ]),
            ],
          )
        : Container();
  }

  IconButton _deleteWidget() {
    return IconButton(
        onPressed: () => _onPressDelete(),
        icon: const Icon(
          Icons.delete,
          color: Colors.red,
        ));
  }

  Directionality _dateWidget() {
    String date = widget.model!.date!;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CustomText(
            text: "  الساعة =>  " +
                date.substring(date.length - 8, date.length - 3),
            maxLine: 1,
            color: Colors.black,
            fontSize: 12,
          ),
          CustomText(
            text: date.substring(0, date.length - 8),
            maxLine: 1,
            color: Colors.black,
            fontSize: 12,
          ),
        ],
      ),
    );
  }

  IconButton _showWidget() {
    return IconButton(
        onPressed: () {
          _showUnshowDialog();
        },
        icon: Icon(
          widget.model!.status == 1 ? Icons.visibility : Icons.visibility_off,
          color: widget.model!.status == 1 ? Colors.green : Colors.grey,
        ));
  }

  IconButton _showWidgetForAdmin() {
    return IconButton(
        onPressed: () => widget.model!.mainAdminStatus == 1
            ? _showReasonDialog()
            : _showAcceptDialog(),
        icon: Icon(
          widget.model!.mainAdminStatus == 1
              ? Icons.visibility
              : Icons.visibility_off,
          color:
              widget.model!.mainAdminStatus == 1 ? Colors.green : Colors.grey,
        ));
  }

  void _showReasonDialog() {
    showReasonDialog(
        title: "هل تريد إيقاف عرض هذا الكورس",
        onPress: (comingReason) async {
          Navigator.pop(context);
          await widget.adminController!.operations(
            id: widget.model!.id,
            operationType: "change status",
            moduleName: "courses_list",
            userStatusOrClinicStatus: "0",
            passwordOrStopReason: comingReason,
            emailOrAdminToken: widget.model!.userToken,
          );
        });
  }

  void _showAcceptDialog() {
    showDialogFor(
        contentText: "هل تريد إعادة عرض هذا الكورس",
        title: "تأكيد",
        onPress: () async {
          Navigator.pop(context);
          await widget.adminController!.operations(
            id: widget.model!.id,
            operationType: "change status",
            moduleName: "courses_list",
            userStatusOrClinicStatus: "1",
            passwordOrStopReason: "",
            emailOrAdminToken: widget.model!.userToken,
          );
        });
  }

  void _showUnshowDialog() {
    bool show = widget.model!.status == 1 ? false : true;
    showDialogFor(
        title: "تأكيد",
        contentText:
            show ? "هل تريد عرض هذا الكورس" : "هل تريد إيقاف عرض هذا الكورس",
        onPress: () async {
          Get.back();
          await widget.coursesController!.courseOperations(
              operationType: "update course status",
              status: show ? 1 : 0,
              id: widget.model!.id);
        });
  }

  bool _checkEmpty() {
    bool value = false;
    for (var element in widget.coursesController!.discountList) {
      value = element['status'] == 1 ? false : true;
      if (value == false) {
        break;
      }
    }
    return value;
  }

  Container _discountEmptyCart() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: Colors.grey[100],
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.circular(10)),
      width: double.infinity,
      child: Column(
        children: const [
          CustomText(
            text: "لا توجد عروض",
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          CustomText(
              text: "يمكنك إضافة عروض من خلال شاشة العروض والخصومات",
              color: Colors.grey,
              maxLine: 3)
        ],
      ),
    );
  }

  Widget _discountCard(int position, String type) {
    return widget.coursesController!.discountList[position]['status'] == 0
        ? Container()
        : InkWell(
            onTap: () async {
              Get.back();
              await widget.coursesController!.addOrUpdateDeleteCourseDiscount(
                  discountId: widget.coursesController!.discountList[position]
                      ['id'],
                  type: type == "إختيار عرض" ? "add" : "update",
                  courseId: widget.model!.id);
            },
            child: Container(
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(10)),
              width: double.infinity,
              child: Column(
                children: [
                  CustomText(
                    text: widget.coursesController!.discountList[position]
                            ['name']! +
                        "  نسبة الخصم : " +
                        widget.coursesController!
                            .discountList[position]['discount_percentage']
                            .toString(),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  dateWidget(
                      widget.coursesController!.discountList[position]
                          ['end_in']!,
                      "end"),
                ],
              ),
            ),
          );
  }

  void _showAddUpdateDiscountDialog(String type) {
    Get.dialog(
      Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            scrollable: true,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            title: CustomText(
              text: type,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            actions: [
              TextButton(
                  onPressed: () => Get.back(), child: const Text("إلغاء"))
            ],
            content: SizedBox(
              height: widget.coursesController!.discountList.isEmpty ||
                      _checkEmpty()
                  ? 120
                  : 300,
              child: widget.coursesController!.discountList.isEmpty ||
                      _checkEmpty()
                  ? _discountEmptyCart()
                  : ListView.builder(
                      itemCount: widget.coursesController!.discountList.length,
                      itemBuilder: (context, position) {
                        return _discountCard(position, type);
                      }),
            ),
          )),
      barrierDismissible: true,
    );
  }
}
