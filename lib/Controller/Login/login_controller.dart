import 'package:expanse_manager/Services/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:expanse_manager/Utils/utils.dart';

class LoginController with ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;

  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void Login(String email, String Password) async {
    setLoading(true);
    try {
      auth
          .signInWithEmailAndPassword(
        email: email,
        password: Password,
      )
          .then((value) {
        SessionController().userID = value.user!.uid.toString();
      }).onError((error, stackTrace) {
        setLoading(false);
        utils().toastMessage(error.toString());
      });
    } catch (e) {
      utils().toastMessage(e.toString());
    }
  }
}
