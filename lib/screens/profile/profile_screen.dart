import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hediaty_sec/models/data/users.dart';
import 'package:hediaty_sec/models/domain/users_methods.dart';
import 'package:hediaty_sec/providers/theme_provider.dart';
import 'package:hediaty_sec/services/image_to_stringVV.dart';
import 'package:hediaty_sec/services/user_manager.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class profileScreen extends StatefulWidget {
  profileScreen({super.key});

  @override
  State<profileScreen> createState() => _profileScreenState();
}

class _profileScreenState extends State<profileScreen> {
  User? userData;
  bool isLoading = true;
  var profileImage;


  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      var user = await userMethods().getUserByID(UserManager().getUserId()!);
      setState(() {
        userData = User.fromMap(user!);
        isLoading = false;
        if(userData != '') {
          profileImage = ImageConverterr().stringToImage(userData!.imageURL!);
        }
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          context.watch<theme>().dark ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor:
            context.watch<theme>().dark ? Colors.black : Colors.white,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : userData == null
              ? Center(child: Text('No user data found'))
              : Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: context.watch<theme>().dark
                            ? Colors.black
                            : Colors.white,
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Stack(
                                    children: [
                                      //ChatGPT for the pop up part
                                      GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Dialog(
                                                backgroundColor:  Colors.transparent,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(20),

                                                ),
                                                child: Container(
                                                  padding: EdgeInsets.all(16),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      CircleAvatar(
                                                        backgroundImage: profileImage != null
                                                            ? MemoryImage(profileImage!)
                                                            : AssetImage('lib/assets/icons/favicon.png') as ImageProvider,
                                                        radius: 200,
                                                      ),
                                                      SizedBox(height: 20),
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.pop(context);
                                                        },
                                                        child: Text('Close'),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        child: CircleAvatar(
                                          backgroundImage: profileImage != null
                                              ? MemoryImage(profileImage!)
                                              : AssetImage('lib/assets/icons/favicon.png') as ImageProvider,
                                          radius: 70,
                                        ),
                                      ),

                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: IconButton(
                                          icon: Icon(CupertinoIcons.add_circled_solid,size: 30,),
                                          color: Colors.white,
                                          onPressed: () async{
                                             var selectedImage = await ImageConverterr().pickAndCompressImageToString();
                                            setState((){
                                              userData!.imageURL= selectedImage;
                                              userMethods().editUser(userData!);
                                              _fetchUserData();
                                            });

                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        userData!.name ?? 'No Name',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Text(userData!.email ?? 'No Email',
                                          style: TextStyle(fontSize: 18)),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Text(userData!.number ?? 'No Number',
                                          style: TextStyle(fontSize: 18)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 200,
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: Container(
                        decoration: BoxDecoration(
                          color: context.watch<theme>().dark
                              ? CupertinoColors.darkBackgroundGray
                              : CupertinoColors.extraLightBackgroundGray,
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              ListTile(
                                leading:
                                    Icon(CupertinoIcons.person_crop_circle),
                                title: Text("Update Profile"),
                                onTap: () {},
                              ),
                              ListTile(
                                leading: Icon(CupertinoIcons.settings),
                                title: Text("Settings"),
                                onTap: () {},
                              ),
                              ListTile(
                                leading: Icon(CupertinoIcons.delete, color: Colors.red,),
                                title: Text("Delete Profile", style: TextStyle(color: Colors.red),),
                                onTap: () {},
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}
