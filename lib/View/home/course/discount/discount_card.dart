import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:middleman_all/Controller/data/courses_controller.dart';
import 'package:middleman_all/Models/ecommerce/discount_model.dart';
import 'package:middleman_all/View/home/ecommerce/discount/operation_dialog.dart';
import 'package:middleman_all/View/widgets/constant.dart';
import 'package:middleman_all/View/widgets/constant2.dart';
import 'package:middleman_all/View/widgets/custom_text.dart';
class DiscountCard extends StatelessWidget {
  final DiscountModel? model;
  final CoursesController? courseController;
  const DiscountCard({Key? key,this.model,this.courseController}):super(key: key);


  @override
  Widget build(BuildContext context){

    return  Container(
          margin:const EdgeInsets.symmetric(vertical: 4.0,horizontal: 8.0),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            _topRow(context),
            _dataWidget(),

          ],

      ),
    );
  }

  Row _topRow(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
         crossAxisAlignment: CrossAxisAlignment.start,
        children: [
    _buildingStatusWidget(),
    dateWidget(model!.createdAt!,"create"),
    //its parameters is onUpdate and onDelete
    operationRow(()=>
        operationDialog(type: "تعديل العرض",id: model!.id,name: model!.name,
            desc: model!.description,persentage: model!.percentage,endTime: model!.endTime,controller:courseController ),
        ()async{
      Get.back();
       await courseController!.discountOperations(
     disId: model!.id,type: "delete",status:model!.status==0?1:0);},true),
    ],
    );
  }

  InkWell _buildingStatusWidget() {
    return InkWell(
      onTap:()=>
          showDialogFor(
              contentText:(model!.status==0?"هل بالفعل تريد تفعيل هذا العرض":"هل بالفعل تريد ايقاف هذا العرض"),
              title: "تغيير" ,onPress: ()async{
            Get.back();
            await courseController!.discountOperations(
            disId: model!.id,type: "change status",status:model!.status==0?1:0);
          }),
      child: coloredContainer(text:model!.status==0?"متوقف":"فعال" ),
    );
  }

  Padding _dataWidget(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(text:model!.name!+"  نسبة الخصم :  "+model!.percentage!,fontSize: 20,fontWeight: FontWeight.bold,),
          CustomText(text: "تفاصيل اكثر : ${model!.description}",color: Colors.grey,alignment: Alignment.centerRight,maxLine: 3,textAlign: TextAlign.right,),
          dateWidget(model!.endTime!,"end"),
          dateWidget(model!.modifiedAt!,"modify"),
          model!.status==1?Container():dateWidget(model!.deletedAt!,"delete")
        ],
      ),
    );
  }
}

