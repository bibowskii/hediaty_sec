import 'package:hediaty_sec/models/data/collections.dart';
import 'package:hediaty_sec/models/data/users.dart';
import 'package:hediaty_sec/models/repository/users_repository.dart';
import 'package:hediaty_sec/services/firebase_services.dart';

class userMethods implements users_repo {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Future<void> createUser(User myUser) async {
    try {
      _firestoreService.addData(collections().user, myUser.toMap());
      print('user created successfully');
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Future<void> deleteUser(User myUser) async {
    String? docID =
        await _firestoreService.getDocID(collections().user, 'id', myUser.id);
    await _firestoreService.deleteData(collections().user, docID!);
  }

  @override
  Future<void> editUser(User myUser) async {
    String? docID =
        await _firestoreService.getDocID(collections().user, 'id', myUser.id);
    await _firestoreService.updateData(
        collections().user, docID!, myUser.toMap());
  }

  @override
  Future<void> getUser(User myUser) async {
    String? docID =
        await _firestoreService.getDocID(collections().user, 'id', myUser.id);
    await _firestoreService.getDocument(collections().user, docID!);
  }
}