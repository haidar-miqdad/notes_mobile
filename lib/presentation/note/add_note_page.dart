import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes_app/presentation/note/bloc/add_note_bloc.dart';
import 'package:notes_app/presentation/note/notes_page.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage({super.key});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  bool isPin = false;

  XFile? image;

  void isPinHandler(bool value) {
    setState(() {
      isPin = value;
    });
  }

  //image picker handeler
  void imagePickerHandler() async {
    final XFile? _image = await ImagePicker().pickImage(
        source: ImageSource.gallery);
    setState(() {
      image = _image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Note'),
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Title',
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _contentController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Content',
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Text('isPin?'),
                  const SizedBox(width: 16,),
                  Switch(value: isPin, onChanged: isPinHandler),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                  onPressed: imagePickerHandler,
                  child: const Text('Pick Image')
              ),
            ),

            //image preview
            if(image != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.file(File(image!.path)),
              ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: BlocConsumer<AddNoteBloc, AddNoteState>(
                listener: (context, state) {
                  if(state is AddNoteSuccess){
                    const ScaffoldMessenger(
                      child: SnackBar(
                        content: Text('Note added successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                      return const NotesPage();
                    }));
                  }

                  if(state is AddNoteFailed){
                    ScaffoldMessenger(
                      child: SnackBar(
                        content: Text(state.message ?? 'Failed to add note'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if(state is AddNoteLoading){
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ElevatedButton(onPressed: () {
                    context.read<AddNoteBloc>().add(
                        AddNoteButtonPressed(
                            title: _titleController.text,
                            content: _contentController.text,
                            isPin: isPin,
                            image: image
                        )
                    );
                  }, child: const Text('Save'));
                },
              ),
            ),
          ],
        )
    );
  }
}
