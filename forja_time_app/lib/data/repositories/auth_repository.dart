import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import 'package:google_sign_in/google_sign_in.dart';

import '../models/user_model.dart';

class AuthRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  AuthRepository({
    firebase_auth.FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance;

  var currentUser = User.empty;

  Stream<User> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      print('FIREBASE $firebaseUser');
      final User user;
      if (firebaseUser == null) {
        user = User.empty;
      } else if (firebaseUser.providerData[0].providerId == 'google.com') {
        user = User(
            id: firebaseUser.uid,
            name: firebaseUser.displayName,
            email: firebaseUser.email,
            photo: firebaseUser.photoURL,
            isGoogleAccount: true);
      } else {
        user = User(
            id: firebaseUser.uid,
            name: firebaseUser.displayName,
            email: firebaseUser.email,
            photo: firebaseUser.photoURL,
            isGoogleAccount: false);
      }

      currentUser = user;
      return user;
    });
  }

  Future signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      print('google user is $googleUser');
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      print('google auth is $googleAuth');
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      print('google credential is $credential');
      await _firebaseAuth.signInWithCredential(credential);
    } catch (e) {}
  }

  Future<void> signup({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (_) {}
  }

  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (_) {}
  }

  Future<void> logOut() async {
    try {
      //Future.wait : Returns a future which will complete once all the
      // provided futures have completed, either with their results,
      //or with an error if any of the provided futures fail.
      await Future.wait([
        _firebaseAuth.signOut(),
      ]);
    } catch (_) {}
  }

  Future<void> googleLogOut() async {
    try {
      //Future.wait : Returns a future which will complete once all the
      // provided futures have completed, either with their results,
      //or with an error if any of the provided futures fail.
      await Future.wait([
        _googleSignIn.disconnect(),
        _firebaseAuth.signOut(),
      ]);
    } catch (_) {}
  }
}

// extension on firebase_auth.User {
//   User get toUser {
//     return User(id: uid, email: email, name: displayName, photo: photoURL);
//   }
// }
