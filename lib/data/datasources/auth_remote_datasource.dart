import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:notes_app/data/model/response/auth_response_model.dart';

import '../model/request/register_request_model.dart';

class AuthRemoteDataSource {
  // Register
  Future<Either<String, AuthResponseModel>> register(RegisterRequestModel model) async {
    final response = await http.post(Uri.parse('http://172.20.10.4:8000/api/register'),
      body: model.toJson(),
      headers: {
        'Content-Type': 'application/json',
      }
    );

    if(response.statusCode == 201) {
      return Right(AuthResponseModel.fromJson(response.body));
    } else {
      return Left(response.body);
    }

  }
}