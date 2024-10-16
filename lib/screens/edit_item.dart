import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:pickapp/components/provider_app_bar.dart';

import '../components/primary_button.dart';
import '../components/text_form_field_border.dart';
import '../models/item.dart';
import '../services/auth_service.dart';
import '../services/item_service.dart';

class EditItemPage extends StatefulWidget {
  final String? id;

  const EditItemPage({super.key, this.id});

  @override
  State<EditItemPage> createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  @override
  void initState() {
    fetchData();
    super.initState();
  }

  List items = [];
  fetchData() async {
    var result = await ItemService().displayItemsById(widget.id);
    setState(() {
      items = result;
      name.text = items[0]['name'];
      price.text = items[0]['price'].toString();
      description.text = items[0]['description'];
    });
  }

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
      var result = await ItemService().updateItem(Item(
          itemId: widget.id,
          name: name.text,
          description: description.text,
          price: num.parse(price.text),
          providerID: AuthService().getCurrentUser()!.uid));

      setState(() {
        inAsyncCall = false;
      });
      // ignore: use_build_context_synchronously
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.scale,
        title: 'Success',
        desc: 'Success Save Edit Item',
        btnOkOnPress: () {},
      ).show();
      setState(() {
        inAsyncCall = false;
      });
      Navigator.pushReplacementNamed(context, "listItem");
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
      appBar: const ProviderAppBar(title: "Edit Item"),
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
                  const SizedBox(height: 20),
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
