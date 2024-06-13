import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/data/datasources/auth_lokal_datasource.dart';
import 'package:notes_app/data/datasources/auth_remote_datasource.dart';
import 'package:notes_app/pages/home_navigator.dart';
import 'package:notes_app/presentation/auth/bloc/login/login_bloc.dart';
import 'package:notes_app/presentation/auth/bloc/logout/logout_bloc.dart';
import 'package:notes_app/presentation/auth/bloc/register/register_bloc.dart';
import 'package:notes_app/presentation/auth/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Create instances of AuthLocalDatasource and AuthRemoteDataSource
    final authLocalDatasource = AuthLocalDatasource();
    final authRemoteDataSource = AuthRemoteDataSource(authLocalDatasource);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => RegisterBloc(authRemoteDataSource),
        ),
        BlocProvider(
          create: (context) => LoginBloc(authRemoteDataSource),
        ),
        BlocProvider(
          create: (context) => LogoutBloc(authRemoteDataSource),
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
          future: authLocalDatasource.isLogin(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            if (snapshot.hasData && snapshot.data == true) {
              return const HomePage();
            }
            return const LoginPage();
          },
        ),
      ),
    );
  }
}
