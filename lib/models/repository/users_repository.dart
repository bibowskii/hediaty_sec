import '../data/users.dart';

abstract class users_repo {
  createUser(User myUser);
  deleteUser(User myUser);
  editUser(User myUser);
  getUser(User myUser);
}
