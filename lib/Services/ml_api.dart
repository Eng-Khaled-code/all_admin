import 'dart:convert';

import 'package:dio/dio.dart';

class MlServices {
  Dio dio = Dio();

  Future<Map<String, dynamic>> getSuggestions(String imagName) async {
    try {
      // face recognation script url
      String uri = "http://192.168.43.109:8888/" + imagName;
      var response = await dio.get(uri);

      if (response.statusCode == 200) {
        var resultMap = jsonDecode(response.data);

        return resultMap;
      } else {
        return {
          "status": "0",
          "result": "status code error : ${response.statusCode.toString()}"
        };
      }
    } catch (ex) {
      return {"status": "0", "result": "try and catch error $ex"};
    }
  }
}
