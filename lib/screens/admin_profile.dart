import 'package:flutter/material.dart';
import 'package:pickapp/components/primary_button.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminProfilePage extends StatefulWidget {
  const AdminProfilePage({super.key});

  @override
  State<AdminProfilePage> createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
  final Uri _url = Uri.parse(
      'https://console.firebase.google.com/u/0/project/pickapp-7146a/firestore');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: PrimaryButton(
            onPressed: () {
              launchUrl(_url);
            },
            child: const Text("Go Database")),
      ),
    ));
  }
}
