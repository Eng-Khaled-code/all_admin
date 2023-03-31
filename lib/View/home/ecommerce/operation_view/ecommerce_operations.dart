import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:middleman_all/Controller/data/ecommerce_controller.dart';
import 'package:middleman_all/View/home/ecommerce/operation_view/product_image.dart';
import 'package:middleman_all/View/widgets/constant.dart';
import 'package:middleman_all/View/widgets/custom_button.dart';
import 'package:middleman_all/View/widgets/custom_selection_list.dart';
import 'package:middleman_all/View/widgets/custom_textfield.dart';
class EcommerceOperations extends StatefulWidget {
  EcommerceOperations({Key? key,}) :super(key: key);
  static String? addOrUpdate="إضافة";
  static int? productId=0;
  static String? productName="";
  static String? productDescription="";
  static String? productUnit="";
  static String? price="";
  static String? quantity="";
  static String? imageUrl="";
  @override
  State<EcommerceOperations> createState() => _EcommerceOperationsState();
}

class _EcommerceOperationsState extends State<EcommerceOperations> {
  final _formKey = GlobalKey<FormState>();
  final EcommerceController ecommerceController=Get.find();


  @override
  void dispose() {
    ProductImageState.imageFile=null;
    ProductImageState.imagePath="";
    EcommerceOperations.productId=0;
    EcommerceOperations.productName="";
    EcommerceOperations.productDescription="";
    EcommerceOperations.productUnit="";
    EcommerceOperations.price="";
    EcommerceOperations.quantity="";
    EcommerceOperations.imageUrl="";
    super.dispose();

  }

  @override
  void initState() {
    ProductImageState.imagePath=EcommerceOperations.imageUrl;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
  return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Obx(
            () =>
            Form(
              key: _formKey,
              child: ecommerceController.isLoading.value ? loadingWidget(): SingleChildScrollView(
                child: Column(
                  children: [

                    CustomSelectionList(list:categoriesList,listType: "ecommerce_category_list",onTap:  (String? text){
                    setState(()=> selectedCategory=text!);
                    }),
                    const SizedBox(height: 15.0),
                    ProductImage(),
                    const SizedBox(height: 15.0),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                CustomTextField(
                                  initialValue: EcommerceOperations.productName,
                                  lable: "اسم المنتج",
                                  onSave: (value) {
                                   EcommerceOperations.productName=value;
                                  },), const SizedBox(height: 15.0),
                                CustomTextField(
                                  initialValue: EcommerceOperations.quantity,
                                  lable: "الكمية",
                                  onSave: (value) {
                                  EcommerceOperations.quantity=value;
                                  },),
                                const SizedBox(height: 15.0),
                                CustomTextField(
                                  initialValue: EcommerceOperations.productUnit,
                                  lable: "الوحدة",
                                  onSave: (value) {
    EcommerceOperations.productUnit= value;
                                  },),
                                const SizedBox(height: 15.0),
                                CustomTextField(
                                  initialValue: EcommerceOperations.price,
                                  lable: "السعر",
                                  onSave: (value) {
    EcommerceOperations.price=value;
                                  },),
                                const SizedBox(height: 15.0),
                                CustomTextField(
                                  initialValue: EcommerceOperations.productDescription,
                                  lable: "تفاصيل اكثر",
                                  onSave: (value) {
    EcommerceOperations.productDescription= value;
                                  },),

                                const SizedBox(height: 25.0),
                                CustomButton(
                                    color: const[
                                      primaryColor,
                                      Color(0xFF0D47A1),
                                    ],
                                    text: EcommerceOperations.addOrUpdate,
                                    onPress: () {
                                      _formKey.currentState
                                      !.save();
                                      bool imageCondation=
                                      (ProductImageState.imageFile==null&&EcommerceOperations.addOrUpdate=="إضافة")
                                      ||
                                      (EcommerceOperations.addOrUpdate=="تعديل"&&(ProductImageState.imageFile==null||ProductImageState.imagePath==""));
                                      if(  imageCondation )
                                      {
                                        Fluttertoast.showToast(msg:"يجب ان تختار صورة للمنتج");
                                      }
                                      else if(_formKey.currentState!.validate()){
                                               ecommerceController.addOrUpdateDeleteProduct(
                                      addOrUpdateOrDelete:EcommerceOperations.addOrUpdate=="إضافة"?"add":"update",
                                      category:selectedCategory,
                                      imageFile:ProductImageState.imageFile,
                                      imageUrl:EcommerceOperations.imageUrl,
                                      moreDetails:EcommerceOperations.productDescription,
                                      name:EcommerceOperations.productName,
                                      quantity:EcommerceOperations.quantity,
                                      unit:EcommerceOperations.productUnit,
                                      price:EcommerceOperations.price,
                                      productId:EcommerceOperations.productId
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

}