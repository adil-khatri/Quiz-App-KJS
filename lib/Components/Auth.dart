import 'package:flutter/material.dart';
import 'package:quiz_app_kjs/Components/user.dart';
import 'Authentication.dart';

abstract class AuthService {

  Stream<UserModel> get onAuthStateChanged;
  Future signInWithGoogle(BuildContext context);
  // Future signOutUser();

}