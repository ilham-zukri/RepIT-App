import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:repit_app/data_classes/asset.dart';
import 'package:repit_app/widgets/custom_app_bar.dart';
import 'package:repit_app/widgets/loading_overlay.dart';

import '../data_classes/user_for_list.dart';
import '../services.dart';
import '../widgets/alert.dart';

class RegisterAssetOld extends StatefulWidget {
  const RegisterAssetOld({super.key});

  @override
  State<RegisterAssetOld> createState() => _RegisterAssetOldState();
}

class _RegisterAssetOldState extends State<RegisterAssetOld> {
  late String assetType;
  late Future<List?> assetTypes;
  bool isLoading = false;
  TextEditingController brandEc = TextEditingController();
  TextEditingController modelEc = TextEditingController();
  TextEditingController serialNumberEc = TextEditingController();
  TextEditingController cpuEc = TextEditingController();
  TextEditingController ramEc = TextEditingController();
  TextEditingController utilizationEc = TextEditingController();
  late Future<List<UserForList>> userData;
  late String userId;

  @override
  void initState() {
    super.initState();
    assetTypes = fetchAssetTypes();
    userData = fetchUsers();
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

  Future<List?> fetchAssetTypes() async {
    try {
      final data = await Services.getAssetType();
      if (data == null) {
        return [];
      }
      assetType = data.first['type'];
      return data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Scaffold(
          appBar: customAppBar(
            context,
            "Tambahkan Asset Lama",
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Tipe Aset*",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  FutureBuilder(
                      future: assetTypes,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text(snapshot.error.toString());
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else {
                          List<dynamic>? types = snapshot.data;
                          String? initialTypeSelection;
                          if (types != null && types.isNotEmpty) {
                            initialTypeSelection = types.first['type'];
                          }
                          return DropdownMenu(
                            textStyle: const TextStyle(fontSize: 16),
                            width: size.width - 48,
                            enableSearch: true,
                            initialSelection: initialTypeSelection,
                            onSelected: (value) {
                              setState(() {
                                assetType = value;
                              });
                            },
                            dropdownMenuEntries: types!.map((type) {
                              return DropdownMenuEntry(
                                  value: type['type'], label: type['type']);
                            }).toList(),
                          );
                        }
                      }),
                  const SizedBox(
                    height: 8,
                  ),
                  const Text(
                    "User",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
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
                    height: 8,
                  ),
                  const Text(
                    "Merek*",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    height: 45,
                    child: TextField(
                      controller: brandEc,
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
                    height: 8,
                  ),
                  const Text(
                    "Model*",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    height: 45,
                    child: TextField(
                      controller: modelEc,
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
                    height: 8,
                  ),
                  const Text(
                    "Serial Number*",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    height: 45,
                    child: TextField(
                      controller: serialNumberEc,
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
                    height: 8,
                  ),
                  const Text(
                    "CPU",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    height: 45,
                    child: TextField(
                      controller: cpuEc,
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
                    height: 8,
                  ),
                  const Text(
                    "RAM",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    height: 45,
                    child: TextField(
                      controller: ramEc,
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
                    height: 8,
                  ),
                  const Text(
                    "Utilization*",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    height: 45,
                    child: TextField(
                      controller: utilizationEc,
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
                    height: 16,
                  ),
                  SizedBox(
                    width: size.width,
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff009199),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                        elevation: 5,
                      ),
                      onPressed: () async {
                        bool validation = serialNumberEc.text.trim().isEmpty ||
                            utilizationEc.text.trim().isEmpty ||
                            brandEc.text.trim().isEmpty ||
                            modelEc.text.trim().isEmpty;

                        if (validation) {
                          showDialog(
                            context: context,
                            builder: (context) => alert(
                                context,
                                "Lengkapi Field",
                                "Field dengan bintang wajib diisi"),
                          );
                          return;
                        }
                        Asset asset = Asset(
                            null,
                            utilizationEc.text.trim(),
                            null,
                            assetType,
                            ramEc.text.trim(),
                            cpuEc.text.trim(),
                            null,
                            serialNumberEc.text.trim(),
                            brandEc.text.trim(),
                            modelEc.text.trim(),
                            null);
                        Map<String, dynamic> assetData = asset.toMap();
                        assetData["owner_id"] = userId;
                        try {
                          setState(() {
                            isLoading = true;
                          });
                          Response? response =
                              await Services.registerAsset(assetData);
                          setState(() {
                            isLoading = false;
                          });
                          if(mounted){
                            showDialog(
                              context: context,
                              builder: (context) => alert(
                                  context,
                                  response!.data['message'],
                                  "Asset Berhasil ditambahkan"),
                            );
                          }
                          clearFields();
                        } catch (e) {
                          if (mounted) {
                            setState(() {
                              isLoading = false;
                            });
                            showDialog(
                              context: context,
                              builder: (context) => alert(
                                context,
                                "Error",
                                e.toString(),
                              ),
                            );
                          }
                        }
                      },
                      child: const Text(
                        "Tambahkan",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        loadingOverlay(isLoading, context),
      ],
    );
  }
  void clearFields(){
    brandEc.clear();
    modelEc.clear();
    serialNumberEc.clear();
    utilizationEc.clear();
    ramEc.clear();
    cpuEc.clear();
  }
}
