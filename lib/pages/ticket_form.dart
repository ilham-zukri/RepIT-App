import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:repit_app/data_classes/ticket.dart';
import 'package:repit_app/services.dart';
import 'package:repit_app/widgets/alert.dart';
import 'package:repit_app/widgets/custom_app_bar.dart';

import '../widgets/loading_overlay.dart';

class TicketForm extends StatefulWidget {
  const TicketForm({Key? key}) : super(key: key);

  @override
  State<TicketForm> createState() => _TicketFormState();
}

class _TicketFormState extends State<TicketForm> {
  final TextEditingController titleEc = TextEditingController();
  final TextEditingController descEc = TextEditingController();
  late int priorityId;
  late Future<List?> prioritiesList;
  int categoryId = 1;
  late Future<List> categoriesList;
  late int assetId;
  late Future<List> assetList;
  List<File> images = [];
  bool isLoading = false;
  bool isDisabled = false;

  late String hintText;
  late String descHintText;

  @override
  void initState() {
    super.initState();
    prioritiesList = fetchPriorities();
    categoriesList = fetchCategories();
    assetList = fetchAssetList();
  }

  @override
  void dispose() {
    titleEc.dispose();
    descEc.dispose();
    super.dispose();
  }

  Future<List> fetchCategories() async {
    final data = await Services.getTicketCategories();
    if (data == null) {
      return [];
    }
    categoryId = data.first['id'];
    return data;
  }

  Future<List> fetchAssetList() async {
    final data = await Services.getAssetList();
    if (data == null) {
      return [];
    }
    assetId = data.first['id'];
    return data;
  }

  Future<List> fetchPriorities() async {
    final data = await Services.getPriorities();
    if (data == null) {
      return [];
    }
    priorityId = data.last['id'];
    return data;
  }

