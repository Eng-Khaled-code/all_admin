
class BookingModel
{
  int? id;
  int? userId;
  String? username;
  String? userImage;
  String? userToken;
  String? patientName;
  String? reqDate;
  String? finalBookDate;
  String? responseDate;
  int? numInQueue;
  String? notes;
  String? bookType;
  String? painDesc;
  String? bookStatus;


  BookingModel({
    this.id,
    this.patientName,
    this.bookStatus,
    this.bookType,
    this.userImage,
    this.userId,
    this.userToken,
    this.username,
    this.finalBookDate,
    this.notes,
    this.numInQueue,
    this.reqDate,
    this.responseDate,
    this.painDesc
  });

  factory BookingModel.fromSnapshot(Map<String,dynamic> data){
    return BookingModel
      (
        id: data['id'],
        username: data["username"]??"",
        userToken: data['user_token']??"",
        userImage: data["image_url"]??"",
        bookStatus: data["booking_status"]??"",
        numInQueue: data["num_in_queue"]??0,
        userId: data['user_id']??0,
        responseDate: data['response_date']??"",
        reqDate: data["req_date"]??"",
        finalBookDate: data['booking_final_date']??"",
        bookType: data["booking_type"]??"",
        notes: data['notes']??"",
        patientName: data['patient_name']??"",
      painDesc: data['pain_desc']??""
    );
  }

}