import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes_app/data/datasources/auth_lokal_datasource.dart';
import 'package:http/http.dart' as http;

import '../model/response/all_notes_model.dart';
import '../model/response/note_response_model.dart';
import 'config.dart';

class NoteRemoteDatasource {
  Future<Either<String, NotesResponseModel>> addNote(
    String title,
    String content,
    bool isPin,
    XFile? image,
  ) async {
    final authData = await AuthLocalDatasource().getAuthData();
    final Map<String, String> headers = {
      'Authorization': 'Bearer ${authData!.accessToken}',
    };

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${Config.baseUrl}/api/notes'),
    );

    request.headers.addAll(headers);
    request.fields['title'] = title;
    request.fields['content'] = content;
    request.fields['is_pinned'] = isPin ? '1' : '0';

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

    if (response.statusCode == 201) {
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
        'Authorization': 'Bearer ${authData!.accessToken}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = AllNotesResponseModel.fromJson(response.body);
      return Right(data);
    } else {
      return Left(response.body);
    }
  }

  //delete notes
  Future<Either<String, String>> deleteNotes(int id) async {
    final authData = await AuthLocalDatasource().getAuthData();
    final response = await http.delete(
      Uri.parse('${Config.baseUrl}/api/notes/$id'),
      headers: {
        'Authorization': 'Bearer ${authData!.accessToken}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return const Right('Delete success');
    } else {
      return Left(response.body);
    }
  }

  //update notes
  Future<Either<String, NotesResponseModel>> updateNotes(
    int id,
    String title,
    String content,
    bool isPinned,
  ) async {
    final authData = await AuthLocalDatasource().getAuthData();
    final response =
        await http.put(Uri.parse('${Config.baseUrl}/api/notes/$id'),
            headers: {
              'Authorization': 'Bearer ${authData!.accessToken}',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'title': title,
              'content': content,
              'is_pinned': isPinned ? '1' : '0',
            }));
    if (response.statusCode == 200) {
      return Right(NotesResponseModel.fromJson(response.body));
    } else {
      return Left(response.body);
    }
  }
}
