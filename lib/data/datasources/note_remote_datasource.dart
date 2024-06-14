import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes_app/data/datasources/auth_lokal_datasource.dart';
import 'package:http/http.dart' as http;

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
    request.fields['is_pin'] = isPin.toString();

    if (image != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          image.path,
        )
      );
    }
  }
}