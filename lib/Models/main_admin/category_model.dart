import 'package:middleman_all/start_point/app_constant.dart';

class CategoryModel
{

  int? id;
  String? name;
  String? description;
  String? createdAt;
  String? modifiedAt;
  int? status;
  String? changeStatusDate;
String? itemsCount;

  CategoryModel({this.id,this.status,this.createdAt,this.name,this.modifiedAt,this.description,this.changeStatusDate,this.itemsCount});

  factory CategoryModel.fromSnapshot(Map<String,dynamic> data){
    return CategoryModel
      (
        id: data["id"]??0,
        name: data["name"]??"",
        description: data["description"]??"",
      createdAt: data["created_at"]??"",
      modifiedAt: data["modified_at"]??"",
        status: data["status"]??0,
      changeStatusDate: data['changing_status_date']??'',
      itemsCount: data[categoryType=="تسوق"?'item_count':'courses_count']??"0"
    );
  }

}