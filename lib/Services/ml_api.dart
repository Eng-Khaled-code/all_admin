import 'dart:convert';
import 'package:http/http.dart' as http;

class MlServices {

  Future<Map<String,dynamic>> getSuggestions(String imagName) async {
    try {
      var uri = Uri.parse("http://192.168.43.109:8888/"+imagName);
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        var resultMap = jsonDecode(response.body);
        print("نجاح");

        return resultMap;
      } else {

        return {"status": "0", "result": "status code error : ${response.statusCode.toString()}"};
      }
    } catch (ex) {

      return {"status":"0","result":"try and catch error ${ex}"};
    }
  }}