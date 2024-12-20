import 'package:dio/dio.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:hediaty_sec/keys/key.dart';

class NotificationService {
  static var jsonCred = key;
  static Future<String> _getAccessToken() async {
    final credentials = ServiceAccountCredentials.fromJson(jsonCred);

    final client = await clientViaServiceAccount(
        credentials, ['https://www.googleapis.com/auth/firebase.messaging']);

    final token = client.credentials.accessToken.data;
    client.close();
    return token;
  }

  static Future<void> sendNotification(
       String messageBody, String? fcmToken, String title) async {
    if (fcmToken == null) return;

    final dio = Dio();
    final accessToken = await _getAccessToken();
    try {
      await dio.post(
        'https://fcm.googleapis.com/v1/projects/hedieaty-df924/messages:send',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
        ),
        data: {
          'message': {
            'token': fcmToken,
            'notification': {
              'title': title,
              'body': messageBody
            },
            'data': {
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'payload': 'gift_pledged',
            }
          }
        },
      );
    } catch (e) {
      print('Error sending notification: $e');
    }
  }
}