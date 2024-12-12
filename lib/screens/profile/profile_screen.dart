import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hediaty_sec/models/data/users.dart';
import 'package:hediaty_sec/models/domain/users_methods.dart';
import 'package:hediaty_sec/providers/theme_provider.dart';
import 'package:hediaty_sec/services/user_manager.dart';
import 'package:provider/provider.dart';

class profileScreen extends StatefulWidget {
  profileScreen({super.key});

  @override
  State<profileScreen> createState() => _profileScreenState();
}

class _profileScreenState extends State<profileScreen> {
  User? userData;
  bool isLoading = true;  // To handle loading state

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
      backgroundColor: context.watch<theme>().dark ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: context.watch<theme>().dark ? Colors.black : Colors.white,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : userData == null
          ? Center(child: Text('No user data found'))
          : Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: context.watch<theme>().dark ? Colors.black : Colors.white,
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
                        CircleAvatar(
                          child: Icon(CupertinoIcons.person),
                          radius: 50,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          children: [
                            Text(
                              userData!.name ?? 'No Name',  // Use fetched data
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(userData!.email ?? 'No Email',  // Use fetched data
                                style: TextStyle(fontSize: 18)),
                            SizedBox(
                              height: 4,
                            ),
                            Text(userData!.number ?? 'No Number',  // Use fetched data
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
                      leading: Icon(CupertinoIcons.person_crop_circle),
                      title: Text("Update Profile"),
                      onTap: () {
                      },
                    ),
                    ListTile(
                      leading: Icon(CupertinoIcons.delete),
                      title: Text("Delete Profile"),
                      onTap: () {

                      },
                    ),
                    ListTile(
                      leading: Icon(CupertinoIcons.settings),
                      title: Text("Settings"),
                      onTap: () {
                      },
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
