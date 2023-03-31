import 'dart:convert';

class PlaceModel
{
  int? placeId;
  String? address;
  int?roufNum;
  String? type;
  String? size;
  String? metrePrice;
  String? totalPrice;
  String? operation;
  String? moreDetails;
  int? status;
  int? adminId;
  String? adminName;
  String? adminImage;
  String? adminToken;
  String? rate;
  String? likeCount;
  String? blackCount;
  int? mainAdminStatus;
  String? stopReason;
  List? discussUserList;
  String?date;

  PlaceModel({
    this.placeId,
    this.address,
    this.roufNum,
    this.rate,
    this.type,
    this.size,
    this.metrePrice,
    this.totalPrice,
    this.operation,
    this.moreDetails,
    this.status,
    this.adminId,
    this.stopReason,
    this.mainAdminStatus,
    this.likeCount,
    this.date,
    this.discussUserList,
    this.blackCount,
    this.adminToken,
    this.adminImage,
    this.adminName
  });

  factory PlaceModel.fromSnapshot(Map<String,dynamic> data){
    return PlaceModel
      (
        placeId: data['place_id'],
        address: data['address'],
        roufNum: data['its_rouf_num']??0,
        type: data['type'],
        size: data['size'].toString() ,
        metrePrice: data['metre_price'].toString(),
        totalPrice: data['total_price'].toString(),
        operation: data['operation']??"",
        moreDetails: data['more_details']??"",
        status: data['status'],
        adminId: data['admin_id'],
        likeCount:data['like_count']??"0",
        date: data['date']??"غير محدد",
        discussUserList: json.decode(data['discuss_list']??"[]") ,
      mainAdminStatus: data['main_admin_status']??0,
      stopReason: data['stop_reason']??"",
      rate: data['ratings'].toString(),
      adminName: data['admin_name']??"",
      adminImage:data['image_url']??"",
      adminToken: data['admin_token']??"",
      blackCount: data['black_count']??"0"
    );
  }

}