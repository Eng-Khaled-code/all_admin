import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:middleman_all/Controller/data/ecommerce_controller.dart';
import 'package:middleman_all/View/home/ecommerce/operation_view/product_image.dart';
import 'package:middleman_all/View/widgets/constant.dart';
import 'package:middleman_all/View/widgets/custom_button.dart';
import 'package:middleman_all/View/widgets/custom_selection_list.dart';
import 'package:middleman_all/View/widgets/custom_textfield.dart';

// ignore: must_be_immutable
class EcommerceOperations extends StatefulWidget {
  EcommerceOperations(
      {Key? key,
      this.addOrUpdate = "إضافة",
      this.productId = 0,
      this.productName = "",
      this.productDescription = "",
      this.productUnit = "",
      this.price = "",
      this.imageUrl = "",
      this.quantity = ""})
      : super(key: key);
  String? addOrUpdate;
  int? productId;
  String? productName;
  String? productDescription;
  String? productUnit;
  String? price;
  String? quantity;
  String? imageUrl;

  @override
  State<EcommerceOperations> createState() => _EcommerceOperationsState();
}

class _EcommerceOperationsState extends State<EcommerceOperations> {
  final _formKey = GlobalKey<FormState>();
  final EcommerceController ecommerceController = Get.find();

  @override
  Widget build(BuildContext context) {
    ProductImageState.imagePath = widget.imageUrl;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Obx(
        () => Form(
          key: _formKey,
          child: ecommerceController.isLoading.value
              ? loadingWidget()
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      CustomSelectionList(
                          list: categoriesList,
                          listType: "ecommerce_category_list",
                          onTap: (String? text) {
                            setState(() => selectedCategory = text!);
                          }),
                      const SizedBox(height: 15.0),
                      const ProductImage(),
                      const SizedBox(height: 15.0),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            CustomTextField(
                              initialValue: widget.productName,
                              lable: "اسم المنتج",
                              onSave: (value) {
                                widget.productName = value;
                              },
                            ),
                            const SizedBox(height: 15.0),
                            CustomTextField(
                              initialValue: widget.quantity,
                              lable: "الكمية",
                              onSave: (value) {
                                widget.quantity = value;
                              },
                            ),
                            const SizedBox(height: 15.0),
                            CustomTextField(
                              initialValue: widget.productUnit,
                              lable: "الوحدة",
                              onSave: (value) {
                                widget.productUnit = value;
                              },
                            ),
                            const SizedBox(height: 15.0),
                            CustomTextField(
                              initialValue: widget.price,
                              lable: "السعر",
                              onSave: (value) {
                                widget.price = value;
                              },
                            ),
                            const SizedBox(height: 15.0),
                            CustomTextField(
                              initialValue:
                                  widget.productDescription,
                              lable: "تفاصيل اكثر",
                              onSave: (value) {
                                widget.productDescription = value;
                              },
                            ),
                            const SizedBox(height: 25.0),
                            CustomButton(
                                color: const [
                                  primaryColor,
                                  Color(0xFF0D47A1)  ],
                                text: widget.addOrUpdate,
                                onPress: () {
                                  _formKey.currentState!.save();
                                  bool imageCondation =
                                      (ProductImageState.imageFile == null &&
                                              widget.addOrUpdate ==
                                                  "إضافة") ||
                                          (widget.addOrUpdate ==
                                                  "تعديل" &&
                                              (ProductImageState.imageFile ==
                                                      null ||
                                                  ProductImageState.imagePath ==
                                                      ""));
                                  if (imageCondation) {
                                    Fluttertoast.showToast(
                                        msg: "يجب ان تختار صورة للمنتج");
                                  } else if (_formKey.currentState!
                                      .validate()) {
                                    ecommerceController
                                        .addOrUpdateDeleteProduct(
                                            addOrUpdateOrDelete:
                                                widget
                                                            .addOrUpdate ==
                                                        "إضافة"
                                                    ? "add"
                                                    : "update",
                                            category: selectedCategory,
                                            imageFile:
                                                ProductImageState.imageFile,
                                            imageUrl:
                                                widget.imageUrl,
                                            moreDetails: widget
                                                .productDescription,
                                            name:
                                                widget.productName,
                                            quantity:
                                                widget.quantity,
                                            unit:
                                                widget.productUnit,
                                            price: widget.price,
                                            productId:
                                                widget.productId);
                                  }
                                },
                                textColor: Colors.white),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
