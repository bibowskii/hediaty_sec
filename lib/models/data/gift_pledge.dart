class PledgedBy {
  String userID;
  String giftID;

  PledgedBy({required this.userID, required this.giftID});

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'giftID': giftID,
    };
  }

  factory PledgedBy.fromMap(Map<String, dynamic> map) {
    return PledgedBy(
      userID: map['userID'],
      giftID: map['giftID'],
    );
  }
}
