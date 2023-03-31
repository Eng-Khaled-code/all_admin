import 'dart:convert';
import 'package:http/http.dart' as http;

class MainOperation {

  Future<Map<String,dynamic>> postOperation(Map<String, String> data,String url) async {
    try {
      print("in 1");
      var uri = Uri.parse(url);
      var response = await http.post(uri, body: data);

      if (response.statusCode == 200) {

        var resultMap = jsonDecode(response.body);

        return resultMap;
      } else {

        return { "status": 0, "message": "status code error : ${response.statusCode.toString()}"};
      }
    } catch (ex) {
      print(ex);
      return {"status":0,"message":"try and catch error $ex"};
    }
  }

  Future<Map<String,dynamic>> getOperation(Map<String, String> data,String url) async {
    try {
      print("in 2");
      var uri = Uri.parse(url+"?token="+data["token"]!+"&id="+data["id"]!);
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        var resultMap = jsonDecode(response.body);

        return resultMap;
      } else {

        return {"code": 0, "message": "status code error : ${response.statusCode.toString()}"};
      }
    }catch (ex) {
      print("in 2  "+ex.toString());

      return {"code":0,"message":"try and catch error ${ex}"};
    }
  }


  Future<List> loadList(Map<String, String> data,String url) async {
    try {

      print("in 3");

      var uri = Uri.parse(url+"?token="+data["token"]!+"&status="+data["status"]!+"&docId="+data["docId"]!+"&date="+data["date"]!);
      var response = await http.get(uri);//, body: data);

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        if(result["code"]==1){
          return result["response"];}
        else{
          return [result];}
      } else {

        return [{"code": 0, "message": "status code error : ${response.statusCode.toString()}"}];
      }
    } catch (ex) {
      print("in 3 "+ex.toString());
      return [{"code":0,"message":"try and catch error ${ex}"}];
    }
  }
}
