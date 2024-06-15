import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/data/datasources/auth_lokal_datasource.dart';
import 'package:notes_app/data/datasources/auth_remote_datasource.dart';
import 'package:notes_app/data/datasources/note_remote_datasource.dart';
import 'package:notes_app/presentation/auth/bloc/login/login_bloc.dart';
import 'package:notes_app/presentation/auth/bloc/logout/logout_bloc.dart';
import 'package:notes_app/presentation/auth/bloc/register/register_bloc.dart';
import 'package:notes_app/presentation/auth/login_page.dart';
import 'package:notes_app/presentation/note/all_note_bloc/all_notes_bloc.dart';
import 'package:notes_app/presentation/note/delete_note/delete_note_bloc.dart';
import 'package:notes_app/presentation/note/notes_page.dart';
import 'package:notes_app/presentation/note/update_note/update_note_bloc.dart';

import 'presentation/note/note_bloc/add_note_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => RegisterBloc(AuthRemoteDataSource()),
        ),
        BlocProvider(
          create: (context) => LoginBloc(AuthRemoteDataSource()),
        ),
        BlocProvider(
          create: (context) => LogoutBloc(AuthRemoteDataSource()),
        ),
        BlocProvider(
          create: (context) => AddNoteBloc(NoteRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => AllNotesBloc(NoteRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => DeleteNoteBloc(NoteRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => UpdateNoteBloc(NoteRemoteDatasource()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: FutureBuilder<bool>(
          future: AuthLocalDatasource().isLogin(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            if (snapshot.hasData && snapshot.data == true) {
              return const NotesPage();
            }
            return const LoginPage();
          },
        ),
      ),
    );
  }
}
