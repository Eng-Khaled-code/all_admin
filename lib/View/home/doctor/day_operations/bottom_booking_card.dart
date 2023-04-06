import 'package:flutter/material.dart';
import 'package:middleman_all/Controller/data/doctor_controller.dart';
import 'package:middleman_all/Models/doctor/booking_model.dart';
import 'package:middleman_all/View/widgets/constant.dart';
import 'package:middleman_all/View/widgets/custom_text.dart';
import '../doctor_constant.dart';

// ignore: must_be_immutable
class BottomBookingCard extends StatelessWidget {
  final BookingModel? model;
  DoctorController? doctorController;
  BottomBookingCard({Key? key, this.model, this.doctorController})
      : super(key: key);

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
      padding: const EdgeInsets.all(2.0),
      child: Container(
        width: MediaQuery.of(context).size.width * .5,
        decoration: customDecoration(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _topRow(),
            _textWidget(model!.patientName!),
            _textWidget(model!.bookStatus == "REFUSED" ||
                    model!.bookStatus == "CANCELED"
                ? model!.painDesc!
                : model!.notes!),
            _requestDateWidget(),
            _operationRowWidget(context),
          ],
        ),
      ),
    );
  }


  Row _topRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [coloredContainer(text: model!.bookType!), _numInQueueWidget()],
    );
  }

  Widget _numInQueueWidget() {
    return model!.bookStatus == "ACCEPTED"
        ? coloredContainer(text: model!.numInQueue!.toString())
        : Container();
  }

  Padding _textWidget(String text) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: CustomText(
        text: text,
        color: Colors.blue,
      ),
    );
  }

  Widget _requestDateWidget() {
    return model!.bookStatus == "WAITING"
        ? customDateWidget(
            date: model!.reqDate!,
          )
        : Container();
  }

  Widget _operationRowWidget(BuildContext context) {
    return model!.bookStatus == "WAITING"
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              operationButton(
                  "قبول", model!.id!, context, doctorController!, thisDay),
              operationButton(
                  "رفض", model!.id!, context, doctorController!, thisDay)
            ],
          )
        : Container();
  }
}
