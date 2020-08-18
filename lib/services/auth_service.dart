import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final _auth = FirebaseAuth.instance;

  Stream<FirebaseUser> get currentUser => _auth.onAuthStateChanged;
  Future<AuthResult> signInWithCredentials(AuthCredential credential) =>
      _auth.signInWithCredential(credential);
  Future<void> signOut() => _auth.signOut();

  Future<FirebaseUser> getCurrentUser() => _auth.currentUser();
}
