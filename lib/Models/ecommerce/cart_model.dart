
class CartModel {

  int?id;
  int?productId;
  int?productQuantity;
  String? productName;
  String? productImage;
  int? userId;
  String? username;
  String? userImage;
  int? itemCount;
  String? itemPrice;
  String? totalPrice;
  int?   cartStatus;

  CartModel({
    this.id,
    this.productName,
    this.username,
    this.productImage,
    this.totalPrice,
    this.itemPrice,
    this.itemCount,
    this.userId,
    this.userImage,
    this.cartStatus,this.productId,this.productQuantity});

  factory CartModel.fromSnapshot(Map<String,dynamic> data){
    return CartModel
      (
        id: data['cart_id']??0,
        productImage: data["product_image"]??"",
        username: data["username"]??"",
        productName: data["product_name"]??"",
        totalPrice: data["total_price"].toString(),
        itemPrice: data["item_price"].toString(),
        itemCount: data['item_count']??0,
        cartStatus: data['cart_status']??0,
        userImage: data["user_image"]??"",
      userId: data["user_id"]??0,
      productId: data["product_id"]??0,
      productQuantity: data["product_quantity"]??0,

    );
  }
}
