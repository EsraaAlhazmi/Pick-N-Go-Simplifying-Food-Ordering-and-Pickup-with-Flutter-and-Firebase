import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:pickapp/components/primary_button.dart';
import 'package:pickapp/components/text_form_field_border.dart';
import 'package:pickapp/constants/color.dart';
import 'package:pickapp/models/users.dart';
import 'package:pickapp/services/cutomer_service.dart';

import '../components/secondary_button.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final formkey = GlobalKey<FormState>();
  bool inAsyncCall = false;

  //Controler
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final phone = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  signIn() {
    Navigator.pushReplacementNamed(context, "login");
  }

  Future<void> signup() async {
    String? message;

    if (formkey.currentState!.validate()) {
      setState(() {
        inAsyncCall = true;
      });
      try {
        CustomerService customerService = CustomerService();
        var resultSignUp =
            await customerService.signUp(email.text, password.text);
        await CustomerService().addCUstomer(Users(
            userID: customerService.getCurrentUser()?.uid,
            name: "${firstName.text} ${lastName.text}",
            phone: phone.text,
            role: "Customer"));

        firstName.text = "";
        lastName.text = "";
        phone.text = "";
        email.text = "";
        password.text = "";
        confirmPassword.text = "";

        setState(() {
          inAsyncCall = false;
        });
        if (resultSignUp != null) {
          setState(() {
            inAsyncCall = false;
          });
          // ignore: use_build_context_synchronously
          AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            animType: AnimType.scale,
            title: 'Success',
            desc: 'Success Sign up',
            btnOkOnPress: () {},
          ).show();
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          inAsyncCall = false;
        });
        switch (e.code) {
          case 'weak-password':
            message = "Weak Password";
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
          default:
        }
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.scale,
          title: 'Error',
          desc: message,
          btnOkOnPress: () {},
        ).show();
      } catch (e) {
        message = e.toString();
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
  }

  @override
  void dispose() {
    firstName.dispose();
    lastName.dispose();
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: inAsyncCall,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              autovalidateMode: AutovalidateMode.always,
              key: formkey,
              child: ListView(
                children: [
                  const Center(
                    child: CircleAvatar(
                      radius: 100,
                      backgroundImage: AssetImage("images/logo.png"),
                    ),
                  ),
                  const Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      Expanded(
                        child: PrimaryButton(
                            child: const Text("Customer"), onPressed: () {}),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SecondaryButton(
                            child: const Text("Food Profider"),
                            onPressed: () => Navigator.pushReplacementNamed(
                                context, 'signupfoodprovider')),
                      ),
                    ],
                  ),
                  TextFormFildeBorder(
                    label: const Text("First Name"),
                    controller: firstName,
                    prefixIcon: const Icon(Icons.person),
                    validator: (value) {
                      if (value != null) {
                        if (value.length < 4) {
                          return "First name must be more than 3 letters ";
                        }
                      }
                      return null;
                    },
                  ),
                  TextFormFildeBorder(
                      label: const Text("Last Name"),
                      controller: lastName,
                      prefixIcon: const Icon(Icons.person),
                      validator: (value) {
                        if (value != null) {
                          if (value.length < 4) {
                            return "Last name must be more than 3 letters ";
                          }
                        }
                        return null;
                      }),
                  TextFormFildeBorder(
                      label: const Text("Phone"),
                      controller: phone,
                      prefixIcon: const Icon(Icons.mobile_friendly),
                      validator: (value) {
                        if (value != null) {
                          if (value.length < 10) {
                            return "Mobile Number must be 10 digit  ";
                          }
                        }
                        return null;
                      }),
                  TextFormFildeBorder(
                    label: const Text("Email"),
                    controller: email,
                    prefixIcon: const Icon(Icons.email),
                    validator: (value) {
                      if (value != null) {
                        if (!EmailValidator.validate(value)) {
                          return "Email not valid";
                        }
                      }
                      return null;
                    },
                  ),
                  TextFormFildeBorder(
                    label: const Text("Password"),
                    controller: password,
                    isPassword: true,
                    prefixIcon: const Icon(Icons.lock),
                  ),
                  TextFormFildeBorder(
                    label: const Text("Confirm Password"),
                    controller: confirmPassword,
                    isPassword: true,
                    prefixIcon: const Icon(Icons.lock_open_outlined),
                    validator: (value) {
                      if (value != password.text) {
                        return "Confirm Password not match Password";
                      }
                      return null;
                    },
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: PrimaryButton(
                          onPressed: signup,
                          child: const Text("Sign Up"),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: PrimaryButton(
                          onPressed: signIn,
                          child: const Text("Sign In"),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
