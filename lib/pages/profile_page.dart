import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:repit_app/data_classes/user.dart';
import 'package:repit_app/pages/advanced_user_menu.dart';
import 'package:repit_app/services.dart';
import 'package:repit_app/widgets/alert.dart';
import 'package:repit_app/widgets/custom_text_field_builder.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, this.userData, required this.withAdvancedMenu})
      : super(key: key);
  final User? userData;
  final bool withAdvancedMenu;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController rePasswordController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();
  late String status;

  late User userData;

  @override
  void initState() {
    userData = widget.userData!;
    status = (userData.active == 1) ? 'Active' : 'Inactive';
    super.initState();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    passwordController.dispose();
    rePasswordController.dispose();
    oldPasswordController.dispose();
    usernameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Profile'),
        actions: [
          if (widget.withAdvancedMenu)
            IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdvancedUserMenu(
                      userData: userData,
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons.manage_accounts,
                size: 32,
              ),
            ),
          const SizedBox(
            width: 8,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 16, bottom: 16),
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
                                          Response? response =
                                              await Services.changeUsername(
                                            usernameController.text.toString(),
                                            userData.id!,
                                          );
                                          if (mounted) {
                                            Navigator.pop(context);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                backgroundColor:
                                                    const Color(0xff00ABB3),
                                                content: Text(
                                                  response!.data['message'],
                                                ),
                                              ),
                                            );
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
                        child:
                            const Icon(CupertinoIcons.person_alt_circle_fill),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Nama Lengkap',
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            userData.fullName != null
                                ? userData.fullName!
                                : '#N/A',
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
                                      hintText: "Masukan nama lengkap",
                                    ),
                                    controller: fullNameController,
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
                                          Response? response =
                                              await Services.changeFullName(
                                            fullNameController.text
                                                .trim()
                                                .toString(),
                                            userData.id.toString(),
                                          );
                                          setState(() {
                                            userData.fullName =
                                                fullNameController.text.trim();
                                          });
                                          if (mounted) {
                                            Navigator.pop(context);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    backgroundColor:
                                                        const Color(0xff00ABB3),
                                                    content: Text(
                                                      response!.data['message'],
                                                    )));
                                          }
                                        } catch (e) {
                                          if (mounted) {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                    content:
                                                        Text(e.toString()));
                                              },
                                            );
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
                                          Response? response =
                                              await Services.changeEmail(
                                            emailController.text.toString(),
                                            userData.id.toString(),
                                          );
                                          setState(() {
                                            userData.email =
                                                emailController.text.toString();
                                          });
                                          if (mounted) {
                                            Navigator.pop(context);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    backgroundColor:
                                                        const Color(0xff00ABB3),
                                                    content: Text(
                                                      response!.data['message'],
                                                    )));
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
            if (widget.withAdvancedMenu)
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
                          child: const Icon(Icons.info),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Status',
                              style: TextStyle(fontSize: 14),
                            ),
                            Text(
                              status,
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
            const SizedBox(
              height: 24,
            ),
            SizedBox(
              width: size.width - 48,
              height: 41,
              child: ElevatedButton(
                onPressed: () async {
                  if (widget.withAdvancedMenu) {
                    showResetPasswordDialog(context);
                  } else {
                    showChangePasswordDialog(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor: (!widget.withAdvancedMenu)
                      ? const Color(0xff00ABB3)
                      : const Color(0xff2F546E),
                ),
                child: (!widget.withAdvancedMenu)
                    ? const Text("Ganti Password")
                    : const Text("Reset Password"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showChangePasswordDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              scrollable: true,
              content: Column(
                children: [
                  regularTextFieldBuilder(
                    labelText: "Password Lama*",
                    controller: oldPasswordController,
                    obscureText: true,
                  ),
                  regularTextFieldBuilder(
                    labelText: "Password Baru",
                    controller: passwordController,
                    obscureText: true,
                  ),
                  regularTextFieldBuilder(
                    labelText: "Ulangi Password Baru",
                    controller: rePasswordController,
                    obscureText: true,
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      oldPasswordController.clear();
                      passwordController.clear();
                      rePasswordController.clear();
                    });
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffF05050),
                  ),
                  child: const Text("Batal"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (passwordController.text != rePasswordController.text) {
                      showDialog(
                        context: context,
                        builder: (context) =>
                            alert(context, "Error", "Password baru tidak sama"),
                      );
                      return;
                    }
                    try {
                      Response? response = await Services.changePassword(
                        userData.id!,
                        passwordController.text,
                        oldPasswordController.text,
                      );
                      setState(() {
                        oldPasswordController.clear();
                        passwordController.clear();
                        rePasswordController.clear();
                      });
                      if (mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              response!.data['message'],
                            ),
                          ),
                        );
                      }
                    } catch (e) {
                      if (mounted) {
                        showDialog(
                          context: context,
                          builder: (context) =>
                              alert(context, "Error", e.toString()),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff00ABB3),
                  ),
                  child: const Text("Ubah"),
                ),
              ]);
        });
  }

  void showResetPasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            scrollable: true,
            title: const Text(
              "Reset Password",
            ),
            content: regularTextFieldBuilder(
              labelText: "Password*",
              controller: passwordController,
              obscureText: true,
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    passwordController.clear();
                  });
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffF05050),
                ),
                child: const Text("Batal"),
              ),
              ElevatedButton(
                onPressed: () async {
                  String newPassword = passwordController.text;
                  String userId = userData.id!;
                  try {
                    Response? response = await Services.resetPassword(
                      userId,
                      newPassword,
                    );
                    setState(() {
                      passwordController.clear();
                    });
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: const Color(0xff00ABB3),
                          content: Text(response!.data['message']),
                        ),
                      );
                    }
                  } catch (e) {
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
                ),
                child: const Text("Reset"),
              ),
            ]);
      },
    );
  }
}
