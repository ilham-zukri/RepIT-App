import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:repit_app/data_classes/role_for_list.dart';
import 'package:repit_app/services.dart';
import 'package:repit_app/widgets/alert.dart';
import 'package:repit_app/widgets/custom_app_bar.dart';
import 'package:repit_app/widgets/custom_text_field_builder.dart';
import 'package:repit_app/widgets/drop_down_builder.dart';

import '../data_classes/department_for_list.dart';
import '../data_classes/location_for_list.dart';

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  late Future<List<LocationForList>> locations;
  late int locationId;
  bool isLoading = false;
  late Future<List<DepartmentForList>> departments;
  late int departmentId;
  late Future<List<RoleForList>> roles;
  late int roleId;

  TextEditingController userNameEc = TextEditingController();
  TextEditingController passwordEc = TextEditingController();
  TextEditingController fullNameEc = TextEditingController();
  TextEditingController emailEc = TextEditingController();
  TextEditingController empNumberEc = TextEditingController();

  @override
  void dispose() {
    userNameEc.dispose();
    passwordEc.dispose();
    fullNameEc.dispose();
    emailEc.dispose();
    empNumberEc.dispose();
    roles = fetchRoles();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    locations = fetchLocations();
    departments = fetchDepartments();
    roles = fetchRoles();
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

  Future<List<DepartmentForList>> fetchDepartments() async {
    final data = await Services.getDepartmentList();
    if (data == null) {
      return [];
    }
    departmentId = data[3]['id'];
    return data.map((item) {
      return DepartmentForList(id: item['id'], department: item['department']);
    }).toList();
  }

  Future<List<RoleForList>> fetchRoles() async {
    final data = await Services.getRoleList();
    if (data == null) {
      return [];
    }
    roleId = data[2]['id'];
    return data
        .map((role) => RoleForList(id: role['id'], roleName: role['role_name']))
        .toList();
  }



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(children: [
      Scaffold(
        appBar: customAppBar(context, "Add User"),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                locationDropdownBuilder(
                  context,
                  enabled: true,
                  future: locations,
                  size: size,
                  onSelected: (value) {
                    setState(() {
                      locationId = int.parse(value as String);
                    });
                  },
                ),
                const SizedBox(
                  height: 24,
                ),
                departmentDropdownBuilder(
                  context,
                  enabled: true,
                  future: departments,
                  size: size,
                  onSelected: (value) {
                    setState(
                      () {
                        departmentId = int.parse(value as String);
                      },
                    );
                  },
                ),
                const SizedBox(
                  height: 24,
                ),
                regularTextFieldBuilder(
                    labelText: "Username*",
                    controller: userNameEc,
                    obscureText: false),
                const SizedBox(
                  height: 24,
                ),
                regularTextFieldBuilder(
                  labelText: "Password*",
                  controller: passwordEc,
                  obscureText: true,
                ),
                const SizedBox(
                  height: 24,
                ),
                roleDropdownBuilder(
                  context,
                  future: roles,
                  size: size,
                  onSelected: (value) {
                    setState(() {
                      roleId = int.parse(value as String);
                    });
                  },
                ),
                const SizedBox(
                  height: 24,
                ),
                regularTextFieldBuilder(
                  labelText: "Nama Lengkap*",
                  controller: fullNameEc,
                  obscureText: false,
                ),
                const SizedBox(
                  height: 24,
                ),
                regularTextFieldBuilder(
                  labelText: "Nomor Karyawan*",
                  controller: empNumberEc,
                  obscureText: false,
                ),
                const SizedBox(
                  height: 24,
                ),
                regularTextFieldBuilder(
                  labelText: "Email",
                  controller: emailEc,
                  obscureText: false,
                ),
                const SizedBox(
                  height: 24,
                ),
                SizedBox(
                  height: 41,
                  width: size.width,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff00ABB3),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                        elevation: 5),
                    onPressed: () async {
                      if (userNameEc.text.isEmpty ||
                          passwordEc.text.isEmpty ||
                          fullNameEc.text.trim().isEmpty ||
                          empNumberEc.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Color(0xff00ABB3),
                            content: Text(
                              "Lengkapi Field Berbintang",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        );
                        return;
                      }
                      String userName = userNameEc.text.trim();
                      String password = passwordEc.text.trim();
                      String? fullName = (fullNameEc.text.trim().isNotEmpty)
                          ? fullNameEc.text.trim()
                          : null;
                      String? email = (emailEc.text.trim().isNotEmpty)
                          ? emailEc.text.trim()
                          : null;
                      String? empNumber = (empNumberEc.text.trim().isNotEmpty)
                          ? empNumberEc.text.trim()
                          : null;
                      setState(() {
                        isLoading = true;
                      });
                      try {
                        Response? response = await Services.addUser(
                          userName: userName,
                          password: password,
                          roleId: roleId,
                          departmentId: departmentId,
                          locationId: locationId,
                          fullName: fullName,
                          email: email,
                          empNumber: empNumber,
                        );
                        setState(() {
                          isLoading = false;
                        });
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: const Color(0xff00ABB3),
                              content: Text(
                                response!.data["message"],
                              )));
                          Navigator.pop(context);
                        }
                      } catch (e) {
                        setState(() {
                          isLoading = false;
                        });
                        if (mounted) {
                          showDialog(
                            context: context,
                            builder: (context) =>
                                alert(context, "Error", e.toString()),
                          );
                        }
                      }
                    },
                    child: const Text(
                      "Buat User",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    ]);
  }
}
