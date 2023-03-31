
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:middleman_all/Controller/data/user_controller.dart';
import 'package:middleman_all/View/widgets/custom_textfield.dart';
String selectedDay="السبت";
List<String> countries=["مصر","السعودية","الامارات","الكويت"];

prfileLoadingWidget(Color mycolor){
  return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),width:25,height:25,
      child:  CircularProgressIndicator(color: mycolor ,strokeWidth: 0.7,));

}

myCustomDialog({String? addOrUpdateOrDelete,String? type,String? fieldValue,String? fieldId}){
  final _formKey=GlobalKey<FormState>();
  final UserController _userController=Get.find();
  String title=
  type=="phone"&&addOrUpdateOrDelete=="add"
      ?
  "إضافة رقم تليفون جديد"
      :
  type=="phone"&&addOrUpdateOrDelete=="update"
      ?
  "تعديل رقم التليفون"
      :
  type=="phone"&&addOrUpdateOrDelete=="delete"
      ?
  "حذف رقم التليفون"
      :
  type=="username"
      ?
  "الاسم"
      :
  type=="address"
      ?
  "العنوان"
      :
      "التخصص"
  ;
  String deleteText=type=="phone"?"هل تريد حذف  $fieldValue":"";
  String finalValue="";

  Get.dialog(

          Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              shape:const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
              title:Text(title),
              content: Form(
                key: _formKey,
                child: addOrUpdateOrDelete=="delete"
                  ?
              Text(deleteText)
                  :
               CustomTextField(
                  initialValue: fieldValue,
                  lable:type=="phone"? "رقم التليفون":type=="username"
                      ?
                  "الاسم"
                      :
                  type=="address"?
                  "العنوان":
                 "التخصص",
                  onSave: (value){
                    finalValue=value;
                  },),
              ),

              actions: <Widget>[
                TextButton(onPressed: ()=>Get.back(), child:const Text("إلغاء")),
               TextButton(onPressed: (){

                 _formKey.currentState!.save();

                   if((addOrUpdateOrDelete=="delete")||_formKey.currentState!.validate()){

                   if (type == "phone") {
                     _userController.phoneOperations(
                         type: addOrUpdateOrDelete,
                         phoneId: fieldId,
                         number: finalValue

                     );
                   }
                   else
                     {
                     _userController.updateUserFields(key:type,value:finalValue);
                     }
                 Get.back();
                 }
               }, child: const Text("موافق"),),
              ],
            ),
          ),
      barrierDismissible: true,
    );

}
