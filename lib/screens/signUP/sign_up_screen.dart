import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hediaty_sec/providers/theme_provider.dart';
import 'package:hediaty_sec/widgets/textField.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _signUpScreenState();
}

class _signUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final nameController = TextEditingController();
    final numberController = TextEditingController();
    String? nameError = '';
    String? numberError = '';

    return Scaffold(
      backgroundColor: context.watch<theme>().dark
          ? CupertinoColors.darkBackgroundGray
          : CupertinoColors.extraLightBackgroundGray,
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
              child: const Padding(
                padding: EdgeInsets.only(top: 60, left: 16, right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome to Hediaty',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Create an account',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(
                child: Column(
                  children: [
                    /*SizedBox(height: 50,),
                    CircleAvatar(
                      radius: 30,
                      child: Icon(CupertinoIcons.profile_circled),
                    ),*/
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                        validator: (value) {
                          if (value == null) {
                            nameError = 'name can not be null';
                          }
                        },
                        hintText: 'Name',
                        icon: CupertinoIcons.person,
                        isObsecure: false,
                        controller: nameController),
                    /*Text(
                      nameError!,
                      style: TextStyle(color: Colors.red),
                    ),*/
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                        validator: (value) {
                          if (value != int || value == null) {
                            numberError = 'Enter your phone number';
                          }
                        },
                        hintText: 'Phone Number',
                        icon: CupertinoIcons.number,
                        isObsecure: false,
                        controller: numberController),
                   /* Text(
                      numberError!,
                      style: TextStyle(color: Colors.red),
                    ),*/
                    const SizedBox(
                      height: 20,
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
                    /*const Text(
                      'Enter Your Password',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),*/
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
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
        
                          });
                        },
                        child: const Text(
                          'Sign UP',
                          style: TextStyle(
                            color: Colors.lightGreenAccent,
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
