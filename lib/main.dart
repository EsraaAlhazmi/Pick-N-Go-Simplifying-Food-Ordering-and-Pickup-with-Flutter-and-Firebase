import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pickapp/constants/color.dart';
import 'package:pickapp/screens/add_item.dart';
import 'package:pickapp/screens/cart.dart';
import 'package:pickapp/screens/customer_profile.dart';
import 'package:pickapp/screens/list_item.dart';
import 'package:pickapp/screens/list_provider.dart';
import 'package:pickapp/screens/login.dart';
import 'package:pickapp/screens/my_order.dart';
import 'package:pickapp/screens/my_order_details.dart';
import 'package:pickapp/screens/order.dart';
import 'package:pickapp/screens/order_details.dart';
import 'package:pickapp/screens/provider_profile.dart';
import 'package:pickapp/screens/signup.dart';
import 'package:pickapp/screens/signup_food_provider.dart';
import 'package:pickapp/services/cart_service.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Cart>(
        create: (context) => Cart(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'PICK N Go',
          theme: ThemeData.light().copyWith(
              scaffoldBackgroundColor: kBackground,
              appBarTheme: const AppBarTheme(backgroundColor: kPrimaryColor)),
          home: const LoginPage(),
          routes: {
            "home": (context) => const ListProverPage(),
            "login": (context) => const LoginPage(),
            "signup": (context) => const SignupPage(),
            "cutomerProfile": (context) => const CustomerProfilePage(),
            "providerProfile": (context) => const ProviderProfilePage(),
            "signupfoodprovider": (context) => const SignUpFoodProviderPage(),
            "addItem": (context) => const AddItemPage(),
            "order": (context) => const OrderPage(),
            "orderDetails": (context) => const OrderDetailsPage(),
            "listProvider": (context) => const ListProverPage(),
            "cart": (context) => const CartPage(),
            "customerOrders": (context) => const OrderPage(),
            "myOrders": (context) => const MyOrders(),
            "myOrdersDetail": (context) => const MyOrderDetails(),
            "listItem": (context) => const ListItemPage(),
          },
        ));
  }
}
