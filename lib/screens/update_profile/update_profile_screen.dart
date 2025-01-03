import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hediaty_sec/models/domain/users_methods.dart';
import 'package:hediaty_sec/providers/theme_provider.dart';
import 'package:hediaty_sec/services/auth_service.dart';
import 'package:hediaty_sec/services/image_to_stringVV.dart';
import 'package:hediaty_sec/widgets/textField.dart';
import 'package:provider/provider.dart';

import '../../models/data/users.dart';

class EditProfile extends StatefulWidget {
  User myUser;
   EditProfile({super.key, required this.myUser});

  @override
  State<EditProfile> createState() => _signUpScreenState();
}

class _signUpScreenState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    //final emailController = TextEditingController();
    //final passwordController = TextEditingController();
    final nameController = TextEditingController();
    final numberController = TextEditingController();
    //emailController.text = widget.myUser.email!;
    //passwordController.text = widget.myUser.password!;
    nameController.text = widget.myUser.name!;
    numberController.text = widget.myUser.number!;

    String? nameError = '';
    String? numberError = '';
    var CurrentProfile = widget.myUser.imageURL != '' ? ImageConverterr().stringToImage(widget.myUser.imageURL!) : null;
    var profileImage;

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
                    /*Text(
                      'Welcome to Hediaty',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                      ),
                    ),*/
                    SizedBox(height: 10),
                    Text(
                      'Edit Your Account',
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
                    SizedBox(height: 20,),
                    Stack(
                      children: [
                        CircleAvatar(
                          backgroundImage:CurrentProfile !=null? MemoryImage(CurrentProfile): AssetImage('lib/assets/icons/favicon.png'),
                          radius: 70,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: IconButton(
                            icon: Icon(CupertinoIcons.add_circled_solid,size: 30,),
                            color: Colors.white,
                            onPressed: () async{
                              setState(()async{
                                var selectedImage = await ImageConverterr().pickAndCompressImageToString();
                                profileImage = ImageConverterr().stringToImage(selectedImage!);

                              });

                            },
                          ),
                        ),
                      ],
                    ),
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
                    Text(
                      nameError!,
                      style: TextStyle(color: Colors.red),
                    ),
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
                    Text(
                      numberError!,
                      style: TextStyle(color: Colors.red),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const SizedBox(height: 20),


                    ElevatedButton(
                        onPressed: () {
                          setState(() async{
                            try{
                              String currentID =authService().currentUser!.uid;
                               widget.myUser = User(currentID, nameController.text, widget.myUser.email, numberController.text, profileImage);
                              await userMethods().editUser(widget.myUser);
                              Navigator.pop(context);
                            }

                            catch(e){
                              print(e.toString());
                            }

                          });
                        },
                        child: const Text(
                          'Update Profile',
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
