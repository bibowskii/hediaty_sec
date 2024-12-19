import 'package:hediaty_sec/models/data/Event.dart';
import 'package:hediaty_sec/models/data/collections.dart';
import 'package:hediaty_sec/models/data/users.dart';
import 'package:hediaty_sec/models/domain/event_methods.dart';
import 'package:hediaty_sec/models/repository/event_repo.dart';
import 'db_helper.dart';

final SQLiteService _sqliteService = SQLiteService();

class EventMethodsLocal implements eventRepo {
  // Create an event
  @override
  Future<void> createEvent(Event myEvent) async {
    try {
      await _sqliteService.insert(collections().event, myEvent.toMapSQLite());
      print('Event Created Successfully in Local DB!');
    } catch (e) {
      print('Error creating event: ${e.toString()}');
    }
  }

  // Delete an event
  @override
  Future<void> deleteEvent(Event myEvent) async {
    try {
      await _sqliteService.delete(collections().event, myEvent.id);
      print('Event Deleted Successfully from Local DB!');
    } catch (e) {
      print('Error deleting event: ${e.toString()}');
    }
  }

  // Edit an event
  @override
  Future<void> editEvent(Event myEvent) async {
    try {
      await _sqliteService.update(collections().event, myEvent.id, myEvent.toMap());
      print('Event Updated Successfully in Local DB!');
    } catch (e) {
      print('Error updating event: ${e.toString()}');
    }
  }

  // Get a single event by its ID
  @override
  Future<Map<String, dynamic>?> getEvent(Event myEvent) async {
    try {
      Map<String, dynamic>? event =
      await _sqliteService.queryById(collections().event, myEvent.id);
      if (event != null) {
        print('Event found in Local DB!');
        return event;
      }
    } catch (e) {
      print('Error fetching event: ${e.toString()}');
    }
    return null;
  }

  // Get a list of events related to a user
  Future<List<Map<String, dynamic>>> getListEvents(String userID) async {
    List<Map<String, dynamic>> events = [];
    try {
      events = await _sqliteService.queryByAttribute(collections().event, 'user_id', userID);
      print('Events found for user in Local DB!');
    } catch (e) {
      print('Error fetching events: ${e.toString()}');
    }
    return events;
  }

  Future<void> pushEventsToRemoteDB(List<Map<String, dynamic>> events) async {
    for (var event in events) {
      await eventMethods().createEvent(Event.fromMap(event));
      print('Event ${event['id']} sent to remote DB!');
    }
  }
}
