class Gift {
  String id; //pk
  String name;
  String description;
  String category;
  bool status;
  double price;
  String eventID; //fk
  String userID; //fk
  String? imgURl;
  String? pledgedBy;

  Gift(this.id, this.name, this.description, this.category, this.status,
      this.price, this.eventID, this.userID, this.imgURl, this.pledgedBy);


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'status': status,
      'price': price,
      'eventID': eventID,
      'userID': userID,
      'imgURl': imgURl,
      'pledgedBy': pledgedBy,
    };
  }

  // Create a Gift object from a Map
  factory Gift.fromMap(Map<String, dynamic> map) {
    return Gift(
      map['id'] ?? '',
      map['name'] ?? '',
      map['description'] ?? '',
      map['category'] ?? '',
      map['status'] ?? false,
      map['price'] ?? 0.0,
      map['eventID'] ?? '',
      map['userID'] ?? '',
      map['imgURl'] ?? '',
      map['pledgedBy']??'',
    );
  }

/*  factory Gift.fromMapSQLite(Map<String, dynamic> map) {
    return Gift(
      map['id'] ?? '',
      map['name'] ?? '',
      map['description'] ?? '',
      map['category'] ?? '',
      map['status'] ?? false,
      map['price'] ?? 0.0,
      map['eventID'] ?? '',
      map['userID'] ?? '',
    );
  }*/
  Map<String, dynamic> toMapSQLite() => toMap()..remove('pledgedBy')..remove('imgURl'); // Remove pledgedBy field from the map>

}
