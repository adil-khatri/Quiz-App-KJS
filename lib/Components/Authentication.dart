import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_app_kjs/Components/user.dart';
import 'Auth.dart';


class FirebaseAuthService implements AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final CollectionReference users =
  FirebaseFirestore.instance.collection('Users');
  UserModel _userFromFirebase(User? user) {
    return UserModel(
      uid: user!.uid,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoURL,
      phoneNumber: user.phoneNumber,
    );
  }
  UserModel? currentUser() {
    final User? user = _firebaseAuth.currentUser;
    if (user != null)
      return _userFromFirebase(user);
    else
      return null;
  }

  @override
  Stream<UserModel> get onAuthStateChanged {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }
  Future<UserModel> signInWithGoogle(BuildContext context) async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
    await googleUser!.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final authResult = await _firebaseAuth.signInWithCredential(credential);
    final user = authResult.user;
    final CollectionReference users =
    FirebaseFirestore.instance.collection('Users');
    // Future<void> createFirebaseDocument(User user) {
    //   return
    // }

    // add the users document if not ready
    users.doc(user!.email).get().then(
          (DocumentSnapshot documentSnapshot) async {
        if (!documentSnapshot.exists) {
          await users.doc(user.email).set({
            "name": user.displayName,
            "email": user.email,
            "phoneFromAuth": user.phoneNumber ?? null,
          }).catchError((error) => print("Failed to add user: $error"));
          Navigator.pushReplacementNamed(context, "/setProfile");
        } else {
          Navigator.pushReplacementNamed(context, "/home");
          Fluttertoast.showToast(msg: "Sign in successful!");
        }
      },
    );
    return _userFromFirebase(user);
  }
}