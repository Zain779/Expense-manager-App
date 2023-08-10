import 'package:expanse_manager/Utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:expanse_manager/Services/session_manager.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:expanse_manager/Utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';

class ProfileController with ChangeNotifier {
  DatabaseReference ref = FirebaseDatabase.instance.ref().child('User');
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  final nameFocusNode = FocusNode();
  final phoneFocusNode = FocusNode();

  final picker = ImagePicker();

  XFile? _image;
  XFile? get image => _image;

  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future pickGalleryImage(BuildContext context) async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);

    if (pickedFile != null) {
      _image = XFile(pickedFile.path);
      notifyListeners();
      uploadImage(context);
    }
  }

  Future pickCameraImage(BuildContext context) async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 100);

    if (pickedFile != null) {
      _image = XFile(pickedFile.path);
      notifyListeners();
      uploadImage(context);
    }
  }

  void pickImage(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              height: 120,
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      pickCameraImage(context);
                      Navigator.pop(context);
                    },
                    leading: Icon(
                      Icons.camera_alt,
                      color: ThemeColor1,
                    ),
                    title: const Text('Camera'),
                  ),
                  ListTile(
                    onTap: () {
                      pickGalleryImage(context);
                      Navigator.pop(context);
                    },
                    leading: Icon(
                      Icons.image,
                      color: ThemeColor1,
                    ),
                    title: const Text('Gallery'),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void uploadImage(BuildContext context) async {
    setLoading(true);
    firebase_storage.Reference StorageRef = firebase_storage
        .FirebaseStorage.instance
        .ref('/profileImage' + SessionController().userID.toString());
    firebase_storage.UploadTask uploadTask =
        StorageRef.putFile(File(image!.path).absolute);

    await Future.value(uploadTask);
    final newUrl = await StorageRef.getDownloadURL();

    ref
        .child(SessionController().userID.toString())
        .update({'profile': newUrl.toString()})
        .then((value) => () {
              setLoading(false);
              utils().toastMessage('Profile Updated');
              _image = null;
            })
        .onError((error, stackTrace) => () {
              utils().toastMessage(error.toString());
              setLoading(false);
            });
  }

  Future<void> showUserNameDialogueAlert(BuildContext context, String name) {
    return showDialog(
        context: context,
        builder: (context) {
          nameController.text = name;
          return AlertDialog(
            title: const Center(child: Text('Update UserName')),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: 'Name',
                      fillColor: const Color(0xffF8F9FA),
                      filled: true,
                      // prefixIcon: const Icon(Icons.person_pin,color: Color(0xff323F4B),),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xffE4E7EB)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xffE4E7EB)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    ref.child(SessionController().userID.toString()).update({
                      'User Name': nameController.text.toString()
                    }).then((value) => {nameController.clear()});
                    Navigator.pop(context);
                  },
                  child:
                      Text('Ok', style: Theme.of(context).textTheme.subtitle2)),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2!
                        .copyWith(color: ThemeColor1),
                  ))
            ],
          );
        });
  }

  Future<void> showPhoneDialogueAlert(
      BuildContext context, String phoneNumber) {
    return showDialog(
        context: context,
        builder: (context) {
          phoneController.text = phoneNumber;
          return AlertDialog(
            title: const Center(child: Text('Update PhoneNumber')),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: phoneController,
                    decoration: InputDecoration(
                      hintText: 'Enter Phone Number',
                      fillColor: const Color(0xffF8F9FA),
                      filled: true,
                      // prefixIcon: const Icon(Icons.person_pin,color: Color(0xff323F4B),),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xffE4E7EB)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xffE4E7EB)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    ref.child(SessionController().userID.toString()).update({
                      'phone': phoneController.text.toString()
                    }).then((value) => {phoneController.clear()});
                    Navigator.pop(context);
                  },
                  child:
                      Text('Ok', style: Theme.of(context).textTheme.subtitle2)),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2!
                        .copyWith(color: ThemeColor1),
                  ))
            ],
          );
        });
  }
}
