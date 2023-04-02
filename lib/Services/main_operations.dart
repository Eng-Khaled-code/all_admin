import 'dart:convert';
import 'package:dio/dio.dart';

class MainOperation {

  Dio dio=Dio();

  Future<Map<String,dynamic>> postOperation(Map<String, dynamic> data,String url) async {
    try {

      var response = await dio.post(url, data: FormData.fromMap(data));
      if (response.statusCode == 200) {

        var resultMap = jsonDecode(response.data);

        return resultMap;
      } else {

        return { "status": 0, "message": "status code error : ${response.statusCode.toString()}"};
      }
    } catch (ex) {
      print(ex);
      return {"status":0,"message":"try and catch error $ex"};
    }
  }

}
