import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_quotes_app/pages/homepage.dart';
import 'package:my_quotes_app/pages/loginpage.dart';
import 'package:my_quotes_app/pages/quotespage.dart';
import 'package:my_quotes_app/utils/routes.dart';
import 'package:my_quotes_app/theme/theme_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.currentTheme, 
      theme: ThemeData.light(),              
      darkTheme: ThemeData.dark(),           
      initialRoute: MyRoutes.loginRoute,
      routes: {
        "/": (context) => const LoginPage(),
        MyRoutes.homeRoute: (context) => const Homepage(),
        MyRoutes.loginRoute: (context) => const LoginPage(),
        MyRoutes.myquotesRoute: (context) => const QuotesPage(),
      },
    );
  }
}
