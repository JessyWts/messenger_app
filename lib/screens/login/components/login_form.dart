import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messenger_app/components/already_have_an_account_acheck.dart';
import 'package:messenger_app/constant.dart';
import 'package:messenger_app/screens/signup/signup_screen.dart';

FirebaseAuth firebaseAuth = FirebaseAuth.instance;

class LoginForm extends StatelessWidget {
  final TextEditingController emailField = TextEditingController();
  final TextEditingController pwdField = TextEditingController();

  LoginForm({
    Key? key,
  }) : super(key: key);

  Future<void> login() async {
    try {
      if (emailField.text.isNotEmpty && pwdField.text.isNotEmpty) {
        firebaseAuth.signInWithEmailAndPassword(
          email: emailField.text.trim(), 
          password: pwdField.text.trim()
        ).then((value) =>  debugPrint('connecté'));
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            controller: emailField,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            onSaved: (email) {},
            decoration: const InputDecoration(
              hintText: "Your email",
              prefixIcon: Padding(
                padding:  EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              controller: pwdField,
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: kPrimaryColor,
              decoration: const InputDecoration(
                hintText: "Your password",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          Hero(
            tag: "login_btn",
            child: ElevatedButton(
              onPressed: () => login(),
              child: Text(
                "Login".toUpperCase(),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const SignUpScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
