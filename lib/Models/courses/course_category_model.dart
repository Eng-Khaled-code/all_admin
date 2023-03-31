
class CourseCategoryModel
{

  int? id;
  String? name;
  String? description;

  CourseCategoryModel({this.id,this.description,this.name});

  factory CourseCategoryModel.fromSnapshot(Map<String,dynamic> data){
    return CourseCategoryModel
      (
        id: data["id"]??0,
        name: data["name"]??"",
        description: data["desc"]??"",
    );
  }

}