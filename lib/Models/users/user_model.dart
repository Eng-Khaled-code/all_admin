
import 'dart:convert';

class UserModel
{
  int? userId;
  String? userName;
  String? email;
  String? address;
  String? lat;
  String? long;
  String? imageUrl;
  String? token;
  String? ratingValue;
  String? userType;
  String? aboutDoctor;
  String? closingReson;
  int? clinickStatus;
  int? userStatus;
  List? phones;
  List? coutries;
  String? createdAt;

  UserModel({
    this.userId,
    this.userName,
    this.email,
    this.address,
    this.lat,
    this.long,
    this.imageUrl,
    this.token,
    this.ratingValue,
    this.clinickStatus,
    this.userType,
    this.aboutDoctor,
    this.closingReson
  });

  UserModel.forAdmin({
    this.userId,
    this.userName,
    this.email,
    this.address,
    this.long,
    this.lat,
    this.imageUrl,
    this.token,
    this.ratingValue,
    this.clinickStatus,
    this.userType,
    this.aboutDoctor,
    this.closingReson,
    this.phones,
    this.coutries,
    this.createdAt,
    this.userStatus
  });


  factory UserModel.fromSnapshot(Map<String,dynamic> data){
    return UserModel
      (
        userId: data['user_id'],
        userName: data["username"]??"",
        email: data['email']??"",
        address: data["address"]??"",
        imageUrl: data["image_url"]??"",
        token: data['token']??"",
        ratingValue: data['rating'].toString(),
      lat: data['lat'].toString(),
      long: data['long'].toString(),
      userType: data["user_type"]??"",
       aboutDoctor: data['about_doctor']??"",
      clinickStatus: data['d_clinick_status']??0,
      closingReson: data['d_closing_reason']??"",
    );
  }



  factory UserModel.fromSnapshotForAdmin(Map<String,dynamic> data){
    return UserModel.forAdmin
      (
      userId: data['user_id'],
      userName: data["username"]??"",
      email: data['email']??"",
      address: data["address"]??"",
      imageUrl: data["image_url"]??"",
      token: data['token']??"",
      ratingValue: data['rating'].toString(),
      userType: data["type"]??"",
      aboutDoctor: data['about_doctor']??"",
      clinickStatus: data['d_clinick_status']??0,
      closingReson: data['d_closing_reason']??"",
      phones: jsonDecode(data['phones']??'[]'),
      coutries: jsonDecode(data['countries']??'[]'),
      createdAt:data['created_at']??"",
      userStatus: data['status']??0,
      lat: data['lat'].toString(),
      long: data['long'].toString(),
    );
  }
}