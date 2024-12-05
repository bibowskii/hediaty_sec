class Event {
  String id; //primary key
  String userID; //fk
  String name;
  String location;
  String description;
  DateTime date;

  Event(this.name, this.description, this.date, this.id, this.location,
      this.userID);

  Map<String, dynamic> toMap() {
    return{
      'id':id,
      'userID':userID,
      'name':name,
      'location':location,
      'description':description,
      'date':date,
    };
  }
  Event.fromMap(Map<String,dynamic> map):
    id=map['id'] ?? '',
    userID=map["userId"] ?? '',
    name=map["name"] ?? '',
    location=map['location'] ?? '',
    description=map['description'] ?? '',
    date=map['date'] ;


}
