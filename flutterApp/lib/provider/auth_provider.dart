import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'Package:http/http.dart' as http;
import 'dart:convert';
import 'package:moivoice/pages/login_page.dart';
import 'package:get_storage/get_storage.dart';

class AuthProvider with ChangeNotifier {
  //String? userId;
  static String userEmail = '';
  static String userPassword = '';
  static String userAdmission = '';
  static String userName = '';
  static String userPhone = '';
  static String userId = '';

  //String? get getUserId => userId;

  String? get getUserName => userEmail;

  String? get getUserPassword => userPassword;

  static String errorMessage = "";
  static String signup_authMessage = "";
  static String signin_authMessage = "";
  Future<void> signUpUser(String name, String email, String admission,
      String password, String phone) async {
    final response = await http
        .post(Uri.parse('http://192.168.43.167:3000/user/signUp'), headers: {
      "content-type": "application/x-www-form-urlencoded;charset=UTF-8",
    }, body: {
      'userName': name,
      'userEmail': email,
      'userAdmission': admission,
      'userPassword': password,
      'userPhone': phone,
    });

    Map<String, dynamic> map = jsonDecode(response.body);

    if (map['message'] != null) {
      signup_authMessage = map['message'];
     
    }

    if (map['error'] != null) {
      errorMessage = map['error']['message'];
    }
    userName = name;
    userEmail = email;
    userPassword = password;
    userPhone = phone;
    userAdmission = admission;
  }

  Future<void> signinUser(String email, String password) async {
    
    final response = await http.post(
        Uri.parse('http://192.168.43.167:3000/user/signIn'),
        headers: <String, String>{
          "content-type": "application/x-www-form-urlencoded;charset=UTF-8",
        },
        body: <String, String>{
          'userEmail': email,
          'userPassword': password,
        });
    
    Map<String, dynamic> map = await jsonDecode(response.body);
    

    if (map['message'] != null && map['message'] == 'success') {
      signin_authMessage = map['message'];
      userAdmission = await map['userDetails']['admission'];
      userName = await map['userDetails']['name'];
      userPhone = await map['userDetails']['phone'];
      userId = await map['userDetails']['user_id'];
      userEmail = email;

      
    }
    if (map['error'] != null) {
      errorMessage = await map['error']['message'];
      
    }
  }

  String _localhost() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://192.168.43.167:3000/user/signIn';
    }
    print('called here');
    return 'http://192.168.43.167:3000/user/signIn';
  }
}
