// supposedly done

import 'package:hediaty_sec/models/data/Event.dart';
import 'package:hediaty_sec/models/data/collections.dart';
import 'package:hediaty_sec/models/data/users.dart';
import 'package:hediaty_sec/models/repository/event_repo.dart';
import 'package:hediaty_sec/services/firebase_services.dart';

final FirestoreService _firestoreService = FirestoreService();

class eventMethods implements eventRepo {
  // create an event
  @override
  Future<void> createEvent(Event myEvent) async {
    try {
      _firestoreService.addData(collections().event, myEvent.toMap());
      print('Event Created Successfully!');
    } catch (e) {
      print(e.toString());
    }
  }

// delete an event
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

// edit an event
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

//get a single event by its ID
  @override
  Future<Map<String, dynamic>?> getEvent(Event myEvent) async {
    try {
      String? docID = await _firestoreService.getDocID(
          collections().event, 'id', myEvent.id);

      Map<String, dynamic>? event =
          await _firestoreService.getDocument(collections().event, docID!);
      if (event != null) {
        print('event found');
        return event;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // get a list of events related to a user
  Future<List<Map<String, dynamic>>> getListEvents(User myUser)async {
    List<Map<String, dynamic>> events = [];
    try{
      await _firestoreService.getList(collections().event, 'userID', myUser.id);
      print('events found');
      return events;
    }catch(e){
      print(e.toString());
      return events;
    }
  }
}
