import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:repit_app/asset_card.dart';
import 'package:repit_app/data_classes/user.dart';
import 'package:repit_app/pages/login_page.dart';
import 'package:repit_app/services.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.userData});

  final User userData;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          width: 83,
          height: 33,
          child: SvgPicture.asset(
            "assets/logos/mainlogo_white.svg",
            fit: BoxFit.contain,
          ),
        ),
        titleSpacing: 0,
        actions: [
          Container(
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.account_circle,
                    size: 32,
                  ),
                  padding: EdgeInsets.zero,
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications, size: 32),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
          // IconButton(
          //   onPressed: () {},
          //   icon: const Icon(Icons.more_vert, size: 24),
          // ),
        ],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Theme(
            data: ThemeData(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent),
            child: TabBar(
              tabs: const [
                Tab(
                  icon: Icon(Icons.qr_code),
                ),
                Tab(
                  text: "Assets",
                ),
                Tab(
                  text: "Tickets",
                ),
              ],
              labelStyle: const TextStyle(fontWeight: FontWeight.w600),
              indicatorColor: const Color(0xff007980),
              indicatorSize: TabBarIndicatorSize.label,
              controller: _tabController,
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          const Center(
            child: Text('this is QR Scanner'),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Aset-aset anda akan tampil disini",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                      'Setelah asset ditambahkan, maka daftar asset yang anda miliki akan muncul disini',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "Tiket-tiket anda akan tampil disini",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 50, right: 50),
                  child: Text(
                      'Setelah tiket dibuat, maka daftar tiket yang anda miliki akan muncul disini',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: const Color(0xff00ABB3),
              content: Text(
                Services.prefs.getString('token').toString(),
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        },
        child: Transform.scale(
          scale: 2.5,
          child: const Icon(Icons.add),
        ),
      ),
      drawer: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height:
                  const Size.fromHeight(kToolbarHeight + kTextTabBarHeight + 24)
                      .height,
              width: size.width,
              decoration: const BoxDecoration(color: Color(0xff00ABB3)),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(left: 24),
                  width: 83,
                  height: 33,
                  child: SvgPicture.asset(
                    "assets/logos/mainlogo_white.svg",
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 32),
              child: Material(
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    margin: const EdgeInsets.only(left: 24),
                    width: size.width,
                    height: 33,
                    child: Row(
                      children: const [
                        Icon(
                          CupertinoIcons.cube_box,
                          size: 32,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          'Manage Assets',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Material(
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    margin: const EdgeInsets.only(left: 24),
                    width: size.width,
                    height: 33,
                    child: Row(
                      children: const [
                        Icon(
                          CupertinoIcons.person_2_square_stack,
                          size: 32,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          'Manage Users',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Material(
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    margin: const EdgeInsets.only(left: 24),
                    width: size.width,
                    height: 33,
                    child: Row(
                      children: const [
                        Icon(
                          CupertinoIcons.tickets,
                          size: 32,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          'Manage Tickets',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Material(
                child: InkWell(
                  onTap: () async{
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    String? token = prefs.getString('token').toString();
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: const Color(0xff00ABB3),
                          content: Text(
                            token.toString(),
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      );
                    }

                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 24),
                    width: size.width,
                    height: 33,
                    child: Row(
                      children: const [
                        Icon(
                          CupertinoIcons.creditcard_fill,
                          size: 32,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          'Purchasing',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: size.height / 2.2),
              child: Material(
                child: InkWell(
                  onTap: () async {
                    try {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      String? token = prefs.getString('token').toString();
                      bool response = await Services.logout(token);
                      if (response) {
                        if (mounted) {
                          prefs.clear();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          );
                        }
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: const Color(0xff00ABB3),
                            content: Text(
                              e.toString(),
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        );
                      }
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 24),
                    width: size.width,
                    height: 33,
                    child: Row(
                      children: const [
                        Icon(
                          Icons.exit_to_app,
                          size: 32,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          'Log Out',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 24, top: 24),
              child: const Text(
                'V.01.00.05',
                textAlign: TextAlign.start,
              ),
            )
          ],
        ),
      ),
    );
  }
}
