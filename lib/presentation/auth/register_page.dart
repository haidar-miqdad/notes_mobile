import 'package:flutter/material.dart';
import 'package:notes_app/data/datasources/auth_remote_datasource.dart';
import 'package:notes_app/data/model/request/register_request_model.dart';
import 'package:notes_app/presentation/auth/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 64,
          ),
          const FlutterLogo(
            size: 100,
          ),
          const SizedBox(
            height: 15,
          ),
          const Text(
            textAlign: TextAlign.center,
            'Notes App',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text('User Name'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text('Email'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text('Password'),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _passwordConfirmationController,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text('Password Confirmation'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
                onPressed: () async{

                  //register
                  final dataModel = RegisterRequestModel(
                    name: _nameController.text,
                    email: _emailController.text,
                    password: _passwordController.text,
                    passwordConfirmation: _passwordConfirmationController.text
                  );

                  //call register function
                  AuthRemoteDataSource dataSource = AuthRemoteDataSource();
                  final response = await dataSource.register(dataModel);

                  //check response
                  response.fold(
                          (error){
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(error))
                            );
                          }, (success){
                             ScaffoldMessenger.of(context).showSnackBar(
                               SnackBar(content: Text('success'))
                             );
                             Navigator.push(context, MaterialPageRoute(builder: (context)=> const LoginPage()));
                          });
                },
                child: const Text('Register')),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Already have an account?'),
              TextButton(onPressed: () {
                Navigator.pop(context, MaterialPageRoute(builder: (context)=> const LoginPage()));
                }, child: const Text('Sign In'))
            ],
          )
        ],
      ),
    );
  }
}
