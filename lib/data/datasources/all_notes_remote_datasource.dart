

import 'package:dartz/dartz.dart';

import '../model/response/all_notes_model.dart';
import '../model/response/note_response_model.dart';
import 'auth_lokal_datasource.dart';
import 'config.dart';

import 'package:http/http.dart' as http;

class AllNotesRemoteDatasource{
  Future<Either<String, AllNotesResponseModel>> getAllNotes() async {
    final authData = await AuthLocalDatasource().getAuthData();
    final response = await http.get(
      Uri.parse('${Config.baseUrl}/api/notes'),
      headers: {
        'Authorization': 'Bearer ${authData?.accessToken}'
      },
    );

    if(response.statusCode == 200){
      return Right(AllNotesResponseModel.fromJson(response.body));
    }else{
      return Left(response.body);
    }
  }
}
