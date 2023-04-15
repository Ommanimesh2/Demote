import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthServices {
  final url = 'https://ommanimesh.pythonanywhere.com/login/';

  Future<Map<String,dynamic>> login(String email, String password) async {

    var response = await http.post(Uri.parse(url), body: {
      'email': email,
      'password': password,
    });
    print(response.body);
    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      return {'error': 'Invalid Credentials'};
    }
  }

  Future<Map<String,dynamic>>  signup(String email, String password,String username) async {
      const url2 = 'https://ommanimesh.pythonanywhere.com/signup/';
    var response = await http.post(Uri.parse(url2), body: {
      'username': username,
      'email': email,
      'password': password,
    });
    print(jsonDecode(response.body)['message']);
    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      return {'error': 'Invalid Credentials'};
    }
  }
}
