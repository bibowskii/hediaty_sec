import 'package:firebase_auth/firebase_auth.dart';
import 'package:hediaty_sec/services/shared_prefs_service.dart';


class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();


  Stream<User?> get user {
    return _auth.authStateChanges();
  }

  // Sign in method
  Future<UserCredential?> signIn( {required String email,
      required String password}) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential;
    }
    on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          print('No user found for that email, try creating an account.');
          break;
        case 'wrong-password':
          print('Wrong email or password.');
          break;
        default:
          print('Error signing in: ${e.message}');
      }
      return null;
    } catch (e) {
      print('Error: ${e.toString()}');
      return null;
    }
  }

  Future<void> signOut() async{
    await _auth.signOut();
  }
}
