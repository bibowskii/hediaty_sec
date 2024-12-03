class Gift{
  String id; //pk
  String name;
  String description;
  String category;
  bool status;
  double price;
  String eventID; //fk
  String userID; //fk
  String imgURl;

  Gift(this.id, this.name, this.description, this.category, this.status, this.price, this.eventID, this.userID, this.imgURl );


}