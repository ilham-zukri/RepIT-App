import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:repit_app/pages/main_page.dart';
import 'package:repit_app/data_classes/user.dart';
import 'package:repit_app/services.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    User? userData;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              width: size.width,
              height: size.height / 3.5,
              decoration: const BoxDecoration(
                color: Color(0xff00ABB3),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(80),
                  bottomRight: Radius.circular(80),
                ),
              ),
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: size.height / 3.5 - 75),
                      child: Card(
                        elevation: 5,
                        shape: const CircleBorder(),
                        child: CircleAvatar(
                          radius: 75,
                          backgroundColor: Colors.transparent,
                          child: SvgPicture.asset(
                            "assets/logos/Rlogo.svg",
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                ////SUBMITION FORM////
                Container(
                  margin: const EdgeInsets.only(top: 24, right: 24, left: 24),
                  child: Column(
                    children: [
                      //// Username Field ////
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Username",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        height: 41,
                        child: TextField(
                          controller: widget.userNameController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(10),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                        ),
                      ),

                      //// Password Field ////
                      Container(
                        margin: const EdgeInsets.only(top: 14),
                        child: const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Password",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        height: 41,
                        child: TextField(
                          controller: widget.passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(10),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                        ),
                      ),

                      //// Login Button ////
                      Container(
                        margin: const EdgeInsets.only(top: 35),
                        height: 41,
                        width: size.width,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff00ABB3),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                              elevation: 5),
                          onPressed: () async {
                            try {
                              var response = await Services.login(
                                widget.userNameController.text.toString(),
                                widget.passwordController.text.toString(),
                              );
                              if (response?.token != null) {
                                userData = response;
                                if (mounted) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return MainPage(
                                            userData: userData as User);
                                      },
                                    ),
                                  );
                                }
                              }
                            } catch (e) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: const Color(0xff3C4048),
                                    content: Text(
                                      e.toString(),
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  ),
                                );
                              }
                            }
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 12),
                        child: RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              const TextSpan(
                                text: "Belum memiliki akun? ",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12),
                              ),
                              TextSpan(
                                  text: "Hubungi Administrator",
                                  style: const TextStyle(
                                      color: Color(0xff00C2FF), fontSize: 12),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {})
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: size.height,
              width: size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: size.height / 30),
                    height: 43,
                    width: 107,
                    child: SvgPicture.asset(
                      "assets/logos/mainlogo.svg",
                      fit: BoxFit.fill,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
