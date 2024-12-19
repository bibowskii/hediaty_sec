import 'package:hediaty_sec/models/local_db/event_local_db.dart';
import 'package:hediaty_sec/services/user_manager.dart';
import 'package:hediaty_sec/models/data/Event.dart';

import 'package:hediaty_sec/models/local_db/db_helper.dart';

class DraftEventListController {

  static DraftEventListController? _instance;
  static DraftEventListController get instance {
    _instance ??= DraftEventListController._();
    return _instance!;
  }

  DraftEventListController._();

  Future<List<Event>> fetchLocalDraftEvents() async {

    var eventsMap = await EventMethodsLocal().getListEvents(UserManager().getUserId()!);
    List<Event> events = eventsMap.map((map) => Event.fromMapSQLite(map)).toList();
    return events;
  }
}