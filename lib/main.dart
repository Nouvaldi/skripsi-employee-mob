import 'package:employee_mobile/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/cart_viewmodel.dart';
import 'viewmodels/login_viewmodel.dart';
import 'views/home_view.dart';
import 'views/login_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => LoginViewModel()..loadUser()),
      ChangeNotifierProvider(create: (context) => CartViewModel()),
      ChangeNotifierProvider(create: (context) => ThemeProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<LoginViewModel>(
      builder: (context, authProvider, child) {
        return MaterialApp(
          title: 'Employee Mobile',
          debugShowCheckedModeBanner: false,
          theme: Provider.of<ThemeProvider>(context).themeData,
          home: authProvider.userId != null
              ? const HomePage()
              : LoginPage(),
        );
      },
    );
  }
}
