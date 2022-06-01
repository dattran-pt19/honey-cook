import 'dart:convert';

import 'package:honey_cook/list_api_test/list_api_model.dart';
import 'package:http/http.dart' as http;

class ListApiService {
  Future<List<ApiModel>?> getApi() async {
    var client = http.Client();
    
    var uri = Uri.parse('https://jsonplaceholder.typicode.com/posts');
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      final Map object = {
        'hello': 4,
        'hi': 4
      };
      var str = response.body;
      return List<ApiModel>.from(json.decode(str).map((x) => ApiModel()..decode(x)));
    }
  }
}