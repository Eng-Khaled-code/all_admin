import 'dart:convert';

class DiscussModel
{
  int? userId;
  String? userName;
  String? imageUrl;
  List? discusPhones;
  String? token;
  String? date;
  String? status;

  DiscussModel({this.userId,this.status,this.date,this.userName,this.token,this.discusPhones,this.imageUrl});

  factory DiscussModel.fromSnapshot(Map<String,dynamic> data){
    return DiscussModel
      (
        userId: data['user_id'],
      token: data["token"]??"",
      userName: data["username"]??"",
        imageUrl: data["image_url"]??"",
      discusPhones: json.decode(data['phones']??"[]") ,
      date:data['date']??'',
      status: data["status"]??'discuss'
    );
  }

}