import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:pickapp/components/primary_button.dart';
import 'package:pickapp/components/text_form_field_border.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/enum.dart';
import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();

  final email = TextEditingController();
  final password = TextEditingController();
  bool inAsyncCall = false;

  Future<void> login() async {
    setState(() {
      inAsyncCall = true;
    });
    String? message;
    final formdate = formKey.currentState;
    if (formdate!.validate()) {
      try {
        var result = await AuthService().signIn(email.text, password.text);

        final sharedPref = await SharedPreferences.getInstance();
        var fullname = await AuthService().getUserName();
        sharedPref.setString("fullanme", fullname ?? "");
        sharedPref.setString("email", AuthService().getUserEmail());

        if (result != null) {
          if (await AuthService().getUserType() == AcountType.Customer.name) {
            if (!mounted) return;
            await Navigator.pushReplacementNamed(context, "listProvider");
          } else if (await AuthService().getUserType() ==
              AcountType.ProviderFood.name) {
            if (!mounted) return;
            await Navigator.pushReplacementNamed(context, "providerProfile");
          }
        }
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case 'wrong-password':
            message = "Wrong Password";
            break;
          case 'email-already-in-use':
            message = "Email already in use";
            break;
          case 'invalid-email':
            message = "Invalid Email";
            break;
          case 'operation-not-allowed':
            message = "Operation Not Allowed";
            break;
          case 'user-not-found':
            message = "Email not used";
            break;
          default:
            message = e.message;
        }
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.scale,
          title: 'Error',
          desc: message,
          btnOkOnPress: () {},
        ).show();
      }
    }
    if (mounted) {
      setState(() {
        inAsyncCall = false;
      });
    }
  }

  void goToSignup() async {
    await Navigator.pushReplacementNamed(context, 'signup');
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        color: Colors.black,
        opacity: .7,
        inAsyncCall: inAsyncCall,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage("images/background.jpg"),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 150),
              child: ListView(
                children: [
                  const Center(
                    child: CircleAvatar(
                      radius: 100,
                      backgroundImage: AssetImage("images/logo.png"),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Form(
                      key: formKey,
                      child: Column(
                        children: [
                          TextFormFildeBorder(
                            hintText: "Email",
                            controller: email,
                          ),
                          TextFormFildeBorder(
                            controller: password,
                            isPassword: true,
                            hintText: "Password",
                          ),
                          const SizedBox(height: 10),
                          const SizedBox(height: 10),
                          PrimaryButton(
                              onPressed: login, child: const Text("Login")),
                          const SizedBox(
                            height: 20,
                          ),
                          TextButton(
                            onPressed: goToSignup,
                            child: const Text('Dont have Account?',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
