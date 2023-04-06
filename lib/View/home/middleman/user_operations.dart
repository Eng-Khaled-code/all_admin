import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:middleman_all/Controller/data/middleman_controller.dart';
import 'package:middleman_all/View/widgets/constant.dart';
import 'package:middleman_all/View/widgets/custom_button.dart';
import 'package:middleman_all/View/widgets/custom_selection_list.dart';
import 'package:middleman_all/View/widgets/custom_textfield.dart';

import '../../utilities/strings.dart';
// ignore: must_be_immutable


// ignore: must_be_immutable
class UserOperations extends StatefulWidget {

   String addOrUpdate;
   int? operationId;
   String? txtRoufNum;
   String? txtMoreDetails;
   String? txtArea;
   String? txtPrice;
   String? txtAddress;
   String? selectedMiddlemanType ;
   String? selectedOperation ;
   UserOperations({Key? key,
   this.addOrUpdate="إضافة",
   this.operationId=0 ,
   this.txtRoufNum="",
   this.txtMoreDetails="",
   this.txtAddress="",
   this.txtPrice="",
   this.txtArea="",
   this.selectedMiddlemanType="شقة",
   this.selectedOperation= "بيع"
   }):super(key: key);

  @override
  State<UserOperations> createState() => _UserOperationsState();
}

class _UserOperationsState extends State<UserOperations> {
  final MiddlemanController _operationDataController=Get.find();

  final _formKey=GlobalKey<FormState>();

  List<String> types=["شقة","محل","عمارة","قطعة ارض"];

  List<String> operation=["بيع","إيجار"];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Obx(
            ()=> Form(
          key: _formKey,
          child: _operationDataController.isLoading.value?loadingWidget():
          SingleChildScrollView(
            child: Column(
              children: [
               _typesWidget("types"),
               widget.selectedMiddlemanType=="قطعة ارض"? Container():_typesWidget("operation"),
              const SizedBox(height: 15.0), Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      CustomTextField(
                        initialValue:widget.txtAddress,
                        lable: "العنوان",
                        onSave: (value){
                          widget.txtAddress=value;
                        },), const SizedBox(height: 15.0),
                      CustomTextField(
                        initialValue: widget.txtArea,
                        lable: "المساحة بالمتر المربع",
                        onSave: (value){
                          widget.txtArea= value;
                        },),
                      const SizedBox(height: 15.0),
                      CustomTextField(
                        initialValue:widget.txtPrice ,
                        lable: "سعر المتر",
                        onSave: (value){
                          widget.txtPrice= value;
                        },),
                      widget.selectedMiddlemanType=="عمارة"||widget.selectedMiddlemanType=="شقة"? const SizedBox(height: 15.0):Container(),
                      widget.selectedMiddlemanType=="عمارة"||widget.selectedMiddlemanType=="شقة"? CustomTextField(
                        initialValue:widget.txtRoufNum ,
                        lable:widget.selectedMiddlemanType=="شقة"?"رقم الطابق" :"عدد الطوابق",
                        onSave: (value){
                          widget.txtRoufNum= value;
                        },):Container(),
                      const SizedBox(height: 15.0),
                      CustomTextField(
                        initialValue:widget.txtMoreDetails ,
                        lable: "تفاصيل اكثر",
                        onSave: (value){
                          widget.txtMoreDetails=value;
                        },),

                      const SizedBox(height: 25.0),
                      CustomButton(
                          color: const[
                            primaryColor,
                            Color(0xFF0D47A1),
                          ],
                          text: widget.addOrUpdate,
                          onPress: ()async{
                            _formKey.currentState!.save();
                            if(_formKey.currentState!.validate()){
                            await _operationDataController.addOrUpdateDeleteOperation(
                            addOrUpdate:widget.addOrUpdate=="إضافة"?"add":"update",
                            operation:widget.selectedOperation,
                            type:widget.selectedMiddlemanType,
                            adminId:Strings.globalUserId,
                            moreDetails:widget.txtMoreDetails,
                            roufNum:widget.txtRoufNum,
                            size:widget.txtArea,
                            metrePrice:widget.txtPrice,
                            address:widget.txtAddress,
                            opeId:widget.operationId
                            );
                            }
                          },
                          textColor: Colors.white),
                    ],
                  ),

              ),

              ],),
          ),
        ),
      ),
    );
  }

  Widget _typesWidget(type) {
    return CustomSelectionList(
        list:type=="operation"?operation:types,
        listType: type,
        selectedMiddlemanType: widget.selectedMiddlemanType,
        selectedOperation: widget.selectedOperation,
        onTap:  (String? text){
    if(type=="types"&&widget.addOrUpdate=="إضافة"){
    setState(() =>widget.selectedMiddlemanType=text!);
    }else if(type=="operation"){
    setState(() =>widget.selectedOperation=text!);
    }
    });
  }
}