import 'FCM_api.dart';

class NotificationService {
  final FirebaseMessagingService _fcm;

  NotificationService(this._fcm);

  Future<void> sendNewFriendNotification(String followedUserToken) async {
    await _fcm.sendNotificationToToken(
      followedUserToken,
      'New Follower!',
      'Someone followed you!',
    );
  }

  Future<void> sendGiftPledgedNotification(String giftOwnerToken) async {
    await _fcm.sendNotificationToToken(
      giftOwnerToken,
      'Gift Pledged!',
      'Someone pledged your gift!',
    );
  }

  Future<void> subscribeToTopic(String topic) async {
    await _fcm.subscribeToTopic(topic);
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await _fcm.unsubscribeFromTopic(topic);
  }

  Future<void> subscribeToNewFriendTopic(String userID) async {
    String topic = 'new_friend_$userID';
    await subscribeToTopic(topic);
  }

  Future<void> unsubscribeFromNewFriendTopic(String userID) async {
    String topic = 'new_friend_$userID';
    await unsubscribeFromTopic(topic);
  }

  Future<void> subscribeToGiftPledgedTopic(String userID) async {
    String topic = 'gift_pledged_$userID';
    await subscribeToTopic(topic);
  }

  Future<void> unsubscribeFromGiftPledgedTopic(String userID) async {
    String topic = 'gift_pledged_$userID';
    await unsubscribeFromTopic(topic);
  }

  Future<String?> getFcmToken(String userID) async {
    // implement logic to get FCM token from database
  }

  Future<void> updateFcmToken(String userID, String token) async {
    // implement logic to update FCM token in database
  }

  Future<void> deleteFcmToken(String userID) async {
    // implement logic to delete FCM token from database
  }
}