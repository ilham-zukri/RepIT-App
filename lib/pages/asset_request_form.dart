import 'package:flutter/material.dart';
import 'package:repit_app/data_classes/location_for_list.dart';
import 'package:repit_app/data_classes/user_for_list.dart';
import 'package:repit_app/services.dart';
import 'package:repit_app/widgets/custom_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/alert.dart';

class AssetRequestForm extends StatefulWidget {
  const AssetRequestForm({Key? key}) : super(key: key);

  @override
  State<AssetRequestForm> createState() => _AssetRequestFormState();
}

class _AssetRequestFormState extends State<AssetRequestForm> {
  final TextEditingController titleEc = TextEditingController();
  final TextEditingController descEc = TextEditingController();
  late String userId;
  late int locationId;
  static const List<String> priorities = <String>[
    'Low',
    'Medium',
    'High',
    'Urgent'
  ];
  String priority = priorities.first;
  late Future<List<LocationForList>> locations;
  late SharedPreferences prefs;
  late Future<List<UserForList>> userData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userData = fetchUsers();
    locations = fetchLocations();
  }

  Future<List<UserForList>> fetchUsers() async {
    final data = await Services.getMySubordinates();
    if (data == null) {
      return [];
    }

    userId = data[0]['id'];
    return data.map((item) {
      return UserForList(item['id'], item['user_name']);
    }).toList();
  }

  Future<List<LocationForList>> fetchLocations() async {
    final data = await Services.getLocationList();
    if (data == null) {
      return [];
    }
    locationId = data[0]['id'];
    return data.map((item) {
      return LocationForList(item['id'], item['name']);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      appBar: customAppBar(context, "Request Aset"),
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
                  "Judul*",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
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
                  "Deskripsi*",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
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
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black54, width: 1),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      isExpanded: true,
                      value: priority,
                      items: priorities.map((String value) {
                        return DropdownMenuItem(
                            value: value, child: Text(value));
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
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              FutureBuilder(
                  future: userData,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else {
                      List<dynamic>? userData = snapshot.data;
                      String? initialUserSelection;
                      if (userData != null && userData.isNotEmpty) {
                        initialUserSelection = userData.first.id;
                      }
                      return DropdownMenu(
                        textStyle: const TextStyle(fontSize: 16),
                        width: size.width - 48,
                        enableSearch: true,
                        initialSelection: initialUserSelection,
                        onSelected: (value) {
                          setState(() {
                            userId = value.toString();
                          });
                        },
                        dropdownMenuEntries: userData!.map((user) {
                          return DropdownMenuEntry(
                              value: user.id, label: user.userName);
                        }).toList(),
                      );
                    }
                  }),
              const SizedBox(
                height: 24,
              ),
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Lokasi",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              FutureBuilder(
                  future: locations,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else {
                      List<dynamic>? locationData = snapshot.data;
                      String? initialLocationSelection;
                      if (locationData != null && locationData.isNotEmpty) {
                        initialLocationSelection =
                            locationData.first.id.toString();
                      }
                      return DropdownMenu(
                        textStyle: const TextStyle(fontSize: 16),
                        width: size.width - 48,
                        enableSearch: true,
                        menuHeight: size.height / 2,
                        initialSelection: initialLocationSelection,
                        onSelected: (value) {
                          setState(() {
                            locationId = int.parse(value as String);
                          });
                        },
                        dropdownMenuEntries: locationData!.map((location) {
                          return DropdownMenuEntry(
                              value: location.id.toString(),
                              label: location.name);
                        }).toList(),
                      );
                    }
                  }),
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
                  onPressed: () async {
                    if (titleEc.text.isEmpty || descEc.text.isEmpty) {
                      showDialog(
                          context: context, builder: (BuildContext context) => alert(context, 'Lengkapi form', 'Judul dan Deskripsi tidak boleh kosong'));
                    } else {
                      try {
                        var response = await Services.createAssetRequest(
                            titleEc.text.toString(),
                            descEc.text.toString(),
                            priority,
                            userId,
                            locationId);
                        if(mounted){
                          showDialog(context: context, builder: (context) => alert(context, response!.data['message'], "request terbuat"));
                        }
                      } catch (e) {
                        if(mounted){
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return alert(context, 'Error', e.toString());
                            },
                          );
                        }
                      }
                    }
                    if(mounted){
                      Navigator.of(context).pop;
                    }
                  },
                  child: const Text(
                    "Kirim",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
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
