import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:repit_app/data_classes/user_for_list.dart';
import 'package:repit_app/services.dart';
import 'package:repit_app/widgets/custom_app_bar.dart';
import 'package:repit_app/widgets/custom_text_field_builder.dart';
import 'package:repit_app/widgets/loading_overlay.dart';
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
  bool isLoading = false;
  bool isDisabled = false;
  late int priority;
  late Future<List?> prioritiesList;
  late SharedPreferences prefs;
  late Future<List<UserForList>> userData;
  static const titleHint = 'Laptop Untuk WFH';
  static const descHint = 'Adakan laptop untuk WFH karyawan';
  late EdgeInsets mainPadding;
  @override
  void initState() {
    mainPadding = !kIsWeb ? const EdgeInsets.symmetric(horizontal: 24) : const EdgeInsets.symmetric(horizontal: 600);
    super.initState();
    userData = fetchUsers();
    prioritiesList = fetchPriorities();
  }

  @override
  void dispose() {
    titleEc.dispose();
    descEc.dispose();
    super.dispose();
  }

  Future<List<UserForList>> fetchUsers() async {
    final data = await Services.getMySubordinates();
    if (data == null) {
      return [];
    }

    userId = data[0]['id'];
    return data.map((item) {
      return UserForList(item['id'], item['full_name']);
    }).toList();
  }

  Future<List> fetchPriorities() async {
    final data = await Services.getPriorities();
    if (data == null) {
      return [];
    }
    priority = data.last['id'];
    return data;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: customAppBar(context, "Request Aset"),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: mainPadding,
              child: Column(
                children: [
                  const SizedBox(
                    height: 24,
                  ),
                  regularTextFieldBuilder(
                    labelText: "Judul*",
                    controller: titleEc,
                    obscureText: false,
                    hintText: titleHint,
                    enabled: (!isDisabled),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  descriptionTextFieldBuilder(
                    labelText: "Deskripsi*",
                    controller: descEc,
                    hintText: descHint,
                    enabled: (!isDisabled),
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
                  FutureBuilder(
                    future: prioritiesList,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else {
                        List? priorities = snapshot.data;
                        return DecoratedBox(
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black54, width: 1),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                isExpanded: true,
                                value: priority,
                                items: priorities!.map((priority) {
                                  return DropdownMenuItem(
                                      value: priority['id'],
                                      child: Text(priority['priority']));
                                }).toList(),
                                onChanged: (!isDisabled)
                                    ? (value) {
                                        setState(() {
                                          priority =
                                              int.tryParse(value.toString())
                                                  as int;
                                        });
                                      }
                                    : null,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Penerima",
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
                            enabled: (!isDisabled),
                            textStyle: const TextStyle(fontSize: 16),
                            width:(!kIsWeb) ?size.width - 48 : size.width - 1200,
                            enableSearch: true,
                            initialSelection: initialUserSelection,
                            onSelected: (value) {
                              setState(() {
                                userId = value.toString();
                              });
                            },
                            dropdownMenuEntries: userData!.map((user) {
                              return DropdownMenuEntry(
                                  value: user.id, label: user.fullName);
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
                      onPressed: (!isDisabled)
                          ? () async {
                              if (titleEc.text.isEmpty || descEc.text.isEmpty) {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) => alert(
                                        context,
                                        'Lengkapi form',
                                        'Judul dan Deskripsi tidak boleh kosong'));
                              } else {
                                try {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  var response =
                                      await Services.createAssetRequest(
                                    titleEc.text.toString(),
                                    descEc.text.toString(),
                                    priority,
                                    userId,
                                  );
                                  setState(() {
                                    isDisabled = true;
                                    isLoading = false;
                                  });
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor:
                                            const Color(0xff00ABB3),
                                        content: Text(
                                          response!.data["message"],
                                        ),
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  if (mounted) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return alert(
                                            context, 'Error', e.toString());
                                      },
                                    );
                                  }
                                }
                              }
                              if (mounted) {
                                Navigator.of(context).pop;
                              }
                            }
                          : null,
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
          loadingOverlay(isLoading, context)
        ],
      ),
    );
  }
}
