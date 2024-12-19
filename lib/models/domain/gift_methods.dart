// supposedly done

import 'package:flutter/material.dart';
import 'package:hediaty_sec/models/data/Event.dart';
import 'package:hediaty_sec/models/data/Gifts.dart';
import 'package:hediaty_sec/models/data/collections.dart';
import 'package:hediaty_sec/models/repository/gifts_repo.dart';
import 'package:hediaty_sec/services/firebase_services.dart';
import 'package:hediaty_sec/services/user_manager.dart';

import '../data/users.dart';

class giftMethods implements gifts_repo {
  final FirestoreService _firestoreService = FirestoreService();


  @override
  Future<void> createGift(Gift myGift) async {
    try {
      await _firestoreService.addData(collections().gifts, myGift.toMap());
      print('Gift Created successfully');
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Future<void> deleteGift(Gift myGift) async {
    try {
      String? docID = await _firestoreService.getDocID(
          collections().gifts, 'id', myGift.id);
      await _firestoreService.deleteData(collections().gifts, docID!);
      print('Gift deleted Successfully');
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Future<void> editGift(Gift myGift) async {
    try {
      String? docID = await _firestoreService.getDocID(
          collections().gifts, 'id', myGift.id);
      await _firestoreService.updateData(
          collections().gifts, docID!, myGift.toMap());
      print('Gift Updated Successfully ');
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getGifts(User myUser) async {
    List<Map<String, dynamic>> gifts = [];
    try {
      gifts =
      await _firestoreService.getList(collections().gifts, 'userID', myUser.id);
      print('list of gifts found succesfully');
      return gifts;
    } catch (e) {
      print(e.toString());
      return gifts;
    }
  }

  Future<Map<String, dynamic>?> getOneGift(Gift myGift) async {
    try {
      String? docID = await _firestoreService.getDocID(
          collections().gifts, 'id', myGift.id);
      if (docID != null) {
        Map<String, dynamic>? gift = await _firestoreService.getDocument(
            collections().gifts, docID!);
        if (gift != null) {
          print('gift fetched successfully ');
        }
        return gift;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getGiftsForEvent(Event myEvent) async {
    List<Map<String, dynamic>> gifts = [];
    try {
      gifts = await _firestoreService.getList(
          collections().gifts, 'eventID', myEvent.id);
      print('list of gifts found succesfully');
      return gifts;
    } catch (e) {
      print(e.toString());
      return gifts;
    }
  }

  Future<void> pledge(Gift myGift) async {
    try {
      String? docID = await _firestoreService.getDocID(
          collections().gifts, 'id', myGift.id);
      await _firestoreService.updateSingelAtt(
          collections().gifts, docID!, 'pledgedBy', UserManager().getUserId()!);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> unpledge(Gift myGift) async {
    try {
      String? docID = await _firestoreService.getDocID(
          collections().gifts, 'id', myGift.id);
      await _firestoreService.updateSingelAtt(
          collections().gifts, docID!, 'pledgedBy', '');
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getListPledges(String UserID) async {
    List<Map<String, dynamic>> pledges = [];
    try {
      pledges = await _firestoreService.getList(
          collections().gifts, 'pledgedBy', UserID);
      print('pledged found');
      return pledges;
    } catch (e) {
      print(e.toString());
      return pledges;
    }
  }

  Future<void> deleteALLGiftsByEventID(String eventID) async {
    try {
      await _firestoreService.deleteAllData(
          collections().gifts, 'eventID', eventID);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> buyGift(Gift myGift) async {
    try {
      String? docID = await _firestoreService.getDocID(
          collections().gifts, 'id', myGift.id);
      await _firestoreService.updatebool(
          collections().gifts, docID!, 'status', true);
    } catch (e) {
      print(e.toString());
    }
  }
  Future<void> unBuyGift(Gift myGift) async {
    try {
      String? docID = await _firestoreService.getDocID(
          collections().gifts, 'id', myGift.id);
      await _firestoreService.updatebool(
          collections().gifts, docID!, 'status', false);
    } catch (e) {
      print(e.toString());
    }
  }
}