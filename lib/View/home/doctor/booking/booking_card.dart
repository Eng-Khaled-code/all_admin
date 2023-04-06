
import 'package:flutter/material.dart';
import 'package:middleman_all/Controller/data/doctor_controller.dart';
import 'package:middleman_all/Models/doctor/booking_model.dart';
import 'package:middleman_all/View/widgets/constant.dart';
import 'package:middleman_all/View/widgets/custom_text.dart';
import '../../../utilities/strings.dart';
import '../doctor_constant.dart';

// ignore: must_be_immutable
class BookingCard extends StatelessWidget {
  final BookingModel? model;
  DoctorController? doctorController;
  BookingCard({Key? key,this.model,this.doctorController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
  return  Container(
      margin:const EdgeInsets.symmetric(vertical: 8.0,horizontal: 8.0),
      decoration: customDecoration(context),
      child: Column(
      children: [
        _topRow(context),
        _columnData(context),
        _bottomRow(context)
      ],
    )

    );
  }

  Padding _columnData(BuildContext context){

  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center
    ,children: [
      CustomText(text:model!.patientName!,color: primaryColor,fontSize: 18,fontWeight: FontWeight.bold,alignment: Alignment.center,),
      CustomText(text:model!.painDesc!+(model!.notes!=""?"\n"+model!.notes!:"")+(model!.bookStatus! =="ACCEPTED"?"\nتاريخ القدوم: "+model!.finalBookDate!:""),color: primaryColor,alignment: Alignment.center,maxLine: 4,),
      ]),
  );

  }

  Row _topRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        adminProfileWidget(name:"${model!.username==""?"لا يوجد مستخدم":model!.username}",
            image: model!.userImage==""?Strings.appIconUrl:model!.userImage!,date:model!.reqDate!),
        coloredContainer(text:model!.bookType! )
      ],
    );
  }

  Widget _bottomRow(BuildContext context) {

    return
    model!.bookStatus=="ACCEPTED"||model!.bookStatus=="FINISHED"
       ?
    coloredContainer(text:"رقم الدور : "+model!.numInQueue!.toString(),)
       :
    model!.bookStatus =="WAITING"
       ?
    Row(
    children:[ operationButton("قبول",model!.id!,context,doctorController!,""), operationButton("رفض",model!.id!,context,doctorController!,"")],
    )
     :
    Container();

  }

}
