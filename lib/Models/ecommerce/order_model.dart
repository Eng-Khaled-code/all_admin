
import 'dart:convert';
import 'address_model.dart';

class OrderModel{

  int? orderId;
  String? createdAt;
  List? orderCartList;
  AddressModel? addressModel;

  OrderModel({this.orderId,this.createdAt,this.addressModel,this.orderCartList});

  factory OrderModel.fromSnapshot(Map<String,dynamic> data){
    return OrderModel
      (
        orderId: data['id']??0,
        createdAt: data["created_at"]??"",
        addressModel: AddressModel.fromSnapshot(json.decode(data["address"])),
        orderCartList: json.decode(data['cart_data']??"[]"),

    );
  }


}
