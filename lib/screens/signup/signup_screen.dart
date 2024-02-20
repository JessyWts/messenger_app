import 'package:flutter/material.dart';
import 'package:messenger_app/components/background.dart';
import 'package:messenger_app/constant.dart';
import 'package:messenger_app/responsive.dart';
import 'package:messenger_app/screens/Signup/components/signup_form.dart';
import 'package:messenger_app/screens/signup/components/sign_up_top_image.dart';
import 'package:messenger_app/screens/signup/components/socal_sign_up.dart';



class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
        child: Responsive(
          mobile: const MobileSignupScreen(),
          desktop: Row(
            children: [
              const Expanded(
                child: SignUpScreenTopImage(),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 450,
                      child: SignUpForm(),
                    ),
                    const SizedBox(height: defaultPadding / 2),
                    const SocalSignUp()
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MobileSignupScreen extends StatelessWidget {
  const MobileSignupScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const SignUpScreenTopImage(),
        Row(
          children: [
            const Spacer(),
            Expanded(
              flex: 8,
              child: SignUpForm(),
            ),
            const Spacer(),
          ],
        ),
        const SocalSignUp()
      ],
    );
  }
}
