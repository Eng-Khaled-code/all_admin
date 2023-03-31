
class AddressModel {

  int?id;
  String? country;
  String? city;
  String? postCode;
  String? phone1;
  String? phone2;

  AddressModel({this.id,this.country,this.city,this.postCode,this.phone1,this.phone2});

  factory AddressModel.fromSnapshot(Map<String,dynamic> data){
    return AddressModel
      (
        id: data['id']??0,
        country: data["country"]??"",
        city: data["city"]??"",
        postCode: data["post_code"]??"",
        phone1: data["phone_1"]??"",
        phone2: data["phone_2"]??""
    );
  }
}
