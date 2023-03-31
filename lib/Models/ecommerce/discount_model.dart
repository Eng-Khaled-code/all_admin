
class DiscountModel
{
  int? id;
  String? name;
  String? description;
  String? percentage;
  String? createdAt;
  String? modifiedAt;
  String? deletedAt;
  String? endTime;
  int? status;
  DiscountModel({this.id,this.name,this.description,this.status,this.createdAt,this.deletedAt,this.endTime,this.modifiedAt,this.percentage});

  factory DiscountModel.fromSnapshot(Map<String,dynamic> data){
    return DiscountModel
      (
        id: data['id']??0,
        name: data["name"]??"",
        description: data["description"]??"",
        status: data['status']??0,
        createdAt: data["created_at"]??"",
        deletedAt: data["deleted_at"]??"",
        modifiedAt: data['modified_at']??"",
        endTime: data["end_in"]??"",
        percentage: data["discount_percentage"].toString(),
    );
  }

}