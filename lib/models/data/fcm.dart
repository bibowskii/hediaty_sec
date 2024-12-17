class UserFc{
  String id;
  String token;

  UserFc({required this.id, required this.token});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'token': token,
    };
  }

  factory UserFc.fromMap(Map<String, dynamic> map) {
    return UserFc(
      id: map['id'],
      token: map['token'],
    );
  }

}