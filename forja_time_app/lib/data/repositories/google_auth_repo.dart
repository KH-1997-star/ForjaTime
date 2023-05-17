import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static const List<String> scopes = <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ];

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    // Optional clientId
    // clientId: 'your-client_id.apps.googleusercontent.com',
    scopes: scopes,
  );

  GoogleSignInAccount? _currentUser;
  Future signInWithGoogle() async {
    print('entred');
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      print('google user is $googleUser');
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      print('google auth is $googleAuth');
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      print('google credential is $credential');
      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {}
  }
}
