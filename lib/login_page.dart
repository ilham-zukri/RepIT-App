import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
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
                      elevation: 7,
                      shape: const CircleBorder(),
                      child: CircleAvatar(
                        radius: 75,
                        backgroundColor: Colors.transparent,
                        child: SvgPicture.asset("assets/logos/Rlogo.svg", fit: BoxFit.contain,),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
