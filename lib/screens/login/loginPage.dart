import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hediaty_sec/providers/theme_provider.dart';
import 'package:hediaty_sec/screens/signUP/sign_up_screen.dart';
import 'package:hediaty_sec/widgets/customButton.dart';
import 'package:hediaty_sec/widgets/textField.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import '../../providers/is_logged_in_provider.dart';
import '../../services/auth_service.dart';

class loginPage extends StatefulWidget {
  loginPage({super.key});

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  @override
  Widget build(BuildContext context) {
    String? errorMessage = ' ';
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: context.watch<theme>().dark
          ? CupertinoColors.darkBackgroundGray
          : CupertinoColors.extraLightBackgroundGray,

      //backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.lightGreen],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 2.0,
                    spreadRadius: 0.0,
                    offset: Offset(2.0, 2.0),
                  )
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 60, left: 16, right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome to Hediaty',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text(
                          'Sign in to your account',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        Expanded(child: Container()),
                        IconButton(
                          icon: Icon(context.watch<theme>().dark
                              ? Icons.wb_sunny
                              : Icons.nightlight_round),
                          onPressed: () {
                            context.read<theme>().changeTheme();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  const Text(
                    'Enter Your email',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  CustomTextField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}')
                          .hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    isObsecure: false,
                    controller: emailController,
                    hintText: "e.g bibo@example.com",
                    icon: Iconsax.mobile,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Enter Your Password',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  CustomTextField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                    isObsecure: true,
                    controller: passwordController,
                    hintText: "Password",
                    icon: Icons.lock_outline,
                  ),
                  const SizedBox(height: 10),
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: Colors.lightGreen,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (errorMessage != null && errorMessage!.isNotEmpty)
                    Text(
                      errorMessage!,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                      ),
                    ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(Colors.lightGreenAccent),
                        foregroundColor: WidgetStateProperty.all(Colors.black),
                      ),
                      //until login validation is implemented
                      onPressed: () async {
                        try {
                          await authService().signIn(
                            email: emailController.text,
                            password: passwordController.text,
                          );
                          context.read<isLogged>().changeState();
                        } on FirebaseAuthException catch (e) {
                          setState(() {
                            switch (e.code) {
                              case 'user-not-found':
                                errorMessage =
                                    'No user found for that email, try creating an account.';
                                break;
                              case 'wrong-password':
                                errorMessage = 'Wrong email or password.';
                                break;
                              default:
                                errorMessage = 'Error signing in: ${e.message}';
                            }
                          });
                        }
                      },
                      child: const Text("Login"),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Divider(
                      height: 2,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Custombutton(
                          ss: ' login with facebook',
                          URL: 'lib/assets/icons/facebook.svg',
                        ),
                        Custombutton(
                          ss: ' login with Google',
                          URL: 'lib/assets/icons/google.svg',
                        ),
                      ],
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 60,
                      ),
                      const Text("Don't Have an account?"),
                      GestureDetector(
                        child: const Text(
                          ' Signup now',
                          style: TextStyle(
                            color: Colors.lightGreenAccent,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
