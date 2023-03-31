
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:middleman_all/Controller/data/doctor_controller.dart';
import 'package:middleman_all/Models/doctor/booking_model.dart';
import 'package:middleman_all/View/home/doctor/day_operations/bottom_booking_card.dart';
import 'package:middleman_all/View/home/doctor/day_operations/top_booking_card.dart';
import 'package:middleman_all/View/widgets/constant.dart';
import 'package:middleman_all/View/widgets/custom_button.dart';
import 'package:middleman_all/View/widgets/custom_text.dart';
// ignore: must_be_immutable
class DayOperationPage extends StatelessWidget {

   DoctorController doctorController=Get.find();

  DayOperationPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    DateTime date=DateTime.now();
    String thisDay=date.year.toString()+"-"+date.month.toString()+"-"+date.day.toString();
    doctorController.search(value:thisDay );

    return  Obx(()=>
        RefreshIndicator(
            onRefresh: ()async{
              await doctorController.getBookingsByDoctor("out");
              doctorController.search(value:thisDay );

            },
            child: doctorController.isLoading.value
                ?loadingWidget()
:
            SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child:
            Column(children: [
              _addBookingButton(),
              _nextBookingWidget(context),
              _nextBookingLabel("قائمة الإنتظار"),
              _nextBookingsList(context,"waiting"),
              _nextBookingLabel("تم الإلغاء"),
              _nextBookingsList(context,"canceled"),
              _nextBookingLabel("تم الرفض"),
              _nextBookingsList(context,"refused"),
              _nextBookingLabel("تم الكشف"),
              _nextBookingsList(context,"finished")

            ],))
        ),
    );
  }

  Widget _nextBookingWidget(BuildContext context){
    return doctorController.acceptedBookingList.isEmpty
        ?
    noDataCard("لا توجد حجوزات اليوم","noData")
        :
    Column(
        children:[
          _firstCardWidget()
          ,
       _secondBookingIndex()
          ,

          _nextBookingLabel("الحجوزات التالية")
          ,
           _nextBookingsList(context,"accepted")
          ]);}


  noDataCard(String message,type){
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(        color:Colors.white,
          border: Border.all(color:primaryColor),borderRadius: BorderRadius.circular(10)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.assignment,size: 50,color: primaryColor),
        const  SizedBox(height: 15.0),
        CustomText(text: message,maxLine: 2,)]
        ,),
    );
  }

  _firstCardWidget() {
    return
      doctorController.firstBookingIndex.value==-1
    ?
    noDataCard("لا يوجد احد بداخل حجرةالكشف","noData")
        :
    TopBookingCard(number: 1,
    model: doctorController.acceptedBookingList[doctorController.firstBookingIndex.value],index: doctorController.firstBookingIndex.value,listLength: doctorController.acceptedBookingList.length,doctorController: doctorController,);
  }

  _secondBookingIndex() {

    return doctorController.secondBookingIndex.value==-1
        ||doctorController.secondBookingIndex>= doctorController.acceptedBookingList.length?Container()
        :
    TopBookingCard(

        number: 2,
        model: doctorController.acceptedBookingList[doctorController.secondBookingIndex.value],index: doctorController.secondBookingIndex.value,listLength: doctorController.acceptedBookingList.length,doctorController:doctorController);
  }

  _nextBookingLabel(String title) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: CustomText(text: title,fontWeight: FontWeight.bold,color: Colors.black,alignment: Alignment.topRight,),
    );
  }

  _nextBookingsList(BuildContext context,type) {
    int itemCount=
    type=="accepted"?
    doctorController.acceptedBookingList.length
        :type=="waiting"?doctorController.waitingBookingList.length:
    type=="refused"?doctorController.refusedBookingList.length
        :type=="canceled"?doctorController.canceledBookingList.length:doctorController.finishedBookingList.length;
    return Padding(
        padding:const EdgeInsets.only(right: 15.0 ),
        child: Container(width: double.infinity,
            padding:const EdgeInsets.all( 8.0) ,

            height:MediaQuery.of(context).orientation==Orientation.portrait? MediaQuery.of(context).size.height*.27:MediaQuery.of(context).size.height*.55,
            decoration:const BoxDecoration(color: Colors.white,
                borderRadius: BorderRadius.only(topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10))),
            child:
                itemCount==0?noDataCard("لا توجد حجوزات اليوم","noData"):
            ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount:itemCount,
                itemBuilder:(context,position){
                  BookingModel model=type=="accepted"?
                  doctorController.acceptedBookingList[position]
                      :type=="waiting"?doctorController.waitingBookingList[position]:
                  type=="refused"?doctorController.refusedBookingList[position]
                      :type=="canceled"?doctorController.canceledBookingList[position]:doctorController.finishedBookingList[position];

                  return BottomBookingCard(model:model,doctorController: doctorController,);
                })

        ));

  }

  _showAddDialog() {
    final _formKey = GlobalKey<FormState>();
    TextEditingController _patientNameCon = TextEditingController();
    TextEditingController _painDescCon = TextEditingController();

    Get.dialog(SizedBox(
      height: 300,
      child: Directionality(
              textDirection: TextDirection.rtl,
              child: AlertDialog(
                scrollable: true,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                title: const Text("إضافة حجز جديد بتاريخ اليوم"),
                content: Form(
                  key: _formKey,
                  child: Column(children:[TextFormField(
                    controller: _patientNameCon,
                    validator: (String? value) {
                  if (value!.isEmpty){
                  return "يجب ان تدخل الاسم";}
                  },
                    decoration:const InputDecoration(
                        labelText: "اسم المريض",
                        labelStyle: TextStyle(fontSize: 13)),
                  ),
                  TextFormField(
                    controller: _painDescCon,
                    validator: (String? value) {
                  if (value!.isEmpty){
                  return " من فضلك إدخل وصف للمرض";}
                  },
                    decoration:const InputDecoration(
                        labelText: "وصف للمرض",
                        labelStyle: TextStyle(fontSize: 13)),
                  ),
                ])),
                actions: <Widget>[TextButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                        Get.back();
                        doctorController.addBookingFromClinick(patientName:_patientNameCon.text,painDesc:_painDescCon.text);
                        }
                      },
                      child: const Text("إضافة",
                          style:
                          TextStyle(fontSize: 13))),
                  TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text("إلغاء", style: TextStyle(fontSize: 13, color: Colors.red))),
                ],
              ),
            ),
    ));
        }



  _addBookingButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomButton(onPress: ()=>_showAddDialog(),text: "إضافة حجز",color: const[Colors.blue,Colors.blue],textColor: Colors.white,),
    );
  }


}