import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:notes_app/data/datasources/config.dart';
import 'package:notes_app/data/model/response/auth_response_model.dart';
import '../model/request/register_request_model.dart';
import 'auth_lokal_datasource.dart';

class AuthRemoteDataSource {
  final AuthLocalDatasource local;

  AuthRemoteDataSource(this.local);

  // Register
  Future<Either<String, AuthResponseModel>> register(RegisterRequestModel model) async {
    final response = await http.post(
      Uri.parse('${Config.baseUrl}/api/register'),
      body: model.toJson(),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 201) {
      return Right(AuthResponseModel.fromJson(response.body));
    } else {
      return Left(response.body);
    }
  }

  // Login
  Future<Either<String, AuthResponseModel>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('${Config.baseUrl}/api/login'),
      body: jsonEncode({'email': email, 'password': password}),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return Right(AuthResponseModel.fromJson(response.body));
    } else {
      return Left(response.body);
    }
  }

  // Logout
  Future<Either<String, bool>> logout() async {
    final authData = await local.getAuthData();
    if (authData == null) {
      return Left('No auth data found');
    }

    final response = await http.post(
      Uri.parse('${Config.baseUrl}/api/logout'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${authData.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      await local.removeAuthData();
      return const Right(true);
    } else {
      return Left(response.body);
    }
  }
}
