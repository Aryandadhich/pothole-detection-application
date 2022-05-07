import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:potholefinder/screens/admin_user_home_screen.dart';

import '../resources/auth_methods.dart';
import '../utlis/colors.dart';
import '../utlis/global_variables.dart';
import '../utlis/utils.dart';
import '../widegts/text_field_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(
        email: _emailController.text, password: _passwordController.text);
    if (res == 'success') {
      //Move to homescreen
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const AdminHomeScreen(),
          ),
          (route) => false);
      setState(() {
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      showSnackBar(res, context);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: MediaQuery.of(context).size.width > webScreenSize
            ? EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 3)
            : const EdgeInsets.symmetric(horizontal: 32),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(child: Container(), flex: 2),
            //SVG image
            SvgPicture.asset(
              "assets/login_auth.svg",
              height: 200,
            ),
            const SizedBox(height: 34),
            const Text(
              "Municipal Auth",
              style: TextStyle(
                color: primaryMainColor,
                fontSize: 28,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 34),
            //Text filed input for email
            TextFieldInput(
                textEditingController: _emailController,
                hintText: "Enter your email",
                textInputType: TextInputType.emailAddress),
            //Text filed input for password
            const SizedBox(height: 24),

            TextFieldInput(
              textEditingController: _passwordController,
              hintText: "Enter your password",
              textInputType: TextInputType.text,
              isPass: true,
            ),
            const SizedBox(height: 24),
            //Button Login
            InkWell(
              onTap: () => loginUser(),
              child: Container(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      )
                    : const Text(
                        "Login",
                        style: TextStyle(color: primaryColor),
                      ),
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: const ShapeDecoration(
                  color: primaryMainColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Flexible(child: Container(), flex: 2),
            // //Transitioning to Signing Up
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Container(
            //       child: const Text("Don't have an account?"),
            //       padding: const EdgeInsets.symmetric(vertical: 8),
            //     ),
            //     GestureDetector(
            //       onTap: () {},
            //       child: Container(
            //         child: const Text(
            //           " Sign up.",
            //           style: TextStyle(fontWeight: FontWeight.bold),
            //         ),
            //         padding: const EdgeInsets.symmetric(vertical: 8),
            //       ),
            //     )
            //   ],
            // ),
            // const SizedBox(height: 12),
          ],
        ),
      )),
    );
  }
}
