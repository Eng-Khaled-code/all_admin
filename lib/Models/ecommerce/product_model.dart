
class ProductModel
{
  int? productId;
  String? name;
  String? desc;
  String? unit;
  String? category;
  int? quantity;
  String? price;
  int? discountId;
  String? descountPercentage;
  String? priceAfterDiscount;
  int? adminId;
  String? adminName;
  String? adminImage;
  String? adminToken;
  String? rate;
  String? blackCount;
  String? date;
  String? imageUrl;
  int? discountStatus;
  String?discountEndsIn;
  String? likeCount;
  int? mainAdminStatus;
  String? stopReason;

  ProductModel({
    this.date,
    this.adminId,
    this.name,
    this.price,
    this.productId,
    this.quantity,
    this.category,
    this.desc,
    this.descountPercentage,
    this.discountEndsIn,
    this.discountId,
    this.discountStatus,
    this.priceAfterDiscount,
    this.unit,
    this.imageUrl,
    this.likeCount,
    this.mainAdminStatus,
    this.stopReason,
    this.rate,
    this.adminName,
    this.adminImage,
    this.adminToken,
    this.blackCount,
  });

  factory ProductModel.fromSnapshot(Map<String,dynamic> data){
    return ProductModel
      (
        productId: data['product_id']??0,
        mainAdminStatus: data['main_admin_status']??0,
        stopReason: data['stop_reason']??"",
        name: data['product_name']??"",
        desc: data['description']??"",
        unit: data['unit']??"",
        category: data['category']??"",
        quantity: data['quantity']??0,
        price: data['price'].toString(),
        discountId: data['discount_id']??0,
        descountPercentage: data['dis_percentage'].toString(),
        priceAfterDiscount: data['price_after_dis'].toString(),
        adminId: data['admin_id']??0,
        imageUrl: data['image_url']??"",
        discountEndsIn: data['dis_end_in']??"",
        discountStatus:data['dis_status']??0,
        likeCount:data['like_count']??"0",
        date: data['date']??"غير محدد",
        rate: data['ratings'].toString(),
        adminName: data['admin_name']??"",
        adminImage:data['image_url']??"",
        adminToken: data['admin_token']??"",
        blackCount: data['black_count']??"0"

    );
  }

}