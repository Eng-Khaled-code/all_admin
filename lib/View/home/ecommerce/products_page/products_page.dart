import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:middleman_all/Controller/data/ecommerce_controller.dart';
import 'package:middleman_all/View/widgets/constant.dart';
import 'package:middleman_all/View/widgets/custom_selection_list.dart';
import 'product_card.dart';
class ProductPage extends StatefulWidget {

  const ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final EcommerceController _ecommerceDataController=Get.find();

  @override
  Widget build(BuildContext context) {
    return  Column(
        children: [
          CustomSelectionList(list:categoriesList,listType: "ecommerce_category_list",onTap:  (String? text){
          setState(()=> selectedCategory=text!);
          }),
         _dataWidget()

        ],
      
    );
  }

  _dataWidget(){
    return Expanded(
      child: RefreshIndicator(
          onRefresh: ()async{
            await _ecommerceDataController.loadDiscountsAndCategoryAndProductsList("refresh");
          },
          child: Obx(()=>

          _ecommerceDataController.isLoading.value
    ?
    loadingWidget()
        :
    _checkEmpty()
    ?
    noDataCard(text: "لا توجد منتجات",icon: Icons.shopping_basket)
        :SizedBox(
            child: ListView.builder(
                itemCount:_ecommerceDataController.productList.length,
                itemBuilder: (context,position){
                  return
                    _ecommerceDataController.productList[position].category==selectedCategory
                  ?
                  ProductCard(model:_ecommerceDataController.productList[position],ecomerceController: _ecommerceDataController)
                  :
                  Container();
                }

            )),)
          ),
    );}

  bool _checkEmpty(){
    bool value=false;
    for (var element in _ecommerceDataController.productList) {
      value=element.category==selectedCategory?false:true;
      if(value==false){
        break;}
    }
    return value;
  }
}