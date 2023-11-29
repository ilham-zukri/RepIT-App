import 'package:flutter/material.dart';
import 'package:repit_app/widgets/custom_app_bar.dart';
import 'package:repit_app/widgets/drop_down_builder.dart';

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
  late int locationId;
  late Future<List<DepartmentForList>> departments;
  late int departmentId;
  late Future<List<UserForList>> users;
  late String userId;

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
    return data.map((item) {
      return DepartmentForList(id: item['id'], department: item['department']);
    }).toList();
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

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: customAppBar(context, "Transfer Asset"),
      body: Padding(
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
              future: locations,
              size: size,
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
              onSelected: (value) {
                setState(() {
                  departmentId = int.parse(value as String);
                });
              },
            ),
            const SizedBox(
              height: 16,
            ),
            userDropdownBuilder(
              context,
              future: users,
              size: size,
              onSelected: (value) {
                setState(() {
                  userId = value;
                });
              },
            ),
            const SizedBox(
              height: 24,
            ),
            SizedBox(
              width: size.width,
              height: 41,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff00ABB3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  )
                ),
                child: const Text("Pindahkan"),
              )
            )
          ],
        ),
      ),
    );
  }
}
