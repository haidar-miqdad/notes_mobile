import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddNotePage()));
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
      body: ListView.builder(
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text('Item $index'),
                subtitle: const Text('this is subtitle'),
                trailing: const Icon(Icons.arrow_forward_ios_rounded),
                onTap: (){},
              ),
            );
          },
          itemCount: 20,
      )
    );
  }
}
