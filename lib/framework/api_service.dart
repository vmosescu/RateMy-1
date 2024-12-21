import 'dart:convert';

import 'package:http/http.dart' as http;

class APIService {
  Future<Map<String, dynamic>> postLogin(String domain, String email, String password) async {
    final response = await http.post(
        Uri.parse('https://pg.api-inv.w3dsoft.de/api/v1/auth/login'),
        body: {
          'domain': domain,
          'email': email,
          'password': password,
          'rememberMe': '0'
        });

    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}