import 'package:cloud_firestore/cloud_firestore.dart';


class Event {
  String id; // primary key
  String userID; // foreign key
  String name;
  String location;
  String description;
  DateTime date;
  String? category;

  Event(this.name, this.description, this.date, this.id, this.location, this.userID, this.category);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userID': userID,
      'name': name,
      'location': location,
      'description': description,
      'date': date, // save as DateTime, can be converted to Timestamp in Firestore
      'category': category,

    };
  }

  Event.fromMap(Map<String, dynamic> map)
      : id = map['id'] ?? '',
        userID = map['userID'] ?? '',
        name = map['name'] ?? '',
        location = map['location'] ?? '',
        description = map['description'] ?? '',
        date = map['date'] is Timestamp
            ? (map['date'] as Timestamp).toDate()  // Convert Timestamp to DateTime
            : map['date'] is DateTime
            ? map['date'] // If it's already DateTime, use it directly
            : DateTime.now(), // Default to current date if it's null or invalid
        category = map['category'];



Map<String, dynamic> toMapSQLite() {
  return {
    'id': id,
    'UserID': userID,
    'name': name,
    'location': location,
    'description': description,
    'date': date.toIso8601String(), // Convert DateTime to ISO8601 String
    'category': category,
  };
}

Event.fromMapSQLite(Map<String, dynamic> map)
    : id = map['id'] ?? '',
      userID = map['UserID'] ?? '',
      name = map['name'] ?? '',
      location = map['location'] ?? '',
      description = map['description'] ?? '',
      date = map['date'] != null
          ? DateTime.parse(map['date']) // Parse ISO8601 String to DateTime
          : DateTime.now(),
      category = map['category'];

}
