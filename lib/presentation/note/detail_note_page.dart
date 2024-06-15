import 'package:flutter/material.dart';
import 'package:notes_app/data/datasources/config.dart';
import 'package:notes_app/data/model/response/note_response_model.dart';

import 'edit_note_page.dart';

class DetailNotePage extends StatelessWidget {
  final Note note;

  const DetailNotePage({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(note.title!),
      ),
      body: Column(
        children: [
          Text(
            note.content!,
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(
            height: 20,
          ),
          if (note.image != null)
            Image.network(
              '${Config.baseUrl}/images/${note.image!}',
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          const SizedBox(
            height: 16,
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditNotePage(
                              note: note,
                            )));
              },
              child: const Text('Edit')),
        ],
      ),
    );
  }
}
