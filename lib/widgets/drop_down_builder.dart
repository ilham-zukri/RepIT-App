import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Widget sparePartTypeDropDownBuilder(BuildContext context,
    {required Future future,
    required String label,
    required int value,
    required void Function(dynamic) onChange}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black),
      ),
      const SizedBox(
        height: 8,
      ),
      FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else {
            List? data = snapshot.data;
            return DecoratedBox(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black54, width: 1),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    isExpanded: true,
                    value: value,
                    items: data!.map((data) {
                      return DropdownMenuItem(
                          value: data['id'], child: Text(data['type']));
                    }).toList(),
                    onChanged: onChange,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            );
          }
        },
      ),
    ],
  );
}
Widget locationDropdownButtonBuilder(BuildContext context,
    {required Future future,
    required String label,
    required int value,
    required void Function(dynamic) onChange}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black),
      ),
      const SizedBox(
        height: 8,
      ),
      FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else {
            List? data = snapshot.data;
            return DecoratedBox(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black54, width: 1),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    isExpanded: true,
                    value: value,
                    items: data!.map((data) {
                      return DropdownMenuItem(
                          value: data['id'], child: Text(data['name']));
                    }).toList(),
                    onChanged: onChange,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            );
          }
        },
      ),
    ],
  );
}

Widget locationDropdownBuilder(
  BuildContext context, {
  required Future future,
  required Size size,
  required void Function(dynamic) onSelected,
      required bool enabled,
  int? initialIndex,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "Lokasi",
        style: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black),
      ),
      const SizedBox(
        height: 8,
      ),
      FutureBuilder(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else {
              List<dynamic>? locationData = snapshot.data;
              String? initialLocationSelection;
              if (locationData != null && locationData.isNotEmpty) {
                initialLocationSelection = (initialIndex == null)
                    ? locationData.first.id.toString()
                    : locationData[initialIndex].id.toString();
              }
              return DropdownMenu(
                enabled: enabled,
                textStyle: const TextStyle(fontSize: 16),
                width: (!kIsWeb)  ? size.width - 48 : size.width - 1200,
                enableSearch: true,
                menuHeight: size.height / 2,
                initialSelection: initialLocationSelection,
                onSelected: onSelected,
                dropdownMenuEntries: locationData!.map((location) {
                  return DropdownMenuEntry(
                      value: location.id.toString(), label: location.name);
                }).toList(),
              );
            }
          }),
    ],
  );
}


Widget departmentDropdownBuilder(
  BuildContext context, {
  required Future future,
  required Size size,
  required void Function(dynamic) onSelected,
  required bool enabled,
  int? initialIndex,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "Departemen",
        style: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black),
      ),
      const SizedBox(
        height: 8,
      ),
      FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else {
            List<dynamic>? departmentData = snapshot.data;
            String? initialLocationSelection;
            if (departmentData != null && departmentData.isNotEmpty) {
              initialLocationSelection = (initialIndex == null)
                  ? departmentData[3].id.toString()
                  : departmentData[initialIndex].id.toString();
            }
            return DropdownMenu(
              enabled: enabled,
              textStyle: const TextStyle(fontSize: 16),
              width: (!kIsWeb)  ? size.width - 48 : size.width - 1200,
              enableSearch: true,
              menuHeight: size.height / 2,
              initialSelection: initialLocationSelection,
              onSelected: onSelected,
              dropdownMenuEntries: departmentData!.map((department) {
                return DropdownMenuEntry(
                    value: department.id.toString(),
                    label: department.department);
              }).toList(),
            );
          }
        },
      ),
    ],
  );
}

Widget roleDropdownBuilder(
  BuildContext context, {
  required Future future,
  required Size size,
  required void Function(dynamic) onSelected,
  int? initialIndex,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "Role",
        style: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black),
      ),
      const SizedBox(
        height: 8,
      ),
      FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else {
            List<dynamic>? roleData = snapshot.data;
            String? initialRoleSelection;
            if (roleData != null && roleData.isNotEmpty) {
              initialRoleSelection = (initialIndex == null)
                  ? roleData[2].id.toString()
                  : roleData[initialIndex].id.toString();
            }
            return DropdownMenu(
              textStyle: const TextStyle(fontSize: 16),
              width: (!kIsWeb)  ? size.width - 48 : size.width - 1200,
              enableSearch: true,
              menuHeight: size.height / 2,
              initialSelection: initialRoleSelection,
              onSelected: onSelected,
              dropdownMenuEntries: roleData!.map((role) {
                return DropdownMenuEntry(
                    value: role.id.toString(), label: role.roleName);
              }).toList(),
            );
          }
        },
      ),
    ],
  );
}

Widget userDropdownBuilder(
  BuildContext context, {
  required Future future,
  required Size size,
  required void Function(dynamic) onSelected,
  required bool enabled,
  int? initialIndex,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "User",
        style: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black),
      ),
      const SizedBox(
        height: 8,
      ),
      FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else {
            List<dynamic>? userData = snapshot.data;
            String? initialUserSelection;
            if (userData != null && userData.isNotEmpty) {
              initialUserSelection = (initialIndex == null)
                  ? userData[0].id
                  : userData[initialIndex].id.toString();
            }
            return DropdownMenu(
              enabled: enabled,
              textStyle: const TextStyle(fontSize: 16),
              width: size.width - 48,
              enableSearch: true,
              menuHeight: size.height / 2,
              initialSelection: initialUserSelection,
              onSelected: onSelected,
              dropdownMenuEntries: userData!.map((user) {
                return DropdownMenuEntry(
                    value: user.id.toString(), label: user.fullName);
              }).toList(),
            );
          }
        },
      ),
    ],
  );
}

Widget priorityDropdownBuilder(
  BuildContext context, {
  required Future future,
  required Size size,
      required bool enabled,
  required void Function(dynamic) onSelected,
  int? initialIndex,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "Prioritas",
        style: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black),
      ),
      const SizedBox(
        height: 8,
      ),
      FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else {
            List<dynamic>? priorityData = snapshot.data;
            String? initialPrioritySelection;
            if (priorityData != null && priorityData.isNotEmpty) {
              initialPrioritySelection = (initialIndex == null)
                  ? priorityData[0]['id'].toString()
                  : priorityData[initialIndex]['id'].toString();
            }
            return DropdownMenu(
              textStyle: const TextStyle(fontSize: 16),
              enabled: enabled,
              width: (!kIsWeb) ? size.width - 48 : size.width - 200,
              enableSearch: true,
              menuHeight: size.height / 2,
              initialSelection: initialPrioritySelection,
              onSelected: onSelected,
              dropdownMenuEntries: priorityData!.map((priority) {
                return DropdownMenuEntry(
                    value: priority['id'].toString(), label: priority['priority']);
              }).toList(),
            );
          }
        },
      ),
    ],
  );
}
