import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:middleman_all/View/widgets/custom_text.dart';
import 'package:middleman_all/View/widgets/custom_textfield.dart';

operationDialog({String? type,int? id=0,String? name="",String? desc="",
  String? persentage ="",String? endTime ="",controller}) {

  final _formKey=GlobalKey<FormState>();
  String? _name,_desc,_percentage;

  bool
  _isUpdateCate=type=="تعديل القسم",
  _isAddDis=type=="إضافة عرض",
  _isUpdateDis=type=="تعديل العرض",
  _isDiscount=_isAddDis||_isUpdateDis,
  _isUpdate=_isUpdateDis||_isUpdateCate
  ;
  late TextEditingController _endTime = TextEditingController(text:_isUpdateDis? endTime!.substring(0,10):"");
  Get.dialog(
  Directionality(
  textDirection: TextDirection.rtl,
  child: AlertDialog(
  scrollable: true,
  shape:const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
  title: Text(type!),
  content: Form(
  key: _formKey,
  child:
  Column(
  children: [
  CustomTextField(
  initialValue:_isUpdate? name:"",
  lable: _isDiscount?"العرض":"القسم",
  onSave: (value) {
  _name=value;
  },), const SizedBox(height: 15.0),
  _isDiscount?CustomTextField(
  initialValue:type=="تعديل العرض"?persentage:"",
  lable: "نسبة الخصم",
  onSave: (value) {
  _percentage=value;
  },):Container(),
  _isDiscount?const SizedBox(height: 15.0):Container(),
  _isDiscount?TextFormField(
  onTap: ()=>_showDatePacker(_endTime),
  readOnly: true,
  controller: _endTime,
  validator: (String? value) {
  if (value!.isEmpty){
  return "يجب ان تدخل تاريخ إنتهاء العرض";
  }},
  decoration: InputDecoration(

  prefixIcon: const Padding(
  padding:  EdgeInsets.only(right: 10.0),
  child: Icon(Icons.calendar_today),
  ),
  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30),),
  labelText: "إنتهاء العرض",
  ),
  ):Container(),
  _isDiscount?const SizedBox(height: 15.0):Container(),
  CustomTextField(
  initialValue:_isUpdate? desc:"",
  lable: _isDiscount?"تفاصيل اكثر":"الشرح",
  onSave: (value) {
  _desc= value;
  },),
  ],)),
  actions: <Widget>[
  TextButton(onPressed: ()=>Get.back(), child:const Text("إلغاء")),
  TextButton(onPressed: ()async{
  _formKey.currentState!.save();
  if(_formKey.currentState!.validate()){
  Get.back();
  if(_isDiscount)
  {
  await controller!.discountOperations(
  disId: id!,type: _isUpdate?"update":"add",name: _name,desc: _desc,endIn: _endTime.text,percentage: _percentage);
  }
  else
  {
  await controller.operations(moduleName: "category",operationType:_isUpdate?"update":"add",
  addressOrCategoryDescription: _desc,usernameOrCategory: _name,id:id!);
  }


  }
  }, child: const Text("موافق"),),
  ],


  ),
  ),

  barrierDismissible: true,
  );
}

_showDatePacker(TextEditingController dateController) async{
  final DateTime? picked = await showDatePicker(
  context: Get.context!,
  initialDate:dateController.text==""?DateTime.now():DateTime.tryParse(dateController.text)!,
  firstDate: DateTime.now(),
  lastDate: DateTime(2050,1,1),
  );

  if (picked != null) {
  dateController.text=picked.toString().substring(0,10);
  }
}

dateWidget(String date,String type) {
  return
    date==""
      ?
  Container()
      :
  Directionality(
      textDirection:
          type=="create"
              ?
          TextDirection.ltr
              :
          TextDirection.rtl,
      child: Padding(
                padding: EdgeInsets.symmetric(vertical:type=="create"? 8.0:0.0),
                child:
                    type=="create"
                        ?
                    Text(date.substring(0,date.length-3))
                         :
                    CustomText(text:( type=="modify"?"تم التعديل بتاريخ :   ":type=="delete"?"تم الإيقاف  بتاريخ :  ":type=="status_changed"?"تم تغيير الحالة بتاريخ":"هذا العرض ساري حتي :  ")+date.substring(0,10) ,color: Colors.grey,alignment: Alignment.centerRight,maxLine: 3,textAlign: TextAlign.right)
    ,
  ));
}