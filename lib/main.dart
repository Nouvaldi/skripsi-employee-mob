import 'package:employee_mobile/models/shop_model.dart';
import 'package:employee_mobile/pages/item_list_page.dart';
import 'package:employee_mobile/pages/login_page.dart';
import 'package:employee_mobile/pages/settings_page.dart';
import 'package:employee_mobile/themes/dark_mode.dart';
import 'package:employee_mobile/themes/light_mode.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/intro_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => Shop(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
      theme: lightMode,
      darkTheme: darkMode,
      routes: {
        '/login_page': (context) => const LoginPage(),
        '/intro_page': (context) => const IntroPage(),
        '/settings_page': (context) => const SettingsPage(),
        '/item_list_page': (context) => const ItemListPage(),
      },
    );
  }
}
