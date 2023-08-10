import 'package:expanse_manager/Utils/colors.dart';
import 'package:expanse_manager/View/bottom_nav_bar.dart';
import 'package:expanse_manager/View/home_screen.dart';
import 'package:expanse_manager/View/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:expanse_manager/Controller/Signup/signup_controller.dart';
import 'package:expanse_manager/Widgets/text_input_field.dart';
import 'package:provider/provider.dart';
import 'package:expanse_manager/Widgets/button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final userName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // backgroundColor: ThemeColor1,
      body: Container(
          // padding: EdgeInsets.symmetric(horizontal: 10),
          child: ChangeNotifierProvider(
        create: (_) => SignupController(),
        child: Consumer<SignupController>(builder: (context, provider, child) {
          return SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // SizedBox(
                  //   height: 90,
                  // ),
                  // const Text(
                  //   'Quiz App',
                  //   style: TextStyle(
                  //     fontSize: 60,
                  //     fontFamily: 'Rubik Regular',
                  //     fontWeight: FontWeight.bold,
                  //     // color: Colors.white
                  //   ),
                  // ),
                  // const SizedBox(
                  //   height: 30,
                  // ),
                  // const Text(
                  //   'Register your account',
                  //   style: TextStyle(
                  //     fontSize: 18,
                  //     fontFamily: 'Rubik Regular',
                  //     // color: Colors.white
                  //   ),
                  // ),
                  // const SizedBox(
                  //   height: 15,
                  // ),
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
                        child: Column(
                          children: [
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * .18),
                            Center(
                              child: Text(
                                'mono',
                                style: TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    color: white),
                              ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * .02),
                            Center(
                              child: Text(
                                'SignUp to Register Account!',
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: white),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    decoration: BoxDecoration(
                      color: white,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.04),
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          TextInputField(
                              myController: userName,
                              onValidator: (value) {
                                return value.isEmpty ? 'Enter UserName' : null;
                              },
                              obsecureText: false,
                              hint: 'User Name'),
                          SizedBox(
                            height: 15,
                          ),
                          TextInputField(
                            myController: emailController,
                            onValidator: (value) {
                              return value.isEmpty ? 'Enter Email' : null;
                            },
                            obsecureText: false,
                            hint: 'Email',
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextInputField(
                              myController: passwordController,
                              onValidator: (value) {
                                return value.isEmpty ? 'Enter Password' : null;
                              },
                              obsecureText: true,
                              hint: 'Password'),
                          SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          InkWell(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                provider.SignUp(
                                    userName.text,
                                    emailController.text,
                                    passwordController.text);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const BottomNavBar()));
                              }
                            },
                            child: Button(
                              title: 'SignUp',
                              loading: provider.loading,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Already have an account?",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Rubik Regular',
                                  // color: Colors.white
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginScreen()));
                                },
                                child: const Text(
                                  ' Login',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Rubik Regular',
                                    fontWeight: FontWeight.bold,
                                    // color: Colors.white,
                                  ),
                                  // color: Color(0xff6943ba)),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      )),
    );
  }
}
