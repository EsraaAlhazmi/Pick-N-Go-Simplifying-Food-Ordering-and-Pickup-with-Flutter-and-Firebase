import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:pickapp/components/provider_app_bar.dart';
import 'package:pickapp/components/provider_custom_sidebar.dart';
import 'package:pickapp/services/auth_service.dart';
import 'package:pickapp/services/item_service.dart';

import '../components/primary_button.dart';
import '../components/text_form_field_border.dart';
import '../models/item.dart';

class AddItemPage extends StatefulWidget {
  const AddItemPage({super.key});

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final formkey = GlobalKey<FormState>();
  bool inAsyncCall = false;

  final name = TextEditingController();
  final price = TextEditingController();
  final description = TextEditingController();
  Future<void> onSave() async {
    if (formkey.currentState!.validate()) {
      setState(() {
        inAsyncCall = true;
      });
      var result = await ItemService().addItem(Item(
          name: name.text,
          description: description.text,
          price: num.parse(price.text),
          providerID: AuthService().getCurrentUser()!.uid));
      name.text = "";
      price.text = "";
      description.text = "";
      if (result != true) {
        setState(() {
          inAsyncCall = false;
        });
        // ignore: use_build_context_synchronously
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.scale,
          title: 'Success',
          desc: 'Success Add Item',
          btnOkOnPress: () {},
        ).show();
      }
      setState(() {
        inAsyncCall = false;
      });
    }
  }

  @override
  void dispose() {
    name.dispose();
    price.dispose();
    description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const ProviderSideBar(),
      appBar: const ProviderAppBar(title: "Add Item"),
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
                  TextFormFildeBorder(
                    label: const Text("Item Name"),
                    controller: name,
                    validator: (value) {
                      if (value != null) {
                        if (value.length < 4) {
                          return "Item name must be more than 3 letters ";
                        }
                      }
                      return null;
                    },
                  ),
                  TextFormFildeBorder(
                      label: const Text("Price"),
                      controller: price,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        return null;
                      }),
                  TextFormFildeBorder(
                    label: const Text("Description"),
                    controller: description,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: PrimaryButton(
                          onPressed: onSave,
                          child: const Text("Save"),
                        ),
                      ),
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
