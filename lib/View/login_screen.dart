import 'package:expanse_manager/Utils/colors.dart';
import 'package:expanse_manager/View/bottom_nav_bar.dart';
import 'package:expanse_manager/View/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:expanse_manager/Controller/Login/login_controller.dart';
import 'package:expanse_manager/Widgets/text_input_field.dart';
import 'package:provider/provider.dart';
import 'package:expanse_manager/Widgets/button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  LoginController status = LoginController();

  @override
  Widget build(BuildContext context) {
    // final themeChanger=Provider.of<ThemeChanger>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: null,
      // backgroundColor: ThemeColor1,
      body: Container(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                      child: Column(
                        children: [
                          SizedBox(
                              height: MediaQuery.of(context).size.height * .18),
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
                              height: MediaQuery.of(context).size.height * .02),
                          Center(
                            child: Text(
                              'Login to Your Account!',
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
                          height: MediaQuery.of(context).size.height * 0.05,
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
                          height: MediaQuery.of(context).size.height * 0.03,
                        ),
                        TextInputField(
                            myController: passwordController,
                            onValidator: (value) {
                              return value.isEmpty ? 'Enter Password' : null;
                            },
                            obsecureText: true,
                            hint: 'Password'),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.025,
                        ),
                        const Align(
                          alignment: Alignment.centerRight,
                          child: Text('Forget Password',
                              style: TextStyle(
                                fontSize: 16,
                                decoration: TextDecoration.underline,
                                // color: neutral
                              )),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                        ChangeNotifierProvider(
                          create: (_) => LoginController(),
                          child: Consumer<LoginController>(
                              builder: (context, provider, child) {
                            return InkWell(
                                onTap: () {
                                  if (_formKey.currentState!.validate()) {
                                    provider.Login(emailController.text,
                                        passwordController.text);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const BottomNavBar()));
                                  }
                                },
                                child: const Button(title: 'LogIn'));
                          }),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account?",
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
                                        builder: (context) =>
                                            const SignupScreen()));
                              },
                              child: const Text(
                                ' Signup',
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
