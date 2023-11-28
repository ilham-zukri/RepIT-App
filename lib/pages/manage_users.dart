import 'package:flutter/material.dart';
import 'package:repit_app/pages/add_user.dart';
import 'package:repit_app/widgets/custom_app_bar.dart';
import 'package:repit_app/widgets/user_card.dart';

import '../data_classes/user.dart';
import '../services.dart';

class ManageUsers extends StatefulWidget {
  const ManageUsers({super.key});

  @override
  State<ManageUsers> createState() => _ManageUsersState();
}

class _ManageUsersState extends State<ManageUsers> {
  bool isLoading = false;
  int page = 1;
  late int lastPage;
  String? searchParam;
  final scrollController = ScrollController();
  bool isLoadingMore = false;
  List users = [];
  int usersLength = 0;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    scrollController.addListener(_scrollListener);
    fetchUsers();
    super.initState();
  }

  Future<void> fetchUsers({bool? isRefresh}) async {
    var data = await Services.getUsers(page, searchParam);
    if (data == null) {
      users += [];
    } else {
      List<User> fetchedUsers = data['data'].map<User>((user) {
        return User(
          id: user['id'],
          userName: user['user_name'],
          fullName: user['full_name'],
          empNumber: user['employee_id'],
          email: user['email'],
          role: user['role'],
          branch: user['branch'],
          department: user['department'],
          createdAt: user['created_at'],
          active: user['active'],
          token: null,
        );
      }).toList();
      if (isRefresh == true) {
        users = fetchedUsers;
      } else {
        users += fetchedUsers;
      }
      setState(() {
        users;
        usersLength = users.length;
        lastPage = data['meta']['last_page'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        context,
        "Manage Users",
        'add',
        () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddUser(),
            ),
          );
        },
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: (usersLength > 0)
                ? RefreshIndicator(
                    onRefresh: () async {
                      page = 1;
                      await fetchUsers(isRefresh: true);
                    },
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount:
                          (isLoadingMore) ? usersLength + 1 : usersLength,
                      itemBuilder: (context, index) {
                        if (index < usersLength) {
                          return Column(
                            children: [
                              if (index == 0)
                                const SizedBox(
                                  height: 68,
                                ),
                              const SizedBox(
                                height: 16,
                              ),
                              UserCard(
                                user: users[index],
                              ),
                              (index == usersLength - 1)
                                  ? const SizedBox(height: 16)
                                  : const SizedBox.shrink(),
                            ],
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(
                  height: 16,
                ),
                SearchBar(
                  elevation: const MaterialStatePropertyAll<double>(4.0),

                  padding: const MaterialStatePropertyAll<EdgeInsets>(
                      EdgeInsets.symmetric(horizontal: 16.0)),
                  controller: searchController,
                  onChanged: (value) async {
                    setState(() {
                      searchParam = value;
                    });
                    await fetchUsers(isRefresh: true);
                  },
                  leading: const Icon(Icons.search),
                  hintText: "Cari username, nama lengkap dan nomor karyawan",
                  hintStyle: const MaterialStatePropertyAll<TextStyle>(
                    TextStyle(color: Colors.black54),
                  ),
                  trailing: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () async {
                        setState(() {
                          searchController.clear();
                          searchParam = null;
                        });
                        await fetchUsers(isRefresh: true);
                      },
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> _scrollListener() async {
    if (isLoadingMore) return;
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (page < lastPage) {
        setState(() {
          isLoadingMore = true;
        });
        page++;
        await fetchUsers();
        setState(() {
          isLoadingMore = false;
        });
      }
    }
  }
}
