import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'pages/signUp_page.dart';
import 'package:provider/provider.dart';
import './provider/auth_provider.dart';
import 'pages/admin_view.dart';
import 'globals.dart' as globals;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: AuthProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MoiVoice',
        theme: ThemeData(
          scaffoldBackgroundColor: globals.backgroundColor,
          // This is the theme of your application.
          //
          primarySwatch: Colors.grey,
        ),
        routes: {
          '/home': (context) => const MyHomePage(title: ' MoiVoice'),
          '/': (context) => const LoginPage(),
          '/signUp': (context) => const SignUpPage(),
          '/adminHome': (context) =>
              const AdminHomePage(title: 'MoiVoice-AdminView'),
        },
      ),
    );
  }
}
