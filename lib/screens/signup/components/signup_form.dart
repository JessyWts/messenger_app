import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:messenger_app/constant.dart';
import 'package:messenger_app/components/already_have_an_account_acheck.dart';
import 'package:messenger_app/screens/Login/login_screen.dart';

FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

class SignUpForm extends StatelessWidget {
  final TextEditingController emailField = TextEditingController();
  final TextEditingController pwdField = TextEditingController();
  final TextEditingController pseudoField = TextEditingController();
  
  SignUpForm({
    Key? key,
  }) : super(key: key);

  Future<void>signup() async{
    try {
      if((emailField.text.isNotEmpty && pwdField.text.isNotEmpty) &&  (pwdField.text.length >= 6)) {
        _auth.createUserWithEmailAndPassword(
          email: emailField.text.trim(),
          password: pwdField.text.trim()
        ).then((UserCredential value) {
          addUser(value.user!.uid, pseudoField.text.trim());
        });
      }
    } catch (e) {
      debugPrint('signup: $e');
    }
  }

  Future<void>addUser(String userID, String pseudo, {String imageUrl = ''})async {
    try {
      return _firebaseFirestore.collection('Users')
        .doc(userID).set({
          'pseudo': pseudoField.text.trim(),
          'imageUrl': imageUrl
        }).then((value) => debugPrint('User $userID added.'));
    } catch (e) {
      debugPrint('addUser: $e');
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
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.mail),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding,),
          TextFormField(
            controller: pseudoField,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            decoration: const InputDecoration(
              hintText: "Your pseudo",
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
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
          const SizedBox(height: defaultPadding / 2),
          ElevatedButton(
            onPressed: () => signup(),
            child: Text("Sign Up".toUpperCase()),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            login: false,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const LoginScreen();
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