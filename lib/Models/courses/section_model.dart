
class SectionModel
{

  int? id;
  String? name;
  String? createdAt;
  int? courseId;
  String? videoCount;

  SectionModel({this.id,this.name,this.courseId,this.createdAt,this.videoCount});

  factory SectionModel.fromSnapshot(Map<String,dynamic> data){
    return SectionModel
      (
        id: data["id"]??0,
        name: data["name"]??"",
        courseId: data["course_id"]??0,
        createdAt: data['created_at']??"",
        videoCount: data['sec_videos']??"0"
    );
  }

}