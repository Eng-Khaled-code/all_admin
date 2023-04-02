import 'package:flutter/material.dart';
import 'package:middleman_all/View/home/admin/middleman_page.dart';
import 'package:middleman_all/View/home/admin/missed/missed_page.dart';
import 'package:middleman_all/View/home/admin_full_access/users/add_user.dart';
import 'package:middleman_all/View/home/middleman/user_operations.dart';
import '../utilities/strings.dart';
import 'constant.dart';
import 'custom_text.dart';
class CustomSelectionList extends StatelessWidget {
  final List? list;
  final Function(String? text)? onTap;
  final String? listType;
  const CustomSelectionList({Key? key,this.list,this.onTap,this.listType}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(10),
        height: 41,
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount:listType=="userType"? list!.length-1:list!.length,
          itemBuilder: (context,position)=>_typeItem(text: listType=="category_model_list"?list![position]['name']:list![position]),
        ));
  }

  Widget _typeItem({String? text}){
    bool con=getSelectedCondition(text:text);
    return InkWell(
      onTap:(){onTap!(text);},
      child: Container(padding:const EdgeInsets.all(10),  margin :const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16),color: con ?primaryColor:Colors.transparent),
          child: CustomText(text:text! ,color: con?Colors.white:Colors.black,alignment: Alignment.topCenter,)
      ));}

     bool getSelectedCondition({String? text}){
    return text==(
        listType=="missed_status"
            ?
        selectedMissedStatus
            :
        listType=="country"
            ?
        selectedCountry
            :
        listType=="middleman"
            ?
        middlemanType
            :
        listType=="userType"||listType=="userType2"
            ?
        Strings.userType
            :
        listType=="ecommerce_category_list"||listType=="category_model_list"
            ?
        selectedCategory
            :
        listType=="operation"
            ?
        selectedOperation
            :
        listType=="types"
            ?
        selectedMiddlemanType
            :
        listType=="cate"
            ?
        Strings.categoryType
            :
        "");

     }
}
