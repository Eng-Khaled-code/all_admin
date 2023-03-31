
class QuestionModel
{

  int? quesId;
  String? question;
  String? res1;
  String? res2;
  String? res3;
  String? res4;
  int? trueIndex;
  int? videoId;

  QuestionModel({this.quesId,this.question,this.trueIndex,this.videoId,this.res1,this.res2,this.res3,this.res4});

  factory QuestionModel.fromSnapshot(Map<String,dynamic> data){
    return QuestionModel
      (
        quesId: data["que_id"]??0,
        question: data["question"]??"",
        trueIndex: data["true_index"]??0,
        videoId: data["video_id"]??0,
        res1: data['res1']??"",
        res4: data['res4']??"",
        res3: data['res3']??"",
        res2: data['res2']??""

    );
  }

}