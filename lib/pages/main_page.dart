import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:repit_app/asset_card.dart';
import 'package:repit_app/data_classes/user.dart';
import 'package:repit_app/services.dart';

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
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.account_circle, size: 24),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications, size: 24),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert, size: 24),
          ),
        ],
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
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
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: ListView(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: const [
                  AssetCard(),
                ],
              ),
            ),
          ],
        ),
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
      drawer: const Drawer(),
    );
  }
}
