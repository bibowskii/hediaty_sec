class Friend {
  String UserID;
  String FriendID;

  Friend(this.UserID, this.FriendID);

  Map<String, dynamic> toMap() {
    return {
      'UserID': UserID,
      'FriendID': FriendID,
    };
  }

  factory Friend.fromMap(Map<String, dynamic> map) {
    return Friend(
      map['UserID'],
      map['FriendID'],
    );
  }
}
