import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:pickapp/models/users.dart';
import 'package:pickapp/services/google_map_service.dart';
import 'package:pickapp/services/provider_food_service.dart';
import '../components/primary_button.dart';
import '../components/secondary_button.dart';
import '../components/text_form_field_border.dart';
import '../constants/color.dart';
import '../models/enum.dart';

class SignUpFoodProviderPage extends StatefulWidget {
  const SignUpFoodProviderPage({super.key});

  @override
  State<SignUpFoodProviderPage> createState() => _SignUpFoodProviderPageState();
}

class _SignUpFoodProviderPageState extends State<SignUpFoodProviderPage> {
  final formkey = GlobalKey<FormState>();
  bool inAsyncCall = false;
  final imagePicker = ImagePicker();
  String providerType = ProviderType.Restaurant.name.toString();

  //Controler
  final providerName = TextEditingController();
  final description = TextEditingController();
  final location = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  Position? currentPosition;
  String? currentAddress;
  bool isLoading = false;

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
        ProviderFoodService providerFoodService = ProviderFoodService();
        Position position = await GoogleMapService.getPosition();
        var resultSignUp =
            await providerFoodService.signUp(email.text, password.text);
        await providerFoodService.addProviderFood(Users(
          userID: providerFoodService.getCurrentUser()?.uid,
          name: providerName.text,
          phone: phone.text,
          description: description.text,
          latitude: position.latitude,
          longitude: position.longitude,
          providerType: providerType,
        ));

        providerName.text = "";
        description.text = "";
        email.text = "";
        phone.text = "";
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
  void initState() {
    super.initState();
    GoogleMapService.getAddress().then((value) {
      setState(() {
        currentAddress = value;
      });
    });
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
                        child: SecondaryButton(
                            child: const Text("Customer"),
                            onPressed: () => Navigator.pushReplacementNamed(
                                context, 'signup')),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: PrimaryButton(
                            child: const Text("Food Profider"),
                            onPressed: () {}),
                      ),
                    ],
                  ),
                  TextFormFildeBorder(
                    label: const Text("Restaurant / Coffee Name"),
                    controller: providerName,
                    prefixIcon: const Icon(Icons.restaurant),
                    validator: (value) {
                      if (value != null) {
                        if (value.length < 4) {
                          return "The name must be more than 3 letters ";
                        }
                      }
                      return null;
                    },
                  ),
                  TextFormFildeBorder(
                    label: const Text("Description"),
                    controller: description,
                    prefixIcon: const Icon(Icons.description),
                  ),
                  const Text(
                    "Address",
                    style: TextStyle(fontSize: 18, color: kPrimaryColor),
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: currentAddress == null
                            ? const Text("Loading Location..")
                            : Text(currentAddress!),
                      ),
                      GestureDetector(
                        onTap: () async {
                          await GoogleMapService.getAddress();
                        },
                        child: Icon(
                          Icons.refresh,
                          color: Colors.red[400],
                        ),
                      )
                    ],
                  ),
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
                    label: const Text("Phone"),
                    controller: phone,
                    prefixIcon: const Icon(Icons.mobile_friendly),
                    validator: (value) {
                      if (value != null) {
                        if (value.length < 10) {
                          return "The phone must be 10 digit ";
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
                      if (value != null) {
                        if (value != password.text) {
                          return "Confirm Password not match Password";
                        }
                      }
                      return null;
                    },
                  ),
                  const Text(
                    "Provider Type",
                    style: TextStyle(fontSize: 18, color: kPrimaryColor),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile(
                            activeColor: kPrimaryColor,
                            title:
                                Text(ProviderType.Restaurant.name.toString()),
                            value: ProviderType.Restaurant.name,
                            groupValue: providerType,
                            onChanged: (val) {
                              setState(() => providerType = val!);
                            }),
                      ),
                      Expanded(
                        child: RadioListTile(
                            activeColor: kPrimaryColor,
                            title: Text(ProviderType.Cafe.name.toString()),
                            value: ProviderType.Cafe.name,
                            groupValue: providerType,
                            onChanged: (val) {
                              setState(() => providerType = val!);
                            }),
                      ),
                    ],
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
