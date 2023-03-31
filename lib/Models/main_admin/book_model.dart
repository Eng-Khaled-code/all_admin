class BookModel
{

  int? id;
  String? name;
  String? imageUrl;
  String? bookUrl;
  String? likeCount;
  String? blackCount;


  BookModel({this.id,this.likeCount,this.blackCount,this.name,this.imageUrl,this.bookUrl});

  factory BookModel.fromSnapshot(Map<String,dynamic> data){
    return BookModel
      (
        id: data["id"]??0,
        name: data["name"]??"",
        bookUrl: data["book_url"]??"",
        imageUrl: data["image_url"]??"",
        blackCount: data["black_count"]??0,
        likeCount: data["like_count"]??0,
    );
  }

}