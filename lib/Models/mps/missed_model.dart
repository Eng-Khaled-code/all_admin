import 'dart:convert';

class MissedModel
{
  int? id;
  String? missedOrFound;
  String? name;
  String? sex;
  String? image;
  int? age;
  String? helthyStatus;
  String? lastPlace;
  String? missedStatus;
  String? faceColor;
  String? hairColor;
  String? eyeColor;
  String? createdAt;
  String? refuseReason;
  int? userId;
  String? username;
  String? userImage;
  String? userToken;
  List? suggestions;

  MissedModel({
    this.id,
    this.name,
    this.createdAt,
    this.image,
    this.sex,
    this.suggestions,
    this.missedOrFound,
    this.helthyStatus,
    this.missedStatus,
    this.lastPlace,
    this.eyeColor,
    this.age,
    this.faceColor,
    this.hairColor,
    this.refuseReason,
    this.userId,
    this.username,
    this.userImage,
    this.userToken
  });

  factory MissedModel.fromSnapshot(Map<String,dynamic> data){
    return MissedModel
      (
        id: data['id']??0,
        name: data["name"]??"",
        image: data['missed_image']??"",
        createdAt: data["created_at"]??"",
        sex: data["sex"]??"",
        missedOrFound: data["missed_type"]??"",
        helthyStatus: data['helthy_status']??"",
        age: data['age']??0,
        suggestions: json.decode(data["suggestions"]??"[]"),
      missedStatus: data["missed_status"]??"",
      lastPlace: data["last_place"]??"",
      eyeColor: data["eye_color"]??"",
      faceColor: data['face_color']??"",
      hairColor: data['hair_color']??"",
      refuseReason: data['refuse_reason']??"",
      userId: data['user_id']??0,
      username: data['username']??"",
      userImage: data['user_image']??"",
      userToken: data['user_token']??"",
    );
  }

}