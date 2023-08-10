import 'package:expanse_manager/Services/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:expanse_manager/Utils/utils.dart';

class SignupController with ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  DatabaseReference ref = FirebaseDatabase.instance.ref().child('User');

  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void SignUp(String username, String email, String Password) async {
    setLoading(true);
    try {
      auth
          .createUserWithEmailAndPassword(
        email: email,
        password: Password,
      )
          .then((value) {
        SessionController().userID = value.user!.uid.toString();
        ref.child(value.user!.uid.toString()).set({
          'uid': value.user!.uid.toString(),
          'email': value.user!.email.toString(),
          'username': username,
          'phone': '',
          'profile': '',
        }).then((value) {
          setLoading(false);
        });
      }).onError((error, stackTrace) {
        setLoading(false);
        utils().toastMessage(error.toString());
      });
    } catch (e) {
      utils().toastMessage(e.toString());
    }
  }
}
