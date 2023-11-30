import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:repit_app/widgets/alert.dart';
import 'package:repit_app/widgets/custom_app_bar.dart';
import 'package:repit_app/widgets/custom_text_field_builder.dart';
import 'package:repit_app/widgets/drop_down_builder.dart';
import 'package:repit_app/widgets/loading_overlay.dart';

import '../data_classes/department_for_list.dart';
import '../data_classes/location_for_list.dart';
import '../data_classes/user_for_list.dart';
import '../services.dart';

class AssetTransfer extends StatefulWidget {
  final int assetId;

  const AssetTransfer({super.key, required this.assetId});

  @override
  State<AssetTransfer> createState() => _AssetTransferState();
}

class _AssetTransferState extends State<AssetTransfer> {
  late Future<List<LocationForList>> locations;
  int locationId = 0;
  late Future<List<DepartmentForList>> departments;
  int departmentId = 0;
  late Future<List<UserForList>> users;
  late String userId;
  TextEditingController utilizationEc = TextEditingController();
  bool isLoading = false;
  bool isEnabled = true;

  @override
  void initState() {
    locations = fetchLocations();
    departments = fetchDepartments();
    users = fetchUsers();
    super.initState();
  }

  Future<List<LocationForList>> fetchLocations() async {
    final data = await Services.getLocationList();
    if (data == null) {
      return [];
    }
    setState(() {
      locationId = data[0]['id'];
      users = fetchUsers();
    });
    return data.map((item) {
      return LocationForList(item['id'], item['name']);
    }).toList();
  }

  Future<List<DepartmentForList>> fetchDepartments() async {
    final data = await Services.getDepartmentList();
    if (data == null) {
      return [];
    }
    setState(() {
      departmentId = data[3]['id'];
      users = fetchUsers();
    });
    return data.map((item) {
      return DepartmentForList(id: item['id'], department: item['department']);
    }).toList();
  }

  Future<List<UserForList>> fetchUsers() async {
    final data =
        await Services.getUserByLocationAndDepartment(departmentId, locationId);
    if (data == null) {
      return [];
    }
    setState(() {
      userId = data[0]['id'];
    });
    return data.map((item) {
      return UserForList(item['id'], item['full_name']);
    }).toList();
  }

  @override
  void dispose() {
    utilizationEc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Scaffold(
          appBar: customAppBar(context, "Transfer Asset"),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Nomor Asset: ${widget.assetId}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  locationDropdownBuilder(
                    context,
                    enabled: isEnabled,
                    future: locations,
                    size: size,
                    onSelected: (value) {
                      setState(() {
                        locationId = int.parse(value as String);
                        users = fetchUsers();
                      });
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  departmentDropdownBuilder(
                    context,
                    enabled: isEnabled,
                    future: departments,
                    size: size,
                    onSelected: (value) {
                      setState(() {
                        departmentId = int.parse(value as String);
                        users = fetchUsers();
                      });
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  if (departmentId != 0 && locationId != 0)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        userDropdownBuilder(
                          context,
                          enabled: isEnabled,
                          future: users,
                          size: size,
                          onSelected: (value) {
                            setState(() {
                              userId = value;
                              debugPrint(userId);
                            });
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        regularTextFieldBuilder(
                          enabled: isEnabled,
                          labelText: "Peruntukan*",
                          controller: utilizationEc,
                          obscureText: false,
                        ),
                      ],
                    ),
                  const SizedBox(
                    height: 24,
                  ),
                  SizedBox(
                    width: size.width,
                    height: 41,
                    child: ElevatedButton(
                      onPressed: isEnabled
                          ? () {
                              if (utilizationEc.text.trim().isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: Color(0xff00ABB3),
                                    content: Text(
                                      "Peruntukan tidak boleh kosong",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                );
                                return;
                              }
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text("Konfirmasi"),
                                    content: const Text(
                                        "Apakah anda yakin ingin memindah aset?"),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xffF05050),
                                        ),
                                        child: const Text("Tidak"),
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          setState(() {
                                            isLoading = true;
                                          });
                                          try {
                                            Response? response =
                                                await Services.transferAsset(
                                                    userId,
                                                    utilizationEc.text.trim(),
                                                    widget.assetId);
                                            if (mounted) {
                                              setState(() {
                                                isEnabled = false;
                                                isLoading = false;
                                              });
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  backgroundColor:
                                                      const Color(0xff00ABB3),
                                                  content: Text(response!
                                                      .data["message"]),
                                                ),
                                              );
                                            }
                                          } catch (e) {
                                            setState(() {
                                              isLoading = false;
                                            });
                                            if (mounted) {
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
                                          if(mounted){
                                            Navigator.of(context).pop();
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xff00ABB3),
                                        ),
                                        child: const Text("Ya"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff00ABB3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: const Text("Pindahkan"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        loadingOverlay(isLoading, context)
      ],
    );
  }
}
