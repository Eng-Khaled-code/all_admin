import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'constant.dart';
import 'custom_text.dart';

Row operationRow(Function() onPressUpdate,Function() onPressDelete,bool showUpdate) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      showUpdate?_updateWidget(onPressUpdate):Container(),
      _deleteWidget(onPressDelete)
    ],
  );
}

IconButton _updateWidget(Function() onPressUpdate) {
  return IconButton(
    onPressed: onPressUpdate,
    icon: const Icon(Icons.edit,color: primaryColor),);
}

IconButton _deleteWidget(Function() onPressDelete) {
  return IconButton(
    onPressed:
        ()=>showDialogFor(contentText:"هل تريد الحذف بالفعل",title:"حذف",
        onPress: onPressDelete)
    ,icon: const Icon(Icons.delete,color: primaryColor),);
}

Container  phonesWidget({List? phones,adminName="",Color? color=Colors.blue,String? type="phones"}) {

  return Container(
    margin: const EdgeInsets.all(8.0),
    height: 30,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: phones!.length,
      itemBuilder: (context,position)=>InkWell(
        onTap: ()=>type=="phones"?showDialogFor(contentText: adminName+"\n${phones[position]}",title:"اتصال",onPress:()async=> await launch("tel://"+phones[position])  ):(){},
        child: Container(
          margin:  const EdgeInsets.symmetric(horizontal: 5),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: 30,
          decoration: BoxDecoration(color: primaryColor,borderRadius: BorderRadius.circular(10),border: Border.all(color: color!)),
          child: CustomText(text:phones[position], color: color)),
      ),),
  );
}

Container likeWidget({String? counter,IconData? icon ,Color? iconColor}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    height: 40,
    child: Row(
      children: [
        CustomText(
          text:counter!,
          color: Colors.grey,),
        const SizedBox(width: 10),
         Icon(icon,color:iconColor),
      ],
    ),);
}

void getImageFile({Function(File file)? onFileSelected})async{

    FilePickerResult? result = await FilePicker.platform.pickFiles(dialogTitle: "أختر صورة",type: FileType.image,allowCompression: true);

    if (result != null) {
        File file = File(result.files.single.path!);
        onFileSelected!(file);
    } else {
    Fluttertoast.showToast(msg: "يجب ان تختار صورة");
    }

}


void getVideoFile({Function(File file)? onVideoSelected})async{

FilePickerResult? result = await FilePicker.platform.pickFiles(dialogTitle: "أختر فيديو",type: FileType.video,allowCompression: true);

if (result != null) {
File file = File(result.files.single.path!);
 onVideoSelected!(file);
} else {
Fluttertoast.showToast(msg: "يجب ان تختار فيديو");
}

}

void getBookFile({Function(File file)? onFileSelected}) async{

  FilePickerResult? result = await FilePicker.platform.pickFiles(
    dialogTitle: "أختر الكتاب",
    type: FileType.custom,
    allowedExtensions:['pdf'],

  );
  if (result != null) {
    File file = File(result.files.single.path!);
    onFileSelected!(file);
  } else {
  Fluttertoast.showToast(msg: "يجب ان تختارملف");
  }

}


void showReasonDialog({String? title,String? initialValue="",String? lable="السبب ؟",Function(String reason)? onPress}) {
  final _formKey = GlobalKey<FormState>();
String _reason="";
  Get.dialog( Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            scrollable: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
            title: CustomText(text:title!,alignment: Alignment.centerRight,),
            content: Form(
              key: _formKey,
              child: TextFormField(
                initialValue: initialValue,
                validator: (String? value) {
              if (value!.isEmpty)
              {
              return "يجب ان تدخل "+ (lable=="السبب ؟"?"سبب الايقاف":lable!);
              }
              else if(lable=="السعر"&& !GetUtils.isNum(value))
              {
                return "يجب ان تدخل قيمة رقمية";
              }
              },
            onSaved: (value){
                  _reason=value!;
                   },
                decoration: InputDecoration(
                    labelText:lable,
                    labelStyle: const TextStyle(fontSize: 12)),
              ),
            ),
            actions: <Widget>[
            TextButton(
                onPressed: ()=>Get.back(),
                child:const Text("إلغاء", style: TextStyle(fontSize: 13))),
             TextButton(
                onPressed:
                        (){
                            if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            onPress!(_reason);
                          }
                        },
                child:const Text("تاكيد",
                            style:
                            TextStyle(fontSize: 13, color: Colors.red)))
            ],
          ),
        ));


}
