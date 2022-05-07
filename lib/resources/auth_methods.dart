import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  //Logging in user
  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = 'Some error occurred';

    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'success';
      } else {
        res = 'Please enter all the fields';
      }
    } on FirebaseAuthException catch (exception, s) {
      print(exception.toString() + '$s');
      switch ((exception).code) {
        case 'invalid-email':
          return res = 'Invalid email address.';
        case 'wrong-password':
          return res = 'Wrong password.';
        case 'user-not-found':
          return res = 'No user corresponding to the given email address.';
        case 'user-disabled':
          return res = 'This user has been disabled.';
        case 'too-many-requests':
          return res = 'Too many attempts to sign in as this user.';
      }
      // return res = 'Unexpected firebase error, Please try again.';
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
