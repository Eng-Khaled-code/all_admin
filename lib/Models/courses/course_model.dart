class CourseModel
{

  int? id;
  String? name;
  String? imageUrl;
  String? desc;
  String? rate;
  String? date;
  String? category;
  String? usersCount;
  String?usersCountRattings;
  String? likeCount;
  String? blackCount;
  String? videosCount;
  int?status;
  int? discountId;
  String? descountPercentage;
  String? priceAfterDiscount;
  int? userId;
  String? userName;
  String? userImage;
  String? userToken;
  int? discountStatus;
  String?discountEndsIn;
  int? mainAdminStatus;
  String? mainAdminStopReason;
  String? price;

  CourseModel({this.price,this.userId,this.descountPercentage,this.discountEndsIn,this.discountId,this.discountStatus,this.mainAdminStatus,
    this.mainAdminStopReason,this.priceAfterDiscount,this.userImage,this.userName,this.userToken,this.videosCount,this.status,this.id,this.likeCount,this.blackCount,this.name,this.imageUrl,this.desc,this.rate,this.category,this.date,this.usersCount,this.usersCountRattings});

  factory CourseModel.fromSnapshot(Map<String,dynamic> data){

    return CourseModel
      (
        id: data["id"]??0,
        name: data["name"]??"",
        desc: data["desc"]??"",
        imageUrl: data["image_url"]??"",
        blackCount: data["black_count"]??"0",
        likeCount: data["like_count"]??"0",
        usersCountRattings: data["user_count_rating"]??"0",
        usersCount: data["user_count"]??"0",
        rate: data["rate"].toString(),
        category: data["category"]??"",
        date: data["date"]??"",
        status:data['status']??0,
        videosCount: data["video_count"]??"0",
      userId: data['user_id']??0,
      userName: data['username']??"",
      userImage:data['image_url']??"",
      userToken: data['user_token']??"",
      price: data['price'].toString(),
      discountId: data['discount_id']??0,
      descountPercentage: data['dis_percentage'].toString(),
      priceAfterDiscount: data['price_after_dis'].toString(),
      discountEndsIn: data['dis_end_in']??"",
      discountStatus:data['dis_status']??0,
      mainAdminStatus: data['main_admin_status']??0,
      mainAdminStopReason: data['main_admin_stop_reason']??"",
    );
  }

}