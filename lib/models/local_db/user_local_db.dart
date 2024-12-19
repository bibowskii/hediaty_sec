import 'package:hediaty_sec/models/data/collections.dart';
import 'package:hediaty_sec/models/data/users.dart';
import 'package:hediaty_sec/models/repository/users_repository.dart';
import 'db_helper.dart';

class UserMethodsSqflite implements users_repo {
  final SQLiteService _dbService = SQLiteService();

  @override
  Future<void> createUser(User myUser) async {
    try {
      await _dbService.insert(collections().user, {'id': myUser.id, 'number': myUser.number, 'email': myUser.email});
      print('User created successfully');
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Future<void> deleteUser(User myUser) async {
    try {
      await _dbService.delete(collections().user, myUser.id);
      print('User deleted successfully');
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Future<void> editUser(User myUser) async {
    try {
      await _dbService.update(collections().user, myUser.id, {'id': myUser.id, 'number': myUser.number, 'email': myUser.email});
      print('User updated successfully');
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>?> getUser(User myUser) async {
    try {
      Map<String, dynamic>? result = await _dbService.queryById(collections().user, myUser.id);
      if (result != null) {
        print('User found');
        return result;
      }
    } catch (e) {
      print(e.toString());
      print('Error getting the user');
    }
    return null;
  }

  Future<Map<String, dynamic>?> getUserByID(String ID) async {
    try {
      Map<String, dynamic>? result = await _dbService.queryById(collections().user, ID);
      if (result != null) {
        print('User found');
        return result;
      }
    } catch (e) {
      print(e.toString());
      print('Error getting the user');
    }
    return null;
  }

  Future<User?> findUserByNumber(String number) async {
    try {
      List<Map<String, dynamic>> result = await _dbService.queryByAttribute(collections().user, 'number', number);
      if (result.isNotEmpty) {
        User myUser = User.fromMap(result.first);
        return myUser;
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }
}
