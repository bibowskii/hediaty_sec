import 'package:hediaty_sec/models/data/Event.dart';
import 'package:hediaty_sec/models/data/Gifts.dart';
import 'package:hediaty_sec/models/data/collections.dart';
import 'package:hediaty_sec/models/repository/gifts_repo.dart';
import 'package:hediaty_sec/services/user_manager.dart';

import '../data/users.dart';
import 'db_helper.dart';

class GiftMethods implements gifts_repo  {
  final SQLiteService _sqliteService = SQLiteService();

  @override
  Future<void> createGift(Gift myGift) async {
    try {
      await _sqliteService.insert(
        collections().gifts,
        myGift.toMap(),
      );
      print('Gift Created successfully');
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Future<void> deleteGift(Gift myGift) async {
    try {
      await _sqliteService.delete(collections().gifts, myGift.id);
      print('Gift deleted Successfully');
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Future<void> editGift(Gift myGift) async {
    try {
      await _sqliteService.update(
        collections().gifts,
        myGift.id,
        myGift.toMap(),
      );
      print('Gift Updated Successfully');
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getGifts(User myUser) async {
    List<Map<String, dynamic>> gifts = [];
    try {
      gifts = await _sqliteService.queryByAttribute(
        collections().gifts,
        'user_id',
        myUser.id,
      );
      print('List of gifts found successfully');
      return gifts;
    } catch (e) {
      print(e.toString());
      return gifts;
    }
  }

  Future<Map<String, dynamic>?> getOneGift(Gift myGift) async {
    try {
      Map<String, dynamic>? gift = await _sqliteService.queryById(
        collections().gifts,
        myGift.id,
      );
      if (gift != null) {
        print('Gift fetched successfully');
      }
      return gift;
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getGiftsForEvent(Event myEvent) async {
    List<Map<String, dynamic>> gifts = [];
    try {
      gifts = await _sqliteService.queryByAttribute(
        collections().gifts,
        'event_id',
        myEvent.id,
      );
      print('List of gifts for event found successfully');
      return gifts;
    } catch (e) {
      print(e.toString());
      return gifts;
    }
  }

  Future<void> pledge(Gift myGift) async {
    try {
      Map<String, dynamic>? gift = await getOneGift(myGift);
      if (gift != null) {
        await _sqliteService.update(
          collections().gifts,
          myGift.id,
          {'pledgedBy': UserManager().getUserId()},
        );
        print('Gift pledged');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> unpledge(Gift myGift) async {
    try {
      await _sqliteService.update(
        collections().gifts,
        myGift.id,
        {'pledgedBy': ''},
      );
      print('Gift unpledged');
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getListPledges(String userID) async {
    List<Map<String, dynamic>> pledges = [];
    try {
      pledges = await _sqliteService.queryByAttribute(
        collections().gifts,
        'pledgedBy',
        userID,
      );
      print('List of pledges found successfully');
      return pledges;
    } catch (e) {
      print(e.toString());
      return pledges;
    }
  }
}
