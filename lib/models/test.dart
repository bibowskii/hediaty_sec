/*
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hediaty_sec/models/data/Event.dart';
import 'package:hediaty_sec/models/data/Gifts.dart';
import 'package:hediaty_sec/models/data/friends.dart';
import 'package:hediaty_sec/models/data/users.dart';
import 'package:hediaty_sec/models/domain/event_methods.dart';
import 'package:hediaty_sec/models/domain/friends_methods.dart';
import 'package:hediaty_sec/models/domain/gift_methods.dart';
import 'package:hediaty_sec/models/domain/users_methods.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Step 1: Create 3 dummy users
  User user1 = User('1', 'John Doe', 'john.doe@email.com', '1234567890', 'url1');
  User user2 = User('2', 'Jane Smith', 'jane.smith@email.com', '0987654321', 'url2');
  User user3 = User('3', 'Alice Johnson', 'alice.johnson@email.com', '1122334455', 'url3');
  User myUser = User('jdumnEzevmNSBIyZewv7hHSY7ir2', 'AbdELRahman Yasser', 'biboyasser3@gmail.com', '01060442744', 'lib/assets/icons/favicon.png');
  userMethods().createUser(user1);
  userMethods().createUser(user2);
  userMethods().createUser(user3);





DateTime dateOnly = DateTime(
  DateTime.now().year,
  DateTime.now().month,
  DateTime.now().day
);

  // Step 3: Create events for each user
  Event event1 = Event('John\'s Birthday', 'A fun party!', dateOnly, 'e1', 'New York', user1.id);
  Event event2 = Event('Jane\'s Wedding', 'A beautiful ceremony', dateOnly, 'e2', 'Paris', user2.id);
  Event event3 = Event('Alice\'s Conference', 'Tech conference', dateOnly, 'e3', 'San Francisco', user3.id);
  eventMethods().createEvent(event1);
  eventMethods().createEvent(event2);
  eventMethods().createEvent(event3);

  // Step 4: Create gifts for each event
  Gift gift1 = Gift('g1', 'Gift 1', 'A cool gift', 'Tech', true, 100.0, event1.id, user1.id, 'img1');
  Gift gift2 = Gift('g2', 'Gift 2', 'Another cool gift', 'Tech', false, 150.0, event1.id, user1.id, 'img2');
  Gift gift3 = Gift('g3', 'Gift 3', 'Yet another cool gift', 'Tech', true, 200.0, event1.id, user1.id, 'img3');
 giftMethods().createGift(gift1);
  giftMethods().createGift(gift2);
  giftMethods().createGift(gift3);

  Gift gift4 = Gift('g4', 'Gift 4', 'A wedding gift', 'Fashion', true, 250.0, event2.id, user2.id, 'img4');
  Gift gift5 = Gift('g5', 'Gift 5', 'A luxury gift', 'Fashion', false, 300.0, event2.id, user2.id, 'img5');
  Gift gift6 = Gift('g6', 'Gift 6', 'A stylish gift', 'Fashion', true, 350.0, event2.id, user2.id, 'img6');
  giftMethods().createGift(gift4);
  giftMethods().createGift(gift5);
  giftMethods().createGift(gift6);


  Gift gift7 = Gift('g7', 'Gift 7', 'A conference gift', 'Books', true, 50.0, event3.id, user3.id, 'img7');
  Gift gift8 = Gift('g8', 'Gift 8', 'A tech gift', 'Books', false, 75.0, event3.id, user3.id, 'img8');
  Gift gift9 = Gift('g9', 'Gift 9', 'A useful gift', 'Books', true, 120.0, event3.id, user3.id, 'img9');
  giftMethods().createGift(gift7);
  giftMethods().createGift(gift8);
  giftMethods().createGift(gift9);


  /////////////////////////
  Friend friend1 = Friend("jdumnEzevmNSBIyZewv7hHSY7ir2", '2');
  Friend friend2 = Friend("jdumnEzevmNSBIyZewv7hHSY7ir2", '3');

  Follow().followFriend(friend1);
  Follow().followFriend(friend2);
  Follow().getListFriends(myUser);









}
*/
