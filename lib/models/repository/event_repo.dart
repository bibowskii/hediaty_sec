import '../data/Event.dart';

abstract class eventRepo {
  createEvent(Event myEvent);
  deleteEvent(Event myEvent);
  editEvent(Event myEvent);
  getEvent(Event myEvent);
}
