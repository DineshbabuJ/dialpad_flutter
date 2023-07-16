import 'package:flutter/material.dart';
import 'package:practice_appp/providers/auth_provider.dart';
import 'package:practice_appp/screens/register_screen.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login Page',
        ),
      ),
      body: Consumer<AuthProvider>(builder: (context, authProvider, _) {
        return Padding(
          padding: const EdgeInsets.all(64.0),
          child: Column(
            children: [
              TextField(
                controller: authProvider.emailLoginController,
                decoration: InputDecoration(
                  label: Text('Email'),
                ),
              ),
              TextField(
                controller: authProvider.passLoginController,
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
              authProvider.loggingIn
                  ? CircularProgressIndicator()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            print('initiating Login process...');
                            if(authProvider.emailLoginController.text.trim().isNotEmpty&&authProvider.passLoginController.text.trim().isNotEmpty )
                            authProvider.login(context);
                            else{
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Enter Valid Details')));
                            }
                          },
                          child: Text(
                            'Login',
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            print('Routing to register page..');
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => RegisterScreen()));
                          },
                          child: Text(
                            'New User?',
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
