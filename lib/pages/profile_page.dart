import 'package:flutter/material.dart';
import 'package:repit_app/data_classes/user.dart';
import 'package:repit_app/pages/login_page.dart';
import 'package:repit_app/services.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, this.userData}) : super(key: key);
  final User? userData;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  late User userData;

  @override
  void initState() {
    userData = widget.userData!;
    super.initState();
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 32, bottom: 16),
                  child: Stack(
                    children: [
                      const CircleAvatar(
                        foregroundColor: Color(0xff00ABB3),
                        minRadius: 80,
                        child: Icon(
                          Icons.person_rounded,
                          size: 80,
                          color: Colors.white,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: -25,
                        child: RawMaterialButton(
                          onPressed: () {},
                          elevation: 2.0,
                          fillColor: const Color(0xfff5f6f9),
                          padding: const EdgeInsets.all(5),
                          shape: const CircleBorder(),
                          child: const Icon(Icons.image),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                            top: 24, left: 24, bottom: 24, right: 16),
                        child: const Icon(Icons.person_rounded),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Username',
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            userData.userName as String,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 16),
                    child: IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: TextField(
                                    decoration: const InputDecoration(
                                      hintText: "Masukan username baru",
                                    ),
                                    controller: usernameController,
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xff00ABB3),
                                      ),
                                      child: const Text("Batal"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        try {
                                          await Services.changeUsername(
                                            usernameController.text.toString(),
                                          );
                                          var token =
                                              Services.prefs.getString("token");
                                          await Services.logout(token!);

                                          if (mounted) {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    content: const Text(
                                                        "silahkan login ulang"),
                                                    title: const Text(
                                                        "username berhasil diubah"),
                                                    actions: [
                                                      ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.pushReplacement(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) {
                                                              return LoginPage();
                                                            }));
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                const Color(
                                                                    0xff00ABB3),
                                                          ),
                                                          child:
                                                              const Text("OK")),
                                                    ],
                                                  );
                                                });
                                          }
                                        } catch (e) {
                                          if (mounted) {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                      content:
                                                          Text(e.toString()));
                                                });
                                          }
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xff00ABB3),
                                      ),
                                      child: const Text("Ubah"),
                                    ),
                                    const SizedBox(
                                      width: 6,
                                    )
                                  ],
                                );
                              });
                        },
                        icon: const Icon(Icons.edit)),
                  ),
                ],
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                            top: 24, left: 24, bottom: 24, right: 16),
                        child: const Icon(Icons.email),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Email',
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            userData.email ?? '#N/A',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 16),
                    child: IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: TextField(
                                    decoration: const InputDecoration(
                                      hintText: "Masukan email baru",
                                    ),
                                    controller: emailController,
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xff00ABB3),
                                      ),
                                      child: const Text("Batal"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        try {
                                          await Services.changeEmail(
                                              emailController.text.toString());
                                          if (mounted) {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        "email berhasil diubah"),
                                                    content: const Text(
                                                        "perubahan akan terlihat setelah login ulang"),
                                                    actions: [
                                                      ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                const Color(
                                                                    0xff00ABB3),
                                                          ),
                                                          child:
                                                              const Text("OK"))
                                                    ],
                                                  );
                                                });
                                          }
                                        } catch (e) {
                                          if (mounted) {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                      content:
                                                          Text(e.toString()));
                                                });
                                          }
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xff00ABB3),
                                      ),
                                      child: const Text("Ubah"),
                                    ),
                                    const SizedBox(
                                      width: 6,
                                    )
                                  ],
                                );
                              });
                        },
                        icon: const Icon(Icons.edit)),
                  ),
                ],
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey))),
              child: Row(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                            top: 24, left: 24, bottom: 24, right: 16),
                        child: const Icon(Icons.home_work),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Branch',
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            userData.branch ?? "#N/A",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey))),
              child: Row(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                            top: 24, left: 24, bottom: 24, right: 16),
                        child: const Icon(Icons.work),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Department',
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            userData.department ?? "#N/A",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey))),
              child: Row(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                            top: 24, left: 24, bottom: 24, right: 16),
                        child: const Icon(Icons.accessibility),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Role',
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            userData.role['role_name'] ?? "#N/A",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
