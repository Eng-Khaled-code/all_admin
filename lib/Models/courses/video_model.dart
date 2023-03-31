
class VideoModel
{

  int? id;
  String? name;
  String? createdAt;
  int? secId;
  String? videoUrl;
  String? desc;

  VideoModel({this.id,this.name,this.createdAt,this.secId,this.desc,this.videoUrl});

  factory VideoModel.fromSnapshot(Map<String,dynamic> data){
    return VideoModel
      (
        id: data["video_id"]??0,
        name: data["name"]??"",
        secId: data["sec_id"]??0,
        createdAt: data['created_at']??"",
        desc: data['description']??"",
        videoUrl: data['video_url']??""
    );
  }

}