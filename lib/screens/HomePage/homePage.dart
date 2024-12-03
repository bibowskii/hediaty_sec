import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hediaty_sec/widgets/customNavBar.dart';
import 'package:hediaty_sec/widgets/customSearchBar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:hediaty_sec/providers/theme_provider.dart';
import 'package:provider/provider.dart';


class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.extraLightBackgroundGray,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Text(
          'Hediaty',
          style: TextStyle(
            fontSize: 35,
          ),
        ),
        centerTitle: true,
        shadowColor: Colors.black54,
        actions: [
          IconButton(
            icon: Icon(context.watch<theme>().dark ? Icons.wb_sunny : Icons.nightlight_round),
            onPressed: () {
              context.read<theme>().changeTheme();
            },
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Iconsax.profile_add),
          ),
        ],
      ),
      body: const Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: [
                customSearchBar(),
                SizedBox(height: 40,),
                Text('Upcoming Events this Month'),
                SizedBox(height: 10,),
                SingleChildScrollView(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [],
                  ),
                ),
                SizedBox(height: 20,),
                Text('Upcoming Events this Year'),
                SizedBox(height: 10,),
                SingleChildScrollView(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [],
                  ),
                ),
                SizedBox(height: 20,),
                Text('No Events'),
                SizedBox(height: 10,),
                SingleChildScrollView(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: const FloatingActionButton(
          onPressed: null,
          backgroundColor: Colors.lightGreenAccent,
          tooltip: 'Add Event',
          child: Row(
            children: [
              Icon(
                Icons.add,
                size: 15,
              ),
              Icon(
                Icons.event_outlined,
                color: Colors.black,
                size: 30,
              ),
            ],
          )),
      bottomNavigationBar: const cusNavBar(),
    );
  }
}
