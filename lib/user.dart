import 'dart:io';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracy/data_response.dart';

class User extends Equatable {
  const User._(
      this.firstname, this.lastname, this.phone, this.email, this.password);

  factory User.newUser(firstname, lastname, phone, email, password) {
    return User._(firstname, lastname, phone, email, password);
  }

  factory User.fromJson(Map<String, dynamic> json) {
    // ignore: prefer_const_constructors
    return User._(json['firstname'], json['lastname'], json['phone'],
        json['email'], json['password']);
  }

  final String firstname, lastname, phone, email, password;

  @override
  List<String> get props => [firstname, lastname, phone, email, password];
}

class UserRestApi {
  final _api = Dio(BaseOptions(
    baseUrl: 'http://192.168.1.8:8081/api/auth/',
    followRedirects: false,
    validateStatus: (status) {
      return status! < 500;
    },
    headers: {
      'Content-type': ContentType.json.mimeType,
    },
  ));

  Future<DataRes> createUser(User user) async {
    final res = await _api.post('register', data: {
      'firstname': user.firstname,
      'lastname': user.lastname,
      'phone': user.phone,
      'email': user.email,
      'password': user.password,
    });
    final message = res.statusCode != 201
        ? (res.data['message'] != null)
            ? res.data['message']
            : 'Erreur inattendue'
        : 'Inscription effectué avec succès';
    return DataRes(res.statusCode!, message);
  }

  Future<DataRes> loginUser(String email, String password) async {
    final res =
        await _api.post('login', data: {'email': email, 'password': password});

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', '${res.data['token']}');
    final String? token = prefs.getString('token');
    print(token);
    return DataRes(res.statusCode!, res.data['message']);
  }

  Future<DataRes> sendCodeOnEmail(String email) async {
    final res = await _api.post('send-code', data: {'email': email});
    return DataRes(res.statusCode!, res.data['message']);
  }

  Future<DataRes> confirmeEmailUser(String email, String code) async {
    final res =
        await _api.post('confirme-code', data: {'email': email, 'code': code});
    return DataRes(res.statusCode!, res.data['message']);
  }

  Future<DataRes> sendEmailCodeForgetPassword(String email) async {
    final res = await _api
        .post('send-email-code-forget-password', data: {'email': email});
    return DataRes(res.statusCode!, res.data['message']);
  }

  Future<DataRes> confirmeCodeForgetPassword(String email, String code) async {
    final res = await _api.post('confirme-code-reset-password',
        data: {'email': email, 'code': code});
    return DataRes(res.statusCode!, res.data['message']);
  }

  Future<DataRes> resetForgetPassword(
      String email, String code, String password) async {
    final res = await _api.post('reset-forget-password',
        data: {'email': email, 'code': code, 'password': password});
    return DataRes(res.statusCode!, res.data['message']);
  }
}
