import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:repit_app/widgets/alert.dart';
import 'package:repit_app/widgets/custom_app_bar.dart';
import 'package:repit_app/widgets/drop_down_builder.dart';
import 'package:repit_app/widgets/loading_overlay.dart';

import '../data_classes/department_for_list.dart';
import '../data_classes/location_for_list.dart';
import '../data_classes/role_for_list.dart';
import '../data_classes/user.dart';
import '../services.dart';

class AdvancedUserMenu extends StatefulWidget {
  final User userData;

  const AdvancedUserMenu({super.key, required this.userData});

  @override
  State<AdvancedUserMenu> createState() => _AdvancedUserMenuState();
}

class _AdvancedUserMenuState extends State<AdvancedUserMenu> {
  late User userData;
  late Future<List<LocationForList>> locations;
  late int locationId;
  int initialLocationIndex = 0;
  bool isLoading = false;
  late Future<List<DepartmentForList>> departments;
  late int departmentId;
  int initialDepartmentIndex = 0;
  late Future<List<RoleForList>> roles;
  late int roleId;
  int initialRoleIndex = 0;

  @override
  void initState() {
    userData = widget.userData;
    locations = fetchLocations();
    departments = fetchDepartments();
    roles = fetchRoles();
    super.initState();
  }

  Future<List<LocationForList>> fetchLocations() async {
    final data = await Services.getLocationList();
    if (data == null) {
      return [];
    }
    setState(() {
      initialLocationIndex = data.indexWhere(
        (location) => location['name'] == userData.branch,
      );
      locationId = data[initialLocationIndex]['id'];
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
      initialDepartmentIndex = data.indexWhere(
        (department) => department['department'] == userData.department,
      );
      departmentId = data[initialDepartmentIndex]['id'];
    });
    return data.map((item) {
      return DepartmentForList(id: item['id'], department: item['department']);
    }).toList();
  }

  Future<List<RoleForList>> fetchRoles() async {
    final data = await Services.getRoleList();
    if (data == null) {
      return [];
    }
    setState(() {
      initialRoleIndex = data.indexWhere(
        (role) => role['role_name'] == userData.role['role_name'],
      );
      roleId = data[initialRoleIndex]['id'];
    });
    return data
        .map((role) => RoleForList(id: role['id'], roleName: role['role_name']))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Scaffold(
          appBar: customAppBar(context, "Advanced User Menu"),
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      (userData.fullName != null)
                          ? userData.fullName!
                          : userData.userName!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        bool active = (userData.active != 1);
                        try {
                          Response? response =
                              await Services.setActive(userData.id!, active);
                          setState(() {
                            isLoading = false;
                            userData.active = active ? 1 : 0;
                          });
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: const Color(0xff00ABB3),
                                content: Text(
                                  response!.data['message'],
                                ),
                              ),
                            );
                          }
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: (userData.active == 1)
                            ? const Color(0xffF05050)
                            : const Color(0xff009199),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: (userData.active == 1)
                          ? const Text("Nonaktifkan")
                          : const Text("Aktifkan"),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                locationDropdownBuilder(
                  context,
                  future: locations,
                  size: size,
                  initialIndex: initialLocationIndex,
                  onSelected: (value) {
                    setState(() {
                      locationId = int.parse(value as String);
                    });
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                departmentDropdownBuilder(
                  context,
                  future: departments,
                  size: size,
                  initialIndex: initialDepartmentIndex,
                  onSelected: (value) {
                    setState(() {
                      departmentId = int.parse(value as String);
                    });
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                roleDropdownBuilder(
                  context,
                  future: roles,
                  size: size,
                  initialIndex: initialRoleIndex,
                  onSelected: (value) {
                    setState(() {
                      roleId = int.parse(value as String);
                    });
                  },
                ),
                const SizedBox(
                  height: 26,
                ),
                SizedBox(
                  width: size.width,
                  height: 41,
                  child: ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      try {
                        Response? response = await Services.advanceUserEdit(
                          userData.id!,
                          departmentId,
                          locationId,
                          roleId,
                        );
                        setState(() {
                          isLoading = false;
                        });
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: const Color(0xff00ABB3),
                              content: Text(
                                response!.data['message'],
                              ),
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
                            builder: (context) =>
                                alert(context, "error", e.toString()),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff00ABB3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text("Simpan"),
                  ),
                ),
              ],
            ),
          ),
        ),
        loadingOverlay(isLoading, context)
      ],
    );
  }
}
