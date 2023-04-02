import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:middleman_all/Controller/data/admin_controller.dart';
import 'package:middleman_all/Models/main_admin/category_model.dart';
import 'package:middleman_all/View/home/ecommerce/discount/operation_dialog.dart';
import 'package:middleman_all/View/widgets/constant.dart';
import 'package:middleman_all/View/widgets/custom_text.dart';

import '../../../utilities/strings.dart';

class CategoryCard extends StatelessWidget {
  final CategoryModel? model;
  final AdminController? adminController;
  const CategoryCard({Key? key,this.model,this.adminController}):super(key: key);


  @override
  Widget build(BuildContext context){

    return  InkWell(
      onTap: ()=>
          operationDialog(type: "تعديل القسم",id: model!.id,name: model!.name,desc: model!.description,controller:adminController ),
      child: Container(
            margin:const EdgeInsets.symmetric(vertical: 4.0,horizontal: 8.0),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              _topRow(context),
              _dataWidget(),

            ],

        ),
      ),
    );
  }

  Row _topRow(BuildContext context) {
    return Row(
         crossAxisAlignment: CrossAxisAlignment.start,
        children: [
    _buildingStatusWidget(),
     const SizedBox(width: 10),
    customDateWidget(date:model!.createdAt!,fontSize: 14),
    ]
    );
  }

  InkWell _buildingStatusWidget() {
    return InkWell(
      onTap:(){
         if(model!.itemsCount=="0"){
          showDialogFor(
              contentText:(model!.status==0?"هل بالفعل تريد تفعيل هذا القسم":"هل بالفعل تريد ايقاف هذا القسم"),
              title: "تغيير" ,onPress: ()async{
            Get.back();
            await adminController!.operations(
            moduleName: "category",id: model!.id,operationType: "change status",userStatusOrClinicStatus:model!.status==0?"1":"0");
          });}
          else{
            Fluttertoast.showToast(msg: "لا يمكنك ايقاف هذا القسم لانه يحتوي علي منتجات");
         }
          },
      child: coloredContainer(text:model!.status==0?"متوقف":"فعال" ),
    );
  }

  Padding _dataWidget(){
    String details= "يحتوي علي ${model!.itemsCount}${Strings.categoryType=="تسوق"?" منتج":" كورس"} \n الشرح : ${model!.description}";
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(text:model!.name!,fontSize: 20,fontWeight: FontWeight.bold,),
          CustomText(text:details,color: Colors.grey,alignment: Alignment.centerRight,maxLine: 3,textAlign: TextAlign.right,),
          dateWidget(model!.modifiedAt!,"modify"),
          model!.status==1?Container():dateWidget(model!.changeStatusDate!,"status_changed")
        ],
      ),
    );
  }
}

