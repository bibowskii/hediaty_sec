//supposedly done

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
  Future<Map<String, dynamic>?> getUser(User myUser) async {
    try {
      String? docID =
          await _firestoreService.getDocID(collections().user, 'id', myUser.id);
      if (docID != null) {
        Map<String, dynamic>? user =
            await _firestoreService.getDocument(collections().user, docID!);
        if (user != null) {
          print('user found');
        }
        return user;
      }
    } catch (e) {
      print(e.toString());
      print('error getting the user');
    }
  }

  Future<Map<String, dynamic>?> getUserByID(String ID) async {
    try {
      String? docID =
          await _firestoreService.getDocID(collections().user, 'id', ID);
      if (docID != null) {
        Map<String, dynamic>? user =
            await _firestoreService.getDocument(collections().user, docID!);
        if (user != null) {
          print('user found');
        }
        return user;
      }
    } catch (e) {
      print(e.toString());
      print('error getting the user');
    }
  }

  Future<User?> FindUserByNumber(String number) async {
    try {
      var document = await _firestoreService.getDocumentByAttribute(
          collections().user, 'number', number);
      if(document != null) {
        User myUser = User.fromMap(document);
        return myUser;
      }

    }catch (e) {
      print(e.toString());
      return null;
    }
  } //Future<List<Map<String, dynamic>>>
}
