import 'package:flutter/material.dart';
import 'package:middleman_all/Controller/data/doctor_controller.dart';
import 'package:middleman_all/View/widgets/custom_button.dart';

showDialogReasonDialog(int bookId,BuildContext context,String type,DoctorController doctorController,String searchDate) {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _reasonController = TextEditingController();
  TextEditingController _dateController = TextEditingController();

  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            scrollable: true,shape: RoundedRectangleBorder(

              borderRadius: BorderRadius.circular(10)),
            title: Text(type=="refuse"||type=="cancel"?"السبب ؟":"الموافقة علي الطلب"),
            content: Form(
              key: _formKey,
              child: Column(
                children: [
                  type=="refuse"||type=="cancel"?Container():TextFormField(
                    onTap: ()=>_showDatePacker(_dateController,context),
                    readOnly: true,
                    controller: _dateController,
                    validator: (String? value) {
                  if (value!.isEmpty&&(type=="accept"))
                  {
                  return "يجب ان تدخل تاريخ الحجز";
                  }
                  },
                    decoration: const InputDecoration(
                        labelText: "الموعد الذي سوف ياتي به المريض",
                        labelStyle: TextStyle(fontSize: 12)),
                  ),
                  TextFormField(
                    controller: _reasonController,
                    validator: (String? value) {
                  if (value!.isEmpty){
                  return "يجب ان تدخل سبب رفض هذا الحجز";}
                  },
                    decoration: InputDecoration(
                        labelText: type=="refuse"||type=="cancel"?"السبب ؟":"تعليمات للمريض عند الحضور",
                        labelStyle: const TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ),
            actions: <Widget>[TextButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                  Navigator.pop(context);
                  if (type == "refuse") {
                  await doctorController.changeBookStatus(bookId:bookId,bookStatus:"REFUSED",date:" ",notes:_reasonController.text,searchDate:searchDate);
                  }
                  else if(type=="cancel"){
                  await doctorController.changeBookStatus(bookId:bookId,bookStatus:"CANCELED",date:" ",notes:_reasonController.text,searchDate:searchDate);
                  doctorController.setFirstBookingIndex(-1);
                  if(doctorController.secondBookingIndex.value > 0)
                  {
                  doctorController.setSecondBookingIndex(doctorController.secondBookingIndex.value-1);
                  }
                  }
                  else {
                  await doctorController.changeBookStatus(bookId:bookId,bookStatus:"ACCEPTED",date:_dateController.text,notes:_reasonController.text,searchDate:searchDate);
                  if(doctorController.secondBookingIndex.value==-1){
                  doctorController.setSecondBookingIndex((doctorController.firstBookingIndex.value != -1)?1:0);
                  }
                  }

                  }
                },
                child:const Text("إرسال",
                    style:
                    TextStyle(fontSize: 13, color: Colors.red))),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child:const Text("إلغاء", style: TextStyle(fontSize: 13))),
            ],
          ),
        );
      });

}

_showDatePacker(TextEditingController dateController,BuildContext context) async{

  final DateTime? picked = await showDatePicker(
  context: context,
  initialDate: DateTime.now(),
  firstDate: DateTime.now(),
  lastDate: DateTime(2050,1,1));

  if (picked != null) {
  dateController.text=picked.year.toString()+ "-"+ picked.month.toString()+"-"+picked.day.toString();
  }
}
Padding operationButton(String type,int bookId,BuildContext context,DoctorController doctorController,String thisDay){
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: CustomButton(
        width: 50,
        color: const[
          Color(0xFF1E88E5),
          Color(0xFF0D47A1),
        ],
        text: type,
        onPress:()=>showDialogReasonDialog(bookId,context,type=="قبول"?"accept":"refuse",doctorController,thisDay),
        textColor: Colors.white),
  );
}