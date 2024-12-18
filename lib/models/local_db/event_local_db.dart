import 'package:hediaty_sec/models/data/Event.dart';
import 'package:hediaty_sec/models/data/users.dart';
import 'package:hediaty_sec/models/repository/event_repo.dart';
import 'db_helper.dart';

final SQLiteService _sqliteService = SQLiteService();

class EventMethodsLocal implements eventRepo {
  // Create an event
  @override
  Future<void> createEvent(Event myEvent) async {
    try {
      await _sqliteService.insert('Events', myEvent.toMap());
      print('Event Created Successfully in Local DB!');
    } catch (e) {
      print('Error creating event: ${e.toString()}');
    }
  }

  // Delete an event
  @override
  Future<void> deleteEvent(Event myEvent) async {
    try {
      await _sqliteService.delete('Events', myEvent.id);
      print('Event Deleted Successfully from Local DB!');
    } catch (e) {
      print('Error deleting event: ${e.toString()}');
    }
  }

  // Edit an event
  @override
  Future<void> editEvent(Event myEvent) async {
    try {
      await _sqliteService.update('Events', myEvent.id, myEvent.toMap());
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
      await _sqliteService.queryById('Events', myEvent.id);
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
  Future<List<Map<String, dynamic>>> getListEvents(User myUser) async {
    List<Map<String, dynamic>> events = [];
    try {
      events = await _sqliteService.queryByAttribute('Events', 'user_id', myUser.id);
      print('Events found for user in Local DB!');
    } catch (e) {
      print('Error fetching events: ${e.toString()}');
    }
    return events;
  }
}
