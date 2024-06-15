import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/data/model/response/note_response_model.dart';
import 'package:notes_app/presentation/note/notes_page.dart';
import 'package:notes_app/presentation/note/update_note/update_note_bloc.dart';

class EditNotePage extends StatefulWidget {
  final Note note;
  const EditNotePage({super.key, required this.note});

  @override
  State<EditNotePage> createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  bool isPin = false;

  void isPinHandler(bool value) {
    setState(() {
      isPin = value;
    });
  }

  @override
  void initState() {
    _titleController.text = widget.note.title!;
    _contentController.text = widget.note.content!;
    isPin = widget.note.isPinned == '1' ? true : false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Note'),
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 16,
          ),
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
          const SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Text('isPin?'),
                const SizedBox(
                  width: 16,
                ),
                Switch(value: isPin, onChanged: isPinHandler),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlocConsumer<UpdateNoteBloc, UpdateNoteState>(
              listener: (context, state) {
                if (state is UpdateNoteSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Update Success'),
                    backgroundColor: Colors.green,
                  ));
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NotesPage()));
                }

                if (state is UpdateNoteFailed) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.red,));
                }
              },
              builder: (context, state) {
                
                if (state is UpdateNoteLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ElevatedButton(
                  onPressed: () {
                    context.read<UpdateNoteBloc>().add(UpdateNoteButtonPressed(
                        id: widget.note.id!,
                        title: _titleController.text,
                        content: _contentController.text,
                        isPin: isPin));
                  },
                  child: const Text('Update'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
