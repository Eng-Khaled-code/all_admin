// ignore_for_file: prefer_const_constructors_in_immutables
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:middleman_all/Controller/data/admin_controller.dart';
import 'package:middleman_all/Models/ecommerce/product_model.dart';
import 'package:middleman_all/View/home/ecommerce/products_page/product_card.dart';
import 'package:middleman_all/View/widgets/constant.dart';
import 'package:middleman_all/View/widgets/custom_selection_list.dart';
import 'search_field.dart';
class EcommercePage extends StatefulWidget {

   EcommercePage({Key? key}) : super(key: key);

  @override
  State<EcommercePage> createState() => _EcommercePageState();
}

class _EcommercePageState extends State<EcommercePage> {
  final AdminController _adminController=Get.find();

  @override
  Widget build(BuildContext context) {

  return  Column(
        children: [
          _searchWidget(),
          _categoryWidget(),
          _dataWidget()

        ],
      
    );
  }

  _dataWidget(){
    return Expanded(
      child: RefreshIndicator(
        onRefresh: ()async{
            await _adminController.operations(moduleName: "ecommerce",operationType: "load");
          },
        child: Obx(()=>

          _adminController.isLoading.value
      ?
      loadingWidget()
        :
      _checkEmpty()
      ?
      noDataCard(text: "لا توجد منتجات",icon: Icons.shopping_basket)
        :ListView.builder(
            itemCount:_adminController.products.length,
            itemBuilder: (context,position){
              ProductModel _model=ProductModel.fromSnapshot(_adminController.products[position]);
              return
                _model.category==selectedCategory
              ?
              ProductCard(model:_model,type: "admin",adminController: _adminController,)
              :
              Container();
            }

        ),),
      ),
    );}

  bool _checkEmpty(){
    bool value=false;
    for (var element in _adminController.products) {
      value=element['category']==selectedCategory?false:true;
      if(value==false){
        break;}
    }
    return value;
  }

  CustomSelectionList _categoryWidget() {
    return CustomSelectionList(list:categoriesList,listType: "category_model_list",onTap:  (String? text){
    setState(()=> selectedCategory=text!);
    });
  }

SearchField _searchWidget() {
      return SearchField(lable: "بحث بإسم المنتج ...",onChange: (value){
        _adminController.productsSearch(value: value);
        setState((){});
      },);

  }
}