import 'package:flutter/material.dart';
import 'package:flutter_demo_restaurant/pages/cartfood.dart';
import 'package:flutter_demo_restaurant/pages/home.dart';
import 'package:flutter_demo_restaurant/pages/login.dart';
import 'package:flutter_demo_restaurant/pages/paycart.dart';
import 'package:flutter_demo_restaurant/pages/register.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo Restaurant',
      initialRoute: 'login',
      routes: {
        'login': (context) => const LoginViewSet(),
        'register': (context) => const RegisterViewSet(),
        'home': (context) => const HomeViewSet(),
        'cart':(context) => const Cartfood(),
        'paycart':(context) => const Paycart(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}