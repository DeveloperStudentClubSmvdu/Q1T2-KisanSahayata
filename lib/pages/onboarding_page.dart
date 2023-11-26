import 'dart:ui';
import 'package:agriplant/chatgpt/chatgpt.dart';

import 'package:agriplant/pages/home_page.dart';
import 'package:agriplant/pages/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_sign_in/google_sign_in.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              const Spacer(),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 380),
                child: Image.asset('assets/onboarding.png'),
              ),
              const Spacer(),
              Text('Welcome to Kisan sahayata',
                  style: Theme.of(context).textTheme.headline4?.copyWith(fontWeight: FontWeight.bold)),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Text(
                  "Get your agriculture information here. You're just a few clicks away.",
                  textAlign: TextAlign.center,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => signInWithGoogle(context),
                icon: const Icon(IconlyLight.login),
                label: const Text("Continue with Google"),
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // 30
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      print(userCredential.user?.displayName);

      if (userCredential.user != null) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomePage()));
      }
    } catch (e) {
      print('Sign-in Error: $e');
    }
  }
}
