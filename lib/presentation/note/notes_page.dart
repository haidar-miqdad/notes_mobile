import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/presentation/note/all_note_bloc/all_notes_bloc.dart';
import 'package:notes_app/presentation/note/delete_note/delete_note_bloc.dart';
import '../auth/bloc/logout/logout_bloc.dart';
import '../auth/login_page.dart';
import 'add_note_page.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {

  @override
  void initState() {
    context.read<AllNotesBloc>().add(GetAllNotes());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AddNotePage()));
          },
          child: const Icon(Icons.add),
        ),
        appBar: AppBar(
          surfaceTintColor: Colors.white,
          title: const Text('Notes'),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
            BlocConsumer<LogoutBloc, LogoutState>(
              listener: (context, state) {
                if (state is LogoutSuccess) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                }

                if (state is LogoutFailed) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message ?? 'Logout failed'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                return IconButton(
                  onPressed: () {
                    context.read<LogoutBloc>().add(LogoutButtonPressed());
                  },
                  icon: const Icon(Icons.logout_rounded),
                );
              },
            )
          ],
        ),
        body: BlocBuilder<AllNotesBloc, AllNotesState>(
          builder: (context, state) {
            if (state is AllNotesLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is AllNotesFailed) {
              return const Center(
                child: Text('Failed to load notes'),
              );
            }

            if (state is AllNotesSuccess) {
              if (state.data.data!.isEmpty) {
                return const Center(
                  child: Text('No notes found'),
                );
              }
              return ListView.builder(
                itemBuilder: (context, index) {
                  final note = state.data.data![index];
                  return Card(
                    child: ListTile(
                      title: Text('${note.title}'),
                      subtitle: Text('${note.content!.length > 20
                          ? note.content!.substring(0, 20)
                          : note.content}'),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            BlocConsumer<DeleteNoteBloc, DeleteNoteState>(
                              listener: (context, state) {
                                if(state is DeleteNoteSuccess){
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(state.message),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                  context.read<AllNotesBloc>().add(GetAllNotes());
                                }
                                if(state is DeleteNoteFailed){
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(state.message),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                              builder: (context, state) {
                                if(state is DeleteNoteLoading){
                                  return const Center(child: CircularProgressIndicator());
                                }
                                return IconButton(
                                  onPressed: () {
                                    context
                                        .read<DeleteNoteBloc>()
                                        .add(
                                        DeleteNoteButtonPressed(id: note.id!));
                                  },
                                  icon: const Icon(Icons.delete),
                                );
                              },
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.edit),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {},
                    ),
                  );
                },
                itemCount: state.data.data!.length,
              );
            }
            return ListView.builder(
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text('Item $index'),
                    subtitle: const Text('this is subtitle'),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded),
                    onTap: () {},
                  ),
                );
              },
              itemCount: 20,
            );
          },
        )
    );
  }
}
