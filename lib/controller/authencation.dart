// Controller của signin, signup... dùng network helper
import 'package:bkconnect/controller/config.dart';
import 'package:bkconnect/controller/info.dart';
import 'package:http/http.dart' as http;

class Authentication {
  Future<http.Response> signUp(UserInfo info) async {
    var body = info.toJson();
    var header = {"Content-Type": "application/json"};
    // final url = 'http://10.0.2.2:5000/register/';
    final url = base_url + '/register/';
    return await http.post(url, headers: header, body: body);
  }

  Future<http.Response> signIn(UserInfo info) async {
    var body = info.toJson();
    var header = {"Content-Type": "application/json"};
    // final url = 'http://10.0.2.2:5000/login/';
    final url = base_url + '/login/';
    return await http.post(url, headers: header, body: body);
  }
}
