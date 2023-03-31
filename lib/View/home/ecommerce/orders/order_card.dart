import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:middleman_all/Controller/data/ecommerce_controller.dart';
import 'package:middleman_all/Models/ecommerce/cart_model.dart';
import 'package:middleman_all/Models/ecommerce/order_model.dart';
import 'package:middleman_all/View/widgets/constant.dart';
import 'package:middleman_all/View/widgets/custom_text.dart';
// ignore: must_be_immutable
class OrderCard extends StatelessWidget {
  final OrderModel? model;
  EcommerceController? ecommerceController;
  OrderCard({Key? key,this.model,this.ecommerceController}):super(key: key);

  double totalPrice=0.0;
  int totalItemCount=0;
  @override
  Widget build(BuildContext context){
    _loadingTotal();
    return  Container(
      margin:const EdgeInsets.symmetric(vertical: 8.0,horizontal: 8.0),
      decoration: BoxDecoration(color: Colors.blue,borderRadius: BorderRadius.circular(10),border: Border.all(color: Colors.grey),),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               _topRow(),
              _dataRow(context),
               _itemsList(),
    ],

      ),
    );
  }

  Padding _itemsList(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 330,
        child: ListView.builder(     shrinkWrap: true ,
            scrollDirection: Axis.horizontal,
            itemCount: model!.orderCartList!.length,
            itemBuilder: (context,position){
              return _itemCart(CartModel.fromSnapshot(model!.orderCartList![position]),context);

            }),
      ),
    );
}

  Container _itemCart(CartModel cartModel,BuildContext context){
    return Container(
      width: model!.orderCartList!.length==1?300:220,
      margin:const EdgeInsets.only(left: 10) ,
      padding:const EdgeInsets.all( 5)  ,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        imageWidget(image:cartModel.productImage!,height: 120),
        CustomText(text: cartModel.productName!,alignment: Alignment.centerRight,textAlign: TextAlign.right,fontWeight: FontWeight.bold),
        CustomText(text: "سعر الوحدة : ${cartModel.itemPrice}\n الكمية : ${cartModel.itemCount}\nالسعر الكلي : ${cartModel.totalPrice}",alignment: Alignment.centerRight,textAlign: TextAlign.right,fontWeight: FontWeight.bold,maxLine: 5,),
        InkWell(onTap:(){
          if(cartModel.cartStatus!=1){
          _showQuanitityDialog(context, cartModel.cartStatus!,cartModel);    }
        },child: CustomText(text:cartModel.cartStatus==0?"لم يتم المراجعة إضغط للمراجعة":cartModel.cartStatus==1?" تمت إرسال الكمية المطلوبة":" تم رفض الطلب إضغط للموافقة",alignment: Alignment.centerRight,textAlign: TextAlign.right,color:cartModel.cartStatus==0?Colors.red: Colors.black,fontWeight: FontWeight.bold,)),
      ],
    ),
    );
}

  Padding _topRow(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: adminProfileWidget(name:model!.orderCartList![0]["username"],image:model!.orderCartList![0]["user_image"],date: model!.createdAt!),
    );
  }

  Padding _dataRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child:  Column(children: [
        CustomText(text:"الكمية: "+totalItemCount.toString()+"   ||   السعر الكلي: \$"+totalPrice.toString(),color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold,),
        CustomText(text: "البلد : ${model!.addressModel!.country}  ||  المدينة :  ${model!.addressModel!.city}  ||  الرقم البريدي : ${model!.addressModel!.postCode}\n  الهاتف 1 : ${model!.addressModel!.phone1}  ||  هاتف اخر :  ${model!.addressModel!.phone2} ",color: Colors.white,alignment: Alignment.centerRight,textAlign: TextAlign.right,),
        ],
      ),
    );
  }

  void _showQuanitityDialog(BuildContext context,int cartStatus,CartModel model) {

    showDialog(context:context,builder:(BuildContext context)=>
        Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape:const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
          title:const Text("تنبيه"),
          content:  Text((model.productName!+"  ||  سعر الوحدة: "+model.itemPrice!+"  ||  الكمية: "+model.itemCount.toString()+"  ||  الاجمالي: "+model.totalPrice!),style: const TextStyle(fontSize: 14),),
          actions: <Widget>[
            TextButton(onPressed: ()=>Navigator.pop(context), child:const Text("إلغاء")),
            cartStatus==0?TextButton(onPressed: ()async{
                     Navigator.pop(context);
                     await ecommerceController!.ordersOperation(type: "refuse",cartId:model.id);
            }, child:const Text("رفض")):const SizedBox(width: 2,),
            TextButton(onPressed: ()async{
              Navigator.pop(context);
              if(model.productQuantity! < model.itemCount!){
                Fluttertoast.showToast(msg: "الكمية الموجودة في المخزن غير كافيه");
              }else{
              await ecommerceController!.ordersOperation(type: "accept",productId:model.productId,cartId:model.id,quantity:model.itemCount);  }
            }, child: const Text("موافق"),),
          ],


        ),
      ),

      barrierDismissible: true,
    );
  }

  void _loadingTotal(){
    for(var cart in model!.orderCartList!)
    {

      totalPrice+= cart['total_price'];
      totalItemCount+= cart['item_count'] as int;

  }
  }

}
