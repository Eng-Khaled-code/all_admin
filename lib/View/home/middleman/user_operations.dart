import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:middleman_all/Controller/data/middleman_controller.dart';
import 'package:middleman_all/View/widgets/constant.dart';
import 'package:middleman_all/View/widgets/custom_button.dart';
import 'package:middleman_all/View/widgets/custom_selection_list.dart';
import 'package:middleman_all/View/widgets/custom_textfield.dart';

import '../../utilities/strings.dart';
// ignore: must_be_immutable
String selectedMiddlemanType = "شقة";
String selectedOperation = "بيع";

class UserOperations extends StatefulWidget {

  static String addOrUpdate="إضافة";
  static int? operationId=0;
  static String? txtRoufNum="";
  static String? txtMoreDetails="";
  static String? txtArea="";
  static String? txtPrice="";
  static String? txtAddress="";

  const UserOperations({Key? key}):super(key: key);

  @override
  State<UserOperations> createState() => _UserOperationsState();
}

class _UserOperationsState extends State<UserOperations> {

  final MiddlemanController _operationDataController=Get.find();

  final _formKey=GlobalKey<FormState>();

  List<String> types=["شقة","محل","عمارة","قطعة ارض"];

  List<String> operation=["بيع","إيجار"];

  @override
  void dispose() {
    super.dispose();
    UserOperations.addOrUpdate="إضافة";
    UserOperations.operationId=0;
    UserOperations.txtRoufNum="";
    UserOperations.txtMoreDetails="";
    UserOperations.txtArea="";
    UserOperations.txtAddress="";
    UserOperations.txtPrice="";
    selectedMiddlemanType = "شقة";
    selectedOperation = "بيع";
  }

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
               selectedMiddlemanType=="قطعة ارض"? Container():_typesWidget("operation"),
              const SizedBox(height: 15.0), Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      CustomTextField(
                        initialValue: UserOperations.txtAddress,
                        lable: "العنوان",
                        onSave: (value){
                          UserOperations.txtAddress=value;
                        },), const SizedBox(height: 15.0),
                      CustomTextField(
                        initialValue: UserOperations.txtArea,
                        lable: "المساحة بالمتر المربع",
                        onSave: (value){
                          UserOperations.txtArea= value;
                        },),
                      const SizedBox(height: 15.0),
                      CustomTextField(
                        initialValue:UserOperations.txtPrice ,
                        lable: "سعر المتر",
                        onSave: (value){
                          UserOperations.txtPrice= value;
                        },),
                      selectedMiddlemanType=="عمارة"||selectedMiddlemanType=="شقة"? const SizedBox(height: 15.0):Container(),
                      selectedMiddlemanType=="عمارة"||selectedMiddlemanType=="شقة"? CustomTextField(
                        initialValue:UserOperations.txtRoufNum ,
                        lable:selectedMiddlemanType=="شقة"?"رقم الطابق" :"عدد الطوابق",
                        onSave: (value){
                          UserOperations.txtRoufNum= value;
                        },):Container(),
                      const SizedBox(height: 15.0),
                      CustomTextField(
                        initialValue:UserOperations.txtMoreDetails ,
                        lable: "تفاصيل اكثر",
                        onSave: (value){
                          UserOperations.txtMoreDetails=value;
                        },),

                      const SizedBox(height: 25.0),
                      CustomButton(
                          color: const[
                            primaryColor,
                            Color(0xFF0D47A1),
                          ],
                          text: UserOperations.addOrUpdate,
                          onPress: (){
                            _formKey.currentState!.save();
                            if(_formKey.currentState!.validate()){
                            _operationDataController.addOrUpdateDeleteOperation(
                            addOrUpdate:UserOperations.addOrUpdate=="إضافة"?"add":"update",
                            operation:selectedOperation,
                            type:selectedMiddlemanType,
                            adminId:Strings.globalUserId,
                            moreDetails:UserOperations.txtMoreDetails,
                            roufNum:UserOperations.txtRoufNum,
                            size:UserOperations.txtArea,
                            metrePrice:UserOperations.txtPrice,
                            address:UserOperations.txtAddress,
                            opeId:UserOperations.operationId
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
        list:type=="operation"?operation:types,listType: type,
        onTap:  (String? text){
    if(type=="types"&&UserOperations.addOrUpdate=="إضافة"){
    setState(() =>selectedMiddlemanType=text!);
    }else if(type=="operation"){
    setState(() =>selectedOperation=text!);
    }
    });
  }
}