import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:pickapp/components/provider_app_bar.dart';
import 'package:pickapp/components/provider_custom_sidebar.dart';
import 'package:pickapp/services/auth_service.dart';
import 'package:pickapp/services/provider_food_service.dart';
import '../components/primary_button.dart';
import '../components/text_form_field_border.dart';
import '../constants/color.dart';
import '../constants/table.dart';
import '../models/enum.dart';
import '../models/users.dart';
import '../services/google_map_service.dart';

class ProviderProfilePage extends StatefulWidget {
  const ProviderProfilePage({super.key});

  @override
  State<ProviderProfilePage> createState() => _ProviderProfilePageState();
}

class _ProviderProfilePageState extends State<ProviderProfilePage> {
  List profile = [];
  final formkey = GlobalKey<FormState>();
  bool inAsyncCall = false;
  String providerType = ProviderType.Restaurant.name.toString();
  String? photo;
  //Controler
  final providerName = TextEditingController();
  final description = TextEditingController();
  final phone = TextEditingController();

  Position? currentPosition;
  Position? position;
  String? currentAddress;
  bool isLoading = false;

  updatePhoto() async {
    setState(() {
      inAsyncCall = true;
    });
    await ProviderFoodService().updateProviderPhoto().then((value) {
      if (value) {
        setState(() {
          fetchData();
        });
      }
    });
    setState(() {
      inAsyncCall = false;
    });
  }

  Future<void> save() async {
    String? message;
    if (formkey.currentState!.validate()) {
      setState(() {
        inAsyncCall = true;
      });
      try {
        ProviderFoodService providerFoodService = ProviderFoodService();

        var resultSignUp = await providerFoodService.updateProvider(Users(
          userID: AuthService().getCurrentUser()?.uid,
          name: providerName.text,
          phone: phone.text,
          description: description.text,
        ));

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
            desc: 'Update Profile',
            btnOkOnPress: () {},
          ).show();
        }
      } catch (e) {
        message = e.toString();
        setState(() {
          inAsyncCall = false;
        });
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
    fetchData();
    super.initState();
  }

  fetchData() async {
    inAsyncCall = true;
    var result = await ProviderFoodService()
        .getProviderProfile(AuthService().getCurrentUser()?.uid);
    if (result != null) {
      inAsyncCall = true;
      setState(() {
        profile = result;
        providerName.text = profile[0]['name'];
        phone.text = profile[0]['phone'];
        description.text = profile[0]['description'];
        photo = profile[0]['photo'];

        GoogleMapService.displayAddress(profile[0][kColumnUserLatitude],
                profile[0][kColumnUserLongitude])
            .then((value) {
          setState(() {
            currentAddress = value;
          });
        });
      });
      inAsyncCall = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const ProviderSideBar(),
        appBar: const ProviderAppBar(
          title: 'Profile',
        ),
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
                    photo == null
                        ? Image.asset(
                            "images/provider.jpg",
                            fit: BoxFit.cover,
                          )
                        : Image.network(photo.toString()),
                    const SizedBox(height: 10),
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
                            GoogleMapService.getAddress().then((value) {
                              setState(() {
                                currentAddress = null;
                                currentAddress = value;
                              });
                            });

                            position = await GoogleMapService.getPosition();

                            ProviderFoodService().updateProviderLocation(Users(
                              userID: AuthService().getCurrentUser()!.uid,
                              latitude: position!.latitude,
                              longitude: position!.longitude,
                            ));

                            GoogleMapService.getAddress().then((value) {
                              setState(() {
                                currentAddress = null;
                                currentAddress = value;
                              });
                            });
                          },
                          child: Icon(
                            Icons.refresh,
                            color: Colors.red[400],
                          ),
                        )
                      ],
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
                    PrimaryButton(
                      onPressed: updatePhoto,
                      child: const Icon(Icons.image),
                    ),
                    const SizedBox(height: 10),
                    PrimaryButton(
                      onPressed: save,
                      child: const Text("Save"),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
