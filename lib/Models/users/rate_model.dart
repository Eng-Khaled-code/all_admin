class RateModel
{

  String? rate;
  String? date;
  String? comment;
  String? email;
  String? name;
  String? commenterImage;

  RateModel({this.rate,this.date,this.comment,this.commenterImage,this.name,this.email});

  factory RateModel.fromSnapshot(Map<String,dynamic> data){
    return RateModel
      (
        rate: data["rate"]??"0",
        email: data["email"]??"",
        date: data["date"]??"",
      comment: data["comment"]??"",
      commenterImage: data["image_url"]??"",
        name: data["username"]??""
    );
  }

}