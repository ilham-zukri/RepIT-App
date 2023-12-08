import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:repit_app/data_classes/user.dart';
import 'package:repit_app/pages/asset_request_form.dart';
import 'package:repit_app/pages/login_page.dart';
import 'package:repit_app/pages/manage_asset.dart';
import 'package:repit_app/pages/manage_purchase.dart';
import 'package:repit_app/pages/manage_request.dart';
import 'package:repit_app/pages/manage_spare_part.dart';
import 'package:repit_app/pages/manage_ticket.dart';
import 'package:repit_app/pages/my_assets_page.dart';
import 'package:repit_app/pages/my_request_page.dart';
import 'package:repit_app/pages/my_tickets_page.dart';
import 'package:repit_app/pages/performance.dart';
import 'package:repit_app/pages/profile_page.dart';
import 'package:repit_app/pages/qr_page.dart';
import 'package:repit_app/pages/spare_part_request_form.dart';
import 'package:repit_app/pages/ticket_form.dart';
import 'package:repit_app/services.dart';
import 'package:repit_app/widgets/alert.dart';
import 'package:repit_app/widgets/loading_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'manage_users.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key, required this.userData}) : super(key: key);

  final User userData;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  late TabController _tabController;
  late User userData;
  Color ticketIconColor = Colors.black;
  Color requestIconColor = Colors.black;

  @override
  void initState() {
    super.initState();
    userData = widget.userData;
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
    if (!kIsWeb) {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (message.notification != null) {
          showDialog(
            context: context,
            builder: (context) => alert(
              context,
              "${message.notification!.title}",
              "${message.notification!.body}",
            ),
          );
          String? messageType = message.data['type'];
          if (messageType != null) {
            setState(() {
              if (messageType == "ticket") {
                ticketIconColor = Colors.red;
              } else if (messageType == "request") {
                requestIconColor = Colors.red;
              }
            });
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = false;
    final isDialOpen = ValueNotifier<bool>(false);
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          width: 83,
          height: 33,
          child: SvgPicture.asset(
            "assets/logos/mainlogo_white.svg",
            fit: BoxFit.contain,
            allowDrawingOutsideViewBox: true,
          ),
        ),
        titleSpacing: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return ProfilePage(
                      userData: userData,
                      withAdvancedMenu: false,
                    );
                  },
                ),
              );
            },
            icon: const Icon(
              Icons.account_circle,
              size: 32,
            ),
            padding: EdgeInsets.zero,
          ),
          const SizedBox(
            width: 8,
          )
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
                  text: "Tickets",
                ),
                Tab(
                  text: "My Assets",
                ),
                Tab(
                  text: "Request",
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
      body: Stack(
        children: [
          TabBarView(
            controller: _tabController,
            children: [
              MyTicketsPage(role: userData.role),
              const MyAssetsPage(),
              MyRequestPage(role: userData.role),
            ],
          ),
          loadingOverlay(isLoading, context)
        ],
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        //icon on Floating action button
        activeIcon: Icons.close,
        //icon when menu is expanded on button
        visible: true,
        closeManually: false,
        curve: Curves.elasticInOut,
        openCloseDial: isDialOpen,
        spacing: 14,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        elevation: 8.0,
        //shadow elevation of button
        shape: const CircleBorder(),
        //shape of button
        children: [
          SpeedDialChild(
            //speed dial child
            child: const Icon(Icons.construction, color: Colors.white),
            label: 'Spare Parts',
            labelBackgroundColor: const Color(0xff00ABB3),
            backgroundColor: const Color(0xff00ABB3),
            labelStyle: const TextStyle(
                fontSize: 16.0,
                color: Colors.white,
                fontWeight: FontWeight.w600),
            onTap: () {
              if (userData.role['asset_request'] != 1) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => alert(
                        context,
                        "Tidak Berwenang",
                        "Anda tidak memiliki wewenang untuk membuat Asset Request"));
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SparePartRequestForm(),
                  ),
                );
              }
            },
          ),
          SpeedDialChild(
            //speed dial child
            child: const Icon(CupertinoIcons.cube_box, color: Colors.white),
            label: 'Asset',
            labelBackgroundColor: const Color(0xff00ABB3),
            backgroundColor: const Color(0xff00ABB3),
            labelStyle: const TextStyle(
                fontSize: 16.0,
                color: Colors.white,
                fontWeight: FontWeight.w600),
            onTap: () {
              if (userData.role['asset_request'] != 1) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => alert(
                        context,
                        "Tidak Berwenang",
                        "Anda tidak memiliki wewenang untuk membuat Asset Request"));
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AssetRequestForm()));
              }
            },
          ),
          SpeedDialChild(
            child: const Icon(CupertinoIcons.tickets, color: Colors.white),
            label: 'Ticket',
            labelBackgroundColor: const Color(0xff00ABB3),
            backgroundColor: const Color(0xff00ABB3),
            labelStyle: const TextStyle(
                fontSize: 16.0,
                color: Colors.white,
                fontWeight: FontWeight.w600),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const TicketForm()));
            },
          ),
          //add more menu item childs here
        ],
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
              margin: const EdgeInsets.only(top: 32, left: 20, right: 20),
              width: 205,
              height: 40,
              child: Material(
                child: InkWell(
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    if (userData.role['asset_management'] != 1 &&
                        userData.role['asset_request'] != 1) {
                      showDialog(
                        context: context,
                        builder: (context) => alert(context, "Tidak Berwenang",
                            "Anda tidak memiliki wewenang untuk mengakses menu ini"),
                      );
                      return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ManageAsset(),
                      ),
                    );
                  },
                  customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: Container(
                    margin: const EdgeInsets.only(
                        right: 8, left: 8, top: 4, bottom: 5),
                    width: size.width,
                    height: 33,
                    child: const Row(
                      children: [
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
              margin: const EdgeInsets.only(top: 16, left: 20, right: 20),
              width: 245,
              height: 40,
              child: Material(
                child: InkWell(
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    if (userData.role['asset_management'] != 1 &&
                        userData.role['asset_request'] != 1) {
                      showDialog(
                        context: context,
                        builder: (context) => alert(context, "Tidak Berwenang",
                            "Anda tidak memiliki wewenang untuk mengakses menu ini"),
                      );
                      return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ManageSparePart(),
                      ),
                    );
                  },
                  customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: Container(
                    margin: const EdgeInsets.only(
                        right: 8, left: 8, top: 4, bottom: 5),
                    width: size.width,
                    height: 33,
                    child: const Row(
                      children: [
                        Icon(
                          CupertinoIcons.hammer,
                          size: 32,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          'Manage Spare Parts',
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
              margin: const EdgeInsets.only(top: 16, left: 20),
              width: 205,
              height: 40,
              child: Material(
                child: InkWell(
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    if (userData.role['user_management'] != 1) {
                      showDialog(
                        context: context,
                        builder: (context) => alert(context, "Tidak Berwenang",
                            "Anda tidak memiliki wewenang untuk mengakses menu ini"),
                      );
                      return;
                    }
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ManageUsers(),
                        ));
                  },
                  customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: Container(
                    margin: const EdgeInsets.only(
                        right: 8, left: 8, top: 4, bottom: 5),
                    width: size.width,
                    height: 33,
                    child: const Row(
                      children: [
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
              margin: const EdgeInsets.only(top: 16, left: 20),
              width: 205,
              height: 40,
              child: Material(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      ticketIconColor = Colors.black;
                    });
                    Navigator.of(context, rootNavigator: true).pop();
                    if (userData.role['asset_management'] != 1 &&
                        userData.role['asset_request'] != 1) {
                      showDialog(
                        context: context,
                        builder: (context) => alert(context, "Tidak Berwenang",
                            "Anda tidak memiliki wewenang untuk mengakses menu ini"),
                      );
                      return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ManageTicket(role: userData.role),
                      ),
                    );
                  },
                  customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: Container(
                    margin: const EdgeInsets.only(
                        right: 8, left: 8, top: 4, bottom: 5),
                    width: size.width,
                    height: 33,
                    child: Row(
                      children: [
                        Icon(
                          CupertinoIcons.tickets,
                          size: 32,
                          color: ticketIconColor,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        const Text(
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
              margin: const EdgeInsets.only(top: 16, left: 20),
              width: 230,
              height: 40,
              child: Material(
                child: InkWell(
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    if (userData.role['asset_approval'] != 1 &&
                        userData.role['asset_purchasing'] != 1) {
                      showDialog(
                        context: context,
                        builder: (context) => alert(context, "Tidak Berwenang",
                            "Anda tidak memiliki wewenang untuk mengakses menu ini"),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ManageRequest(role: userData.role),
                        ),
                      );
                    }
                  },
                  customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: Container(
                    margin: const EdgeInsets.only(
                        right: 8, left: 8, top: 4, bottom: 5),
                    width: size.width,
                    height: 33,
                    child: Row(
                      children: [
                        Icon(Icons.note_alt_outlined,
                            size: 32, color: requestIconColor),
                        const SizedBox(
                          width: 8,
                        ),
                        const Text(
                          'Manage Requests',
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
              margin: const EdgeInsets.only(top: 16, left: 20),
              width: 205,
              height: 40,
              child: Material(
                child: InkWell(
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    if (userData.role['asset_approval'] != 1 &&
                        userData.role['asset_purchasing'] != 1) {
                      showDialog(
                        context: context,
                        builder: (context) => alert(context, "Tidak Berwenang",
                            "Anda tidak memiliki wewenang untuk mengakses menu ini"),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ManagePurchase(),
                        ),
                      );
                    }
                  },
                  customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: Container(
                    margin: const EdgeInsets.only(
                        right: 8, left: 8, top: 4, bottom: 5),
                    width: size.width,
                    height: 33,
                    child: const Row(
                      children: [
                        Icon(
                          CupertinoIcons.creditcard,
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
              margin: const EdgeInsets.only(top: 16, left: 20),
              width: 205,
              height: 40,
              child: Material(
                child: InkWell(
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    if (userData.role['asset_approval'] != 1 &&
                        userData.role['asset_purchasing'] != 1) {
                      showDialog(
                        context: context,
                        builder: (context) => alert(context, "Tidak Berwenang",
                            "Anda tidak memiliki wewenang untuk mengakses menu ini"),
                      );
                      return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Performance(),
                      ),
                    );
                  },
                  customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: Container(
                    margin: const EdgeInsets.only(
                        right: 8, left: 8, top: 4, bottom: 5),
                    width: size.width,
                    height: 33,
                    child: const Row(
                      children: [
                        Icon(
                          CupertinoIcons.chart_pie,
                          size: 32,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          'Performance',
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
              margin: const EdgeInsets.only(top: 16, left: 20),
              width: 205,
              height: 40,
              child: Material(
                child: InkWell(
                  onTap: () async {
                    Navigator.of(context, rootNavigator: true).pop();
                    Navigator.push(
                      context, MaterialPageRoute(
                        builder: (context) => const QrPage(),
                      )
                    );
                  },
                  customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: Container(
                    margin: const EdgeInsets.only(
                        right: 8, left: 8, top: 4, bottom: 5),
                    width: size.width,
                    height: 33,
                    child: const Row(
                      children: [
                        Icon(
                          Icons.qr_code,
                          size: 32,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          'Scan QR Code',
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
              margin: EdgeInsets.only(top: size.height / 5, left: 20),
              width: 205,
              height: 40,
              child: Material(
                child: InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content:
                                const Text("Apakah anda yakin ingin log out?"),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xff00ABB3),
                                ),
                                child: const Text("Batal"),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  try {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    String? token =
                                        prefs.getString('token').toString();
                                    bool response =
                                        await Services.logout(token);
                                    setState(() {
                                      isLoading = true;
                                    });
                                    if (response) {
                                      if (mounted) {
                                        prefs.clear();
                                        Navigator.popUntil(
                                            context, (route) => route.isFirst);
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
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          backgroundColor:
                                              const Color(0xff00ABB3),
                                          content: Text(
                                            e.toString(),
                                            style: const TextStyle(
                                                color: Colors.red),
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xff00ABB3),
                                ),
                                child: const Text("Ya"),
                              ),
                            ],
                          );
                        });
                  },
                  customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: Container(
                    margin: const EdgeInsets.only(
                        right: 8, left: 8, top: 4, bottom: 5),
                    width: size.width,
                    height: 33,
                    child: const Row(
                      children: [
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
              margin: const EdgeInsets.only(left: 30, top: 24),
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
