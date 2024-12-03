class Event {
  String id; //primary key
  String userID; //fk
  String name;
  String location;
  String description;
  DateTime date;

  Event(this.name, this.description, this.date, this.id, this.location,
      this.userID);
}
