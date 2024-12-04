class User {
  String id; //pk
  String? name;
  String? email;
  int? number;
  String? imageURL;

  User(this.id, this.name, this.email, this.number, this.imageURL);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'number': number,
      'imageURL': imageURL,
    };
  }

  fromMap(Map<String, dynamic> map) {
    return (
      id: map['id'] ?? '',
      number: map['number'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      imageURL: map['imageURl'] ?? '',
    );
  }
}
