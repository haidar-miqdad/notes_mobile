import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes_app/data/datasources/auth_lokal_datasource.dart';
import 'package:http/http.dart' as http;

import '../model/response/all_notes_model.dart';
import '../model/response/note_response_model.dart';
import 'config.dart';

class NoteRemoteDatasource{
  Future<Either<String, NotesResponseModel>> addNotes(
      String title,
      String content,
      bool isPin,
      XFile? image,)async{
    final authData = await AuthLocalDatasource().getAuthData();
    final Map<String, String> headers = {
      'Authorization': 'Bearer ${authData?.accessToken}'
    };
    var request = http.MultipartRequest(
        'POST',
        Uri.parse('${Config.baseUrl}/api/notes')
    );

    request.headers.addAll(headers);
    request.fields['title'] = title;
    request.fields['content'] = content;
    request.fields['is_pin'] = isPin ? '1' : '0';

    if (image != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          image.path,
        ),
      );
    }
    http.StreamedResponse response = await request.send();

    final String body = await response.stream.bytesToString();
    if (response.statusCode == 200) {
      return Right(NotesResponseModel.fromJson(body));
    } else {
      return Left(body);
    }
  }

  //get all notes
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

    //delete note
    Future<Either<String, String>> deleteNote(int id) async {
      final authData = await AuthLocalDatasource().getAuthData();
      final response = await http.delete(
        Uri.parse('${Config.baseUrl}/api/notes/$id'),
        headers: {
          'Authorization': 'Bearer ${authData?.accessToken}'
        },
      );
      if(response.statusCode == 200){
        return const Right('Delete Success');
      }else{
        return Left(response.body);
      }
}
}