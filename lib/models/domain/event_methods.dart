import 'dart:js_interop';

import 'package:hediaty_sec/models/data/Event.dart';
import 'package:hediaty_sec/models/data/collections.dart';
import 'package:hediaty_sec/models/repository/event_repo.dart';
import 'package:hediaty_sec/services/firebase_services.dart';

final FirestoreService _firestoreService = FirestoreService();

class eventMethods implements eventRepo {
  @override
  Future<void> createEvent(Event myEvent) async {
    try {
      _firestoreService.addData(collections().event, myEvent.toMap());
      print('Event Created Successfully!');
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Future<void> deleteEvent(Event myEvent) async {
    try {
      String? docID = await _firestoreService.getDocID(
          collections().event, 'id', myEvent.id);
      await _firestoreService.deleteData(collections().event, docID!);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Future<void> editEvent(Event myEvent) async {
    try {
      String? docID = await _firestoreService.getDocID(
          collections().event, 'id', myEvent.id);
      await _firestoreService.updateData(
          collections().event, docID!, myEvent.toMap());
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Future<void> getEvent(Event myEvent) async {
    try {
      String? docID = await _firestoreService.getDocID(
          collections().event, 'id', myEvent.id);
      await _firestoreService.getDocument(collections().event, docID!);
    } catch (e) {
      print(e.toString());
    }
  }
}
