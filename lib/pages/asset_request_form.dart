import 'package:flutter/material.dart';
import 'package:repit_app/services.dart';
import 'package:repit_app/widgets/custom_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AssetRequestForm extends StatefulWidget {
  const AssetRequestForm({Key? key}) : super(key: key);

  @override
  State<AssetRequestForm> createState() => _AssetRequestFormState();
}

class _AssetRequestFormState extends State<AssetRequestForm> {
  final TextEditingController titleEc = TextEditingController();
  final TextEditingController descEc = TextEditingController();
  late String userId;
  late String location;
  static const List<String> priorities = <String>[
    'Low',
    'Medium',
    'High',
    'Urgent'
  ];
  String priority = priorities.first;
  late List? users;
  late List? locations;
  late SharedPreferences prefs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPrefs();
    getUsers();
    getLocations();
  }

  void getPrefs()async{
    prefs = await SharedPreferences.getInstance();
  }

  void getUsers() async{
    users = await Services.getMySubordinates();
  }

  void getLocations() async{

  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: customAppBar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 24, right: 24),
          child: Column(
            children: [
              const SizedBox(
                height: 24,
              ),
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Judul",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 8),
                height: 41,
                child: TextField(
                  controller: titleEc,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(10),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Deskripsi",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 8),
                height: 112,
                child: TextField(
                  maxLines: 100,
                  controller: descEc,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(10),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Prioritas",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black54,
                    width: 1
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(10))
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 6, right: 6),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      isExpanded: true,
                      value: priority,
                      items: priorities.map((String value) {
                        return DropdownMenuItem(value: value, child: Text(value));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          priority = value!;
                        });
                      },
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "User",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              DropdownMenu(
                width: size.width - 48,
                enableSearch: true,
                initialSelection: priorities.first,
                onSelected: (value) => priority = value.toString(),
                dropdownMenuEntries: priorities.map((String value) {
                  return DropdownMenuEntry(value: value, label: value);
                }).toList(),
              ),
              const SizedBox(
                height: 24,
              ),
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Lokasi",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              DropdownMenu(
                width: size.width - 48,
                enableSearch: true,
                initialSelection: priorities.first,
                onSelected: (value) => priority = value.toString(),
                dropdownMenuEntries: priorities.map((String value) {
                  return DropdownMenuEntry(value: value, label: value);
                }).toList(),
              ),
              Container(
                margin: const EdgeInsets.only(top: 24),
                height: 41,
                width: size.width,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff00ABB3),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      elevation: 5),
                  onPressed: () {
                  },
                  child: const Text(
                    "Kirim",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
