import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:repit_app/data_classes/user.dart';
import 'package:repit_app/pages/login_page.dart';
import 'package:repit_app/pages/main_page.dart';
import 'package:repit_app/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? storedToken;
User? userData;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await getUserData();
  runApp(const MainApp());
}

Future<void> getUserData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  storedToken = prefs.getString('token');
  userData = (storedToken != null)
      ? await Services.getUserData(storedToken.toString())
      : null;
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Color(0xff006e70)),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColorLight: const Color(0xff00ABB3),
          primaryColorDark: const Color(0xff006e70),
          textTheme:
              GoogleFonts.plusJakartaSansTextTheme(Theme.of(context).textTheme),
          primaryColor: const Color(0xff00ABB3),
          appBarTheme: const AppBarTheme(
            iconTheme: IconThemeData(color: Colors.white),
            color: Color(0xff00ABB3),
          ),
          buttonTheme: const ButtonThemeData(
            buttonColor: Color(0xff00ABB3),
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Color(0xff00ABB3),
          )),
      // home: SafeArea(
      //   child: LoginPage(),
      //
      // ),
      home: (userData != null) ? MainPage(userData: userData!) : LoginPage(),
    );
  }
}
