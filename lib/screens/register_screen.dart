import 'package:flutter/material.dart';
import 'package:practice_appp/providers/auth_provider.dart';
import 'package:practice_appp/screens/login_screen.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Register Page',
        ),
        // actions: [
        //   IconButton(
        //       onPressed: () {
        //         Navigator.pop(context);
        //       },
        //       icon: Icon(
        //         Icons.close,
        //       ))
        // ],
      ),
      body: Consumer<AuthProvider>(builder: (context, authProvider, _) {
        return Padding(
          padding: const EdgeInsets.all(64.0),
          child: Column(
            children: [
              TextField(
                controller: authProvider.nameController,
                decoration: InputDecoration(
                  label: Text('Name'),
                ),
              ),
              TextField(
                controller: authProvider.emailController,
                decoration: InputDecoration(
                  label: Text('Email'),
                ),
              ),
              TextField(
                controller: authProvider.passController,
                obscureText: true,
                decoration: InputDecoration(
                  label: Text(
                    'Password',
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              authProvider.registeringUser
                  ? CircularProgressIndicator()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            print('initiating register process...');
                            authProvider.register(context);
                          },
                          child: Text(
                            'Register',
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                          },
                          child: Text(
                            'Cancel',
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        );
      }),
    );
  }
}