  @override
  Widget build(BuildContext context) {
    hintText = (categoryId == 1) ? 'Komputer lamban' : 'Tidak bisa login';
    descHintText = (categoryId == 1) ? 'Komputer Lamban saat buka aplikasi tertentu' : 'Tidak bisa login ke sistem';
    var size = MediaQuery.of(context).size;
    return Stack(children: [
      Scaffold(
        appBar: customAppBar(context, 'Buat Tiket'),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(right: 24, left: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 24,
                ),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Judul*",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  height: 41,
                  child: TextField(
                    controller: titleEc,
                    decoration: InputDecoration(
                      enabled: !isDisabled,
                      hintText: hintText,
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
                  height: 24,
                ),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Kategori",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                FutureBuilder(
                  future: categoriesList,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else {
                      List? categories = snapshot.data;
                      return DecoratedBox(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black54, width: 1),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              isExpanded: true,
                              value: categoryId,
                              items: categories!.map((category) {
                                return DropdownMenuItem(
                                    value: category['id'],
                                    child: Text(category['category']));
                              }).toList(),
                              onChanged: !isDisabled ? (value) {
                                setState(() {
                                  categoryId =
                                      int.tryParse(value.toString()) as int;

                                });
                              }: null,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
                (categoryId == 1)
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 24,
                          ),
                          const Text(
                            "Aset",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          FutureBuilder(
                            future: assetList,
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                if(snapshot.data == null){
                                  return const Center(
                                    child: Text(
                                      "Belum ada aset yang dimiliki",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                }
                                return Center(
                                  child: Text(
                                    snapshot.error.toString(),
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              } else if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else {
                                List? assets = snapshot.data;
                                return DecoratedBox(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.black54, width: 1),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                        isExpanded: true,
                                        value: assetId,
                                        items: assets!.map((asset) {
                                          return DropdownMenuItem(
                                            value: asset['id'],
                                            child: Row(
                                              children: [
                                                Text(asset['id'].toString()),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                Text(asset['model']),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: !isDisabled ? (value) {
                                          setState(() {
                                            assetId =
                                                int.tryParse(value.toString())
                                                    as int;
                                          });
                                        } : null,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
                const SizedBox(
                  height: 24,
                ),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Deskripsi*",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  height: 112,
                  child: TextField(
                    enabled: !isDisabled,
                    maxLines: 100,
                    controller: descEc,
                    decoration: InputDecoration(
                      hintText: descHintText,
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
                  height: 24,
                ),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Prioritas",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
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
                            border: Border.all(color: Colors.black54, width: 1),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              isExpanded: true,
                              value: priorityId,
                              items: priorities!.map((priority) {
                                return DropdownMenuItem(
                                    value: priority['id'],
                                    child: Text(priority['priority']));
                              }).toList(),
                              onChanged: !isDisabled ? (value) {
                                setState(() {
                                  priorityId =
                                      int.tryParse(value.toString()) as int;
                                });
                              } : null,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
                (images.isNotEmpty)
                    ? Container(
                        margin: const EdgeInsets.only(top: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Gambar",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: images.map((image) {
                                return Row(
                                  children: [
                                    IconButton(
                                      iconSize: 50,
                                      padding: EdgeInsets.zero,
                                      onPressed: () {
                                        previewImage(image);
                                      },
                                      icon: Image.file(
                                        image,
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    (images.indexOf(image) ==
                                                images.length - 1 &&
                                            images.length < 5)
                                        ? Container(
                                            margin:
                                                const EdgeInsets.only(left: 8),
                                            child: IconButton(
                                              onPressed: !isDisabled ? () {
                                                setState(() {
                                                  _pickImage();
                                                });
                                              } : null,
                                              icon:
                                                  const Icon(Icons.add_a_photo),
                                            ),
                                          )
                                        : const SizedBox(
                                            width: 8,
                                          )
                                  ],
                                );
                              }).toList(),
                            )
                          ],
                        ),
                      )
                    : Container(
                        margin: const EdgeInsets.only(top: 30),
                        height: 41,
                        width: size.width,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff00ABB3),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                              elevation: 5),
                          onPressed: !isDisabled ? () async {
                            await _pickImage();
                          } : null,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 20,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                "Ambil Gambar",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                Container(
                  margin: const EdgeInsets.only(top: 26),
                  height: 41,
                  width: size.width,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff00ABB3),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                        elevation: 5),
                    onPressed: !isDisabled ? () async {
                      if (titleEc.text.isEmpty || descEc.text.isEmpty) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => alert(
                            context,
                            'Lengkapi form',
                            'Judul dan Deskripsi tidak boleh kosong',
                          ),
                        );
                      }
                      String description = descEc.text.trim();
                      String title = titleEc.text.trim();
                      Ticket ticket = Ticket(
                          title: title,
                          categoryId: categoryId,
                          assetId: (categoryId == 1) ? assetId : null,
                          description: description,
                          priorityId: priorityId,
                          images: (images.isNotEmpty) ? images : null);

                      try {
                        setState(() {
                          isLoading = true;
                        });
                        var response = await Services.createTicket(ticket);
                        setState(() {
                          isLoading = false;
                          isDisabled = true;
                        });
                        if (mounted) {
                          showDialog(
                              context: context,
                              builder: (context) => alert(
                                    context,
                                    "Berhasil",
                                    response!.data['message'],
                                  ));
                        }
                      } catch (e) {
                        setState(() {
                          isLoading = false;
                        });
                        if (mounted) {
                          await showDialog(
                            context: context,
                            builder: (BuildContext context) => alert(
                              context,
                              'Error',
                              e.toString(),
                            ),
                          );
                        }
                      }
                    } : null,
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
      ),
      loadingOverlay(isLoading, context)
    ]);
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        images.add(File(image.path));
      });
    }
  }

  void previewImage(File image) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: const Text("Preview Image"),
            content: Image.file(
              image,
              width: 400,
              height: 400,
              fit: BoxFit.cover,
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    images.remove(image);
                  });
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffF05050),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 5),
                child: const Text("Hapus"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff00ABB3),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 5),
                child: const Text("Tutup"),
              ),
            ]);
      },
    );
  }
}
