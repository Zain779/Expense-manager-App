import 'package:expanse_manager/Services/session_manager.dart';
import 'package:expanse_manager/Utils/colors.dart';
import 'package:expanse_manager/Utils/utils.dart';
import 'package:expanse_manager/View/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:expanse_manager/Controller/Profile/profile_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // final ref= FirebaseDatabase.instance.ref('Data');
  DatabaseReference ref = FirebaseDatabase.instance.ref().child('User');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    return Scaffold(
        backgroundColor: white,
        resizeToAvoidBottomInset: false,
        body: ChangeNotifierProvider(
          create: (_) => ProfileController(),
          child:
              Consumer<ProfileController>(builder: (context, provider, child) {
            return Column(
              children: [
                Stack(
                  children: [
                    Container(
                      child: Image.asset(
                        'assets/designs/images/rectangle-9-YCZ.png',
                        height: MediaQuery.of(context).size.height * .42,
                        width: MediaQuery.of(context).size.width * 1,
                      ),
                    ),
                    Container(
                        child: Row(
                      children: [
                        Image.asset(
                          'assets/designs/images/ellipse-8.png',
                          height: MediaQuery.of(context).size.height * .25,
                          width: MediaQuery.of(context).size.width * .25,
                        ),
                        Image.asset(
                          'assets/designs/images/ellipse-7.png',
                          height: MediaQuery.of(context).size.height * .15,
                          width: MediaQuery.of(context).size.width * .15,
                        ),
                        Image.asset(
                          'assets/designs/images/ellipse-7.png',
                          height: MediaQuery.of(context).size.height * .15,
                          width: MediaQuery.of(context).size.width * .15,
                        ),
                      ],
                    )),
                    Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.08),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .2,
                                ),
                              ],
                            ),
                            Container(
                                height:
                                    MediaQuery.of(context).size.height * .06,
                                width: MediaQuery.of(context).size.width * .09,
                                decoration: BoxDecoration(
                                  color: ThemeColor2,
                                  borderRadius: BorderRadius.circular(11),
                                ),
                                child: Center(
                                    child: IconButton(
                                        onPressed: () {
                                          auth.signOut().then((value) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const LoginScreen()));
                                          }).onError((error, stackTrace) {
                                            utils()
                                                .toastMessage(error.toString());
                                          });
                                        },
                                        icon: Icon(
                                          Icons.logout_sharp,
                                          color: white,
                                        ))))
                          ],
                        )),
                    Container(
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * .1,
                          ),
                          Center(
                            child: StreamBuilder(
                                stream: ref
                                    .child(
                                        SessionController().userID.toString())
                                    .onValue,
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (!snapshot.hasData) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else if (snapshot.hasData) {
                                    Map<dynamic, dynamic> map =
                                        snapshot.data.snapshot.value;
                                    return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Stack(
                                            alignment: Alignment.bottomCenter,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            .01),
                                                child: Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      .2,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      .2,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        color: white,
                                                        width: 3,
                                                      )),
                                                  child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                      child: provider.image ==
                                                              null
                                                          ? map['profile']
                                                                      .toString() ==
                                                                  ''
                                                              ? const Icon(
                                                                  Icons.person,
                                                                  size: 40,
                                                                )
                                                              : Image(
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  image:
                                                                      NetworkImage(
                                                                    map['profile']
                                                                        .toString(),
                                                                  ),
                                                                  loadingBuilder:
                                                                      (context,
                                                                          child,
                                                                          loadingProgress) {
                                                                    if (loadingProgress ==
                                                                        null)
                                                                      return child;
                                                                    return const Center(
                                                                        child:
                                                                            CircularProgressIndicator());
                                                                  },
                                                                  errorBuilder:
                                                                      (context,
                                                                          object,
                                                                          stack) {
                                                                    return Container(
                                                                      child: Icon(
                                                                          Icons
                                                                              .person,
                                                                          color:
                                                                              ThemeColor1),
                                                                    );
                                                                  },
                                                                )
                                                          : Image.file(File(
                                                                  provider
                                                                      .image!
                                                                      .path)
                                                              .absolute)),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  provider.pickImage(context);
                                                },
                                                child: CircleAvatar(
                                                  radius: 14,
                                                  backgroundColor: ThemeColor1,
                                                  child: Icon(
                                                    Icons.add,
                                                    size: 18,
                                                    color: white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ]);
                                  } else {
                                    return Center(
                                        child: Text(
                                      'Something Went Wrong',
                                      style:
                                          Theme.of(context).textTheme.subtitle1,
                                    ));
                                  }
                                }),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Center(
                      child: StreamBuilder(
                          stream: ref
                              .child(SessionController().userID.toString())
                              .onValue,
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasData) {
                              Map<dynamic, dynamic> map =
                                  snapshot.data.snapshot.value;
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    height: 1,
                                  ),
                                  const SizedBox(height: 40),
                                  Divider(
                                    color: ThemeColor2.withOpacity(0.4),
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        provider.showUserNameDialogueAlert(
                                            context, map['username']);
                                      },
                                      child: ReusableRow(
                                          title: 'User Name',
                                          value: map['username'],
                                          iconData: Icons.person)),
                                  Divider(
                                    color: ThemeColor2.withOpacity(0.4),
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        provider.showPhoneDialogueAlert(
                                            context, map['phone']);
                                      },
                                      child: ReusableRow(
                                          title: 'Phone',
                                          value: map['phone'] == ''
                                              ? 'xxxx-xxxxxxx'
                                              : map['phone'],
                                          iconData: Icons.phone)),
                                  Divider(
                                    color: ThemeColor2.withOpacity(0.4),
                                  ),
                                  ReusableRow(
                                      title: 'Email',
                                      value: map['email'],
                                      iconData: Icons.mail),
                                  Divider(color: ThemeColor2),
                                ],
                              );
                            } else {
                              return Center(
                                  child: Text(
                                'Something Went Wrong',
                                style: Theme.of(context).textTheme.subtitle1,
                              ));
                            }
                          })),
                ),
              ],
            );
          }),
        ));
  }
}

class ReusableRow extends StatelessWidget {
  final String title, value;
  final IconData iconData;
  const ReusableRow(
      {Key? key,
      required this.title,
      required this.value,
      required this.iconData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(
            title,
            style: Theme.of(context).textTheme.subtitle2,
          ),
          leading: Icon(
            iconData,
            color: ThemeColor1,
          ),
          trailing: Text(
            value,
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ),
        // Divider(color: AppColors.dividedColor,),
      ],
    );
  }
}
