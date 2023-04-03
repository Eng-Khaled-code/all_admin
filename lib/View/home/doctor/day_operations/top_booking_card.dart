import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:middleman_all/Controller/data/doctor_controller.dart';
import 'package:middleman_all/Models/doctor/booking_model.dart';
import 'package:middleman_all/View/widgets/constant.dart';
import 'package:middleman_all/View/widgets/custom_alert_dialog.dart';
import 'package:middleman_all/View/widgets/custom_button.dart';
import 'package:middleman_all/View/widgets/custom_text.dart';
import '../doctor_constant.dart';

// ignore: must_be_immutable
class TopBookingCard extends StatelessWidget {
  final BookingModel? model;

  final int? number;

  final int? index;

  final int? listLength;

  TopBookingCard(
      {Key? key,
      this.model,
      this.number,
      this.index,
      this.listLength,
      this.doctorController})
      : super(key: key);

  DoctorController? doctorController;

  DateTime date = DateTime.now();
  String thisDay = "";

  @override
  Widget build(BuildContext context) {
    thisDay = date.year.toString() +
        "-" +
        date.month.toString() +
        "-" +
        date.day.toString();

    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: number == 1 ? _firstCardWidget(context) : _secondCardWidget());
  }

  Padding columnData() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomText(
              text: model!.patientName!,
              color: primaryColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              alignment: Alignment.center,
            ),
            CustomText(
              text: model!.painDesc!,
              color: Colors.grey,
              alignment: Alignment.center,
            ),
          ]),
    );
  }

  void showFinishDialogWithNoDate() {
    Get.dialog(CustomAlertDialog(
      title: "تنبيه",
      onPress: () async {
        Get.back();
        await doctorController!.changeBookStatus(
            bookId: model!.id,
            bookStatus: "FINISHED",
            date: model!.finalBookDate,
            bookType: "إعادة",
            notes: "يرجي تقييم الدكتور",
            searchDate: thisDay);

        doctorController!.firstBookingIndex(-1);
        if (doctorController!.secondBookingIndex.value > 0) {
          doctorController!.setSecondBookingIndex(
              doctorController!.secondBookingIndex.value - 1);
        }
      },
      text: "هل انتهي الكشف بالفعل",
    ));
  }

  void showFinishDialogWithDate(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    TextEditingController _dateController = TextEditingController();

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              scrollable: true,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              title: const Text("تحديد موعد الإعادة"),
              content: Form(
                key: _formKey,
                child: TextFormField(
                  onTap: () => _showDatePacker(_dateController, context),
                  readOnly: true,
                  controller: _dateController,
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return "يجب ان تدخل تاريخ الإعادة";
                    }
                  },
                  decoration: const InputDecoration(
                      labelText: "موعد الإعادة الذي سوف ياتي به المريض",
                      labelStyle: TextStyle(fontSize: 12)),
                ),
              ),
              actions: <Widget>[
                TextButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        Navigator.pop(context);
                        await doctorController!.changeBookStatus(
                            bookId: model!.id,
                            bookStatus: "ACCEPTED",
                            date: _dateController.text,
                            bookType: "إعادة",
                            notes: "يرجي تقييم الدكتور",
                            searchDate: thisDay);
                        doctorController!.setFirstBookingIndex(-1);
                        if (doctorController!.secondBookingIndex.value > 0) {
                          doctorController!.setSecondBookingIndex(
                              doctorController!.secondBookingIndex.value - 1);
                        }
                      }
                    },
                    child: const Text("موافق",
                        style: TextStyle(fontSize: 13, color: Colors.red))),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("إلغاء", style: TextStyle(fontSize: 13))),
              ],
            ),
          );
        });
  }

  void _showDatePacker(
      TextEditingController dateController, BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2050, 1, 1));

    if (picked != null) {
      String date = picked.year.toString() +
          "-" +
          picked.month.toString() +
          "-" +
          picked.day.toString();
      String thisDay = DateTime.now().year.toString() +
          "-" +
          DateTime.now().month.toString() +
          "-" +
          DateTime.now().day.toString();
      if (date == thisDay) {
        Fluttertoast.showToast(msg: "لا يمكن ان تكون الإعادة في نفس يوم الحجز");
      } else {
        dateController.text = date;
      }
    }
  }

  Material _firstCardWidget(BuildContext context) {
    return Material(
        elevation: 2,
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _topRowWidget(),
            columnData(),
            _cancelBookingWidget(context),
            _finishBookingWidget(context)
          ],
        ));
  }

  Row _topRowWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        coloredContainer(text: model!.bookType!),
        CustomText(
            text: number == 1 ? " يوجد حاليا بداخل حجرةالكشف" : "الشخص التالي"),
        coloredContainer(text: model!.numInQueue!.toString())
      ],
    );
  }

  Row _cancelBookingWidget(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Text("لإلغاء الطلب إضغط ", style: TextStyle(color: Colors.black)),
      GestureDetector(
        child: const Text(" هنا ",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.green,
                decoration: TextDecoration.underline)),
        onTap: () => showDialogReasonDialog(
            model!.id!, context, "cancel", doctorController!, thisDay),
      )
    ]);
  }

  Padding _finishBookingWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: CustomButton(
          color: const [
            primaryColor,
            Color(0xFF0D47A1),
          ],
          text:
              model!.bookType == "كشف" ? "إنهاء و تحديد موعد الإعادة" : "إنهاء",
          onPress: () {
            if (model!.bookType == "كشف") {
              showFinishDialogWithDate(context);
            } else {
              showFinishDialogWithNoDate();
            }
          },
          textColor: Colors.white),
    );
  }

  Material _secondCardWidget() {
    return Material(
        elevation: 2,
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        child: Column(
          children: [
            _topRowWidget(),
            columnData(),
            _nextButtonWidget(),
            _enteringClinicRoomWidget()
          ],
        ));
  }

  Padding _nextButtonWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(alignment: WrapAlignment.center, children: [
        const Text("إذا كان المريض غير موجود إضغط ",
            style: TextStyle(color: Colors.black)),
        GestureDetector(
          child: const Text(" التالي ",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: primaryColor,
                  decoration: TextDecoration.underline)),
          onTap: () {
            if (listLength! > index! + 1 &&
                index! + 1 != doctorController!.firstBookingIndex.value) {
              doctorController!.setSecondBookingIndex(index! + 1);
            } else if (listLength! > index! + 1 &&
                (index! + 1).obs == doctorController!.firstBookingIndex) {
              if (listLength! > index! + 2) {
                doctorController!.setSecondBookingIndex(index! + 2);
              } else {
                Fluttertoast.showToast(msg: "هذا المريض هو اخر واحد في الصف");
              }
            } else {
              Fluttertoast.showToast(msg: "هذا المريض هو اخر واحد في الصف");
            }
          },
        ),
        const Text(" أو اضغط ", style: TextStyle(color: Colors.black)),
        GestureDetector(
          child: const Text(" السابق ",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: primaryColor,
                  decoration: TextDecoration.underline)),
          onTap: () {
            if (index! > 0) {
              if ((index! - 1).obs != doctorController!.firstBookingIndex) {
                doctorController!.setSecondBookingIndex(index! - 1);
              } else if (index! - 2 >= 0) {
                doctorController!.setSecondBookingIndex(index! - 2);
              } else {
                Fluttertoast.showToast(msg: "هذا المريض هو الاول في الصف");
              }
            } else {
              Fluttertoast.showToast(msg: "هذا المريض هو الاول في الصف");
            }
          },
        ),
        const Text("للشخص الذي اتي متاخر عن دوره",
            style: TextStyle(color: Colors.black))
      ]),
    );
  }

  Widget _enteringClinicRoomWidget() {
    return doctorController!.firstBookingIndex.value == -1
        ? Padding(
            padding: const EdgeInsets.all(20.0),
            child: CustomButton(
                color: const [
                  primaryColor,
                  Color(0xFF0D47A1),
                ],
                text: "إدخال الي حجرة الكشف",
                onPress: () => _showClinicDialog(),
                textColor: Colors.white))
        : Container();
  }

  void _showClinicDialog() {
    Get.dialog(CustomAlertDialog(
      title: "تنبيه",
      onPress: () {
        int? second =
            doctorController!.acceptedBookingList.length > (index! + 1)
                ? index! + 1
                : (index!) > 0
                    ? index! - 1
                    : -1;
        doctorController!.setSecondBookingIndex(second);
        doctorController!.setFirstBookingIndex(index!);
        Get.back();
      },
      text: "هل تريد إدخال هذا الشخص الي حجرة الكشف",
    ));
  }
}
