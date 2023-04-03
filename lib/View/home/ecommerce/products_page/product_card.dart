import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:middleman_all/Controller/data/admin_controller.dart';
import 'package:middleman_all/Controller/data/ecommerce_controller.dart';
import 'package:middleman_all/Models/ecommerce/product_model.dart';
import 'package:middleman_all/View/home/ecommerce/discount/operation_dialog.dart';
import 'package:middleman_all/View/home/ecommerce/operation_view/ecommerce_operations.dart';
import 'package:middleman_all/View/home/home_files/home_page.dart';
import 'package:middleman_all/View/widgets/constant.dart';
import 'package:middleman_all/View/widgets/constant2.dart';
import 'package:middleman_all/View/widgets/custom_text.dart';

// ignore: must_be_immutable
class ProductCard extends StatefulWidget {
  final ProductModel? model;
  final String? type;
  ProductCard(
      {Key? key,
      this.model,
      this.type = "user",
      this.ecomerceController,
      this.adminController})
      : super(key: key);

  late EcommerceController? ecomerceController;
  late AdminController? adminController;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool showDiscountRow = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      decoration: customDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _topRow(),
          _stopWidget(),
          imageWidget(image: widget.model!.imageUrl),
          _dataWidget(),
          _bottomRow()
        ],
      ),
    );
  }

  Row _topRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.type == "user"
          ? [
              coloredContainer(text: widget.model!.category!),
              Row(children: [
                customDateWidget(date: widget.model!.date!),
                _operationRow(),
              ])
            ]
          : [
              adminProfileWidget(
                  name: widget.model!.adminName,
                  image: widget.model!.adminImage,
                  date: widget.model!.date),
              _productAdminStatus()
            ],
    );
  }

  Widget _operationRow() {
    return operationRow(() {
      currentIndex = 2;
      EcommerceOperations.addOrUpdate = "تعديل";
      EcommerceOperations.productDescription = widget.model!.desc;
      EcommerceOperations.quantity = widget.model!.quantity.toString();
      EcommerceOperations.productId = widget.model!.productId;
      EcommerceOperations.price = widget.model!.price;
      EcommerceOperations.productName = widget.model!.name;
      EcommerceOperations.productUnit = widget.model!.unit;
      EcommerceOperations.imageUrl = widget.model!.imageUrl;
      setState(() {});
    }, () async {
      Get.back();
      await widget.ecomerceController!.addOrUpdateDeleteProduct(
          productId: widget.model!.productId,
          imageUrl: widget.model!.imageUrl,
          addOrUpdateOrDelete: "delete");
    }, true);
  }

  Column _bottomRow() {
    return Column(
      children: [
        const Divider(),
        showDiscountRow
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  widget.model!.discountStatus == 0
                      ? TextButton.icon(
                          onPressed: () =>
                              _showAddUpdateDiscountDialog("إختيار عرض"),
                          icon: const Icon(
                            Icons.add_rounded,
                            size: 20,
                            color: Colors.blue,
                          ),
                          label: const CustomText(
                            text: "إضافة عرض",
                            fontSize: 12,
                          ))
                      : Row(children: [
                          TextButton.icon(
                              onPressed: () => _showAddUpdateDiscountDialog(
                                  "إختيار عرض اخر"),
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.blue,
                                size: 20,
                              ),
                              label: const CustomText(
                                  text: "إختيار عرض اخر", fontSize: 12)),
                          TextButton.icon(
                              onPressed: () => showDialogFor(
                                  contentText:
                                      "هل بالفعل تريد إلغاء العرض  حيث ان نسبةالخصم تساوي   : " +
                                          widget.model!.descountPercentage! +
                                          " % ",
                                  title: "إلغاء العرض",
                                  onPress: () async {
                                    Get.back();
                                    await widget.ecomerceController!
                                        .addOrUpdateDeleteProductDiscount(
                                            discountId:
                                                widget.model!.discountId,
                                            type: "delete",
                                            productId: widget.model!.productId);
                                  }),
                              icon: const Icon(
                                Icons.close,
                                color: Colors.blue,
                                size: 20,
                              ),
                              label: const CustomText(
                                  text: "إيقاف العرض", fontSize: 12))
                        ]),
                ],
              )
            : Container(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            likeWidget(
                counter: "${widget.model!.likeCount}",
                icon: Icons.favorite,
                iconColor: Colors.pink),
            _discountWidget(),
            _quantityAttentionWidget()
          ],
        ),
      ],
    );
  }

  void _showAddUpdateDiscountDialog(String type) {
    Get.dialog(
      Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          scrollable: true,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          title: CustomText(
            text: type,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("إلغاء"))
          ],
          content: SizedBox(
            height:
                widget.ecomerceController!.discountList.isEmpty || _checkEmpty()
                    ? 120
                    : 300,
            child: widget.ecomerceController!.discountList.isEmpty ||
                    _checkEmpty()
                ? _discountEmptyCart()
                : ListView.builder(
                    itemCount: widget.ecomerceController!.discountList.length,
                    itemBuilder: (context, position) {
                      return _discountCard(position, type);
                    }),
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  Container _quantityAttentionWidget() {
    String text = widget.model!.mainAdminStatus == 0
        ? "غير معروض"
        : (widget.model!.quantity! > 5
            ? "معروض الان"
            : widget.model!.quantity! > 0
                ? "علي وشك الانتهاء"
                : "غير معروض");
    IconData icon = widget.model!.mainAdminStatus == 0
        ? Icons.close
        : (widget.model!.quantity! > 5
            ? Icons.more
            : widget.model!.quantity! > 0
                ? Icons.error
                : Icons.close);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 40,
      child: Row(
        children: [
          CustomText(
            text: text,
            color: Colors.grey,
          ),
          const SizedBox(width: 10),
          Icon(icon,
              color: widget.model!.quantity! > 5
                  ? primaryColor
                  : widget.model!.quantity! > 0
                      ? Colors.pink
                      : Colors.red),
        ],
      ),
    );
  }

  InkWell _discountWidget() {
    return InkWell(
      onTap: () {
        if (widget.type == "user") {
          setState(() => showDiscountRow = !showDiscountRow);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 40,
        child: Row(
          children: [
            CustomText(
              text: widget.model!.discountStatus == 0
                  ? "لا يوجد خصم"
                  : "${widget.model!.descountPercentage}%",
              color: Colors.grey,
            ),
            const SizedBox(width: 10),
            const Icon(
              Icons.money_off,
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Padding _dataWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          CustomText(
            text: widget.model!.name!,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          CustomText(
            text: "الكمية : ${widget.model!.quantity} ${widget.model!.unit}   ||   سعر الوحدة : ${widget.model!.price}" +
                (widget.model!.discountId! == 0
                    ? ""
                    : "   ||   بعد الخصم : ${widget.model!.priceAfterDiscount}"),
            color: Colors.grey,
            alignment: Alignment.centerRight,
            textAlign: TextAlign.right,
          ),
          CustomText(
            text: "تفاصيل اكثر : ${widget.model!.desc}",
            color: Colors.grey,
            alignment: Alignment.centerRight,
            maxLine: 3,
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }

  bool _checkEmpty() {
    bool value = false;
    for (var element in widget.ecomerceController!.discountList) {
      value = element.status == 1 ? false : true;
      if (value == false) {
        break;
      }
    }
    return value;
  }

  Container _discountEmptyCart() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: Colors.grey[100],
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.circular(10)),
      width: double.infinity,
      child: Column(
        children: const [
          CustomText(
            text: "لا توجد عروض",
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          CustomText(
              text: "يمكنك إضافة عروض من خلال شاشة العروض والخصومات",
              color: Colors.grey,
              maxLine: 3)
        ],
      ),
    );
  }

  Widget _discountCard(int position, String type) {
    return widget.ecomerceController!.discountList[position].status == 0
        ? Container()
        : InkWell(
            onTap: () async {
              Get.back();
              await widget.ecomerceController!.addOrUpdateDeleteProductDiscount(
                  discountId:
                      widget.ecomerceController!.discountList[position].id,
                  type: type == "إختيار عرض" ? "add" : "update",
                  productId: widget.model!.productId);
            },
            child: Container(
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(10)),
              width: double.infinity,
              child: Column(
                children: [
                  CustomText(
                    text: widget
                            .ecomerceController!.discountList[position].name! +
                        "  نسبة الخصم : " +
                        widget.ecomerceController!.discountList[position]
                            .percentage!,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  dateWidget(
                      widget
                          .ecomerceController!.discountList[position].endTime!,
                      "end"),
                ],
              ),
            ),
          );
  }

  Widget _productAdminStatus() {
    return IconButton(
        onPressed: () => widget.model!.mainAdminStatus == 1
            ? _showReasonDialog()
            : _showAcceptDialog(),
        icon: Icon(widget.model!.mainAdminStatus == 0
            ? Icons.visibility_off
            : Icons.visibility));
  }

  void _showReasonDialog() {
    showReasonDialog(
        title: "هل تريد إيقاف عرض هذا المنتج",
        onPress: (comingReason) async {
          Navigator.pop(context);
          await widget.adminController!.operations(
            id: widget.model!.productId,
            operationType: "change status",
            moduleName: "ecommerce",
            userStatusOrClinicStatus: "0",
            passwordOrStopReason: comingReason,
            emailOrAdminToken: widget.model!.adminToken,
          );
        });
  }

  void _showAcceptDialog() {
    showDialogFor(
        contentText: "هل تريد إعادة عرض هذا المنتج",
        title: "تأكيد",
        onPress: () async {
          Navigator.pop(context);
          await widget.adminController!.operations(
            id: widget.model!.productId,
            operationType: "change status",
            passwordOrStopReason: "",
            moduleName: "ecommerce",
            userStatusOrClinicStatus: "1",
            emailOrAdminToken: widget.model!.adminToken,
          );
        });
  }

  Widget _stopWidget() {
    return widget.type == "user" && widget.model!.mainAdminStatus == 0
        ? CustomText(
            text: "تم إيقاف العرض لان " + widget.model!.stopReason!,
            color: Colors.red,
          )
        : Container();
  }
}
