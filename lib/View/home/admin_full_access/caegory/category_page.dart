import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:middleman_all/Controller/data/admin_controller.dart';
import 'package:middleman_all/Models/main_admin/category_model.dart';
import 'package:middleman_all/View/widgets/constant.dart';
import 'package:middleman_all/View/widgets/custom_selection_list.dart';
import 'package:middleman_all/start_point/app_constant.dart';
import 'category_card.dart';

class CategoryPage extends StatefulWidget {
  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final AdminController _adminController=Get.find();

  @override
  Widget build(BuildContext context) {
    return  Column(
        children:[
      _categoryTypeWidget(),
      _dataWidget()
    ]
    );
  }

   _dataWidget(){
    return Expanded(
        child:RefreshIndicator(
      onRefresh: ()async{
      await _adminController.operations(moduleName: "category",operationType: "load");
      setState(() {
      });
      },
      child: Obx(()=>

    _adminController.isLoading.value
          ?
    loadingWidget()
          :
    categoriesList.isEmpty
          ?
    noDataCard(text: "لا توجد اقسام",icon: Icons.category)
          :SizedBox(
        child: ListView.builder(
            itemCount:categoriesList.length,
            itemBuilder: (context,position){
              CategoryModel _model=CategoryModel.fromSnapshot(categoriesList[position]);
              return CategoryCard(model:_model,adminController: _adminController,);
            }
        ),
    ),),
      ),
    );
  }

  CustomSelectionList _categoryTypeWidget() {
    return CustomSelectionList(list:const["تسوق","كورسات"] ,listType: "cate",onTap:  (String? text)async{
    setState(()=> categoryType=text!);
    await _adminController.operations(moduleName: "category",operationType: "load");

    });
  }
}
