class User {
  String id; // pk
  String? name;
  String? email;
  String? number;
  String? imageURL;

  User(this.id, this.name, this.email, this.number, this.imageURL,);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'number': number,
      'imageURL': imageURL,
    };
  }

  User.fromMap(Map<String, dynamic> map)
      : id = map['id'] ?? '',
        name = map['name'] ?? '',
        email = map['email'] ?? '',
        number = map['number'] ?? '',
        imageURL = map['imageURL'] ?? '';
}

