import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:repit_app/widgets/custom_app_bar.dart';
import 'package:repit_app/widgets/custom_text_field_builder.dart';
import 'package:repit_app/widgets/drop_down_builder.dart';
import 'package:repit_app/widgets/loading_overlay.dart';

import '../services.dart';
import '../widgets/alert.dart';

class RegisterSparePartOld extends StatefulWidget {
  const RegisterSparePartOld({super.key});

  @override
  State<RegisterSparePartOld> createState() => _RegisterSparePartOldState();
}

class _RegisterSparePartOldState extends State<RegisterSparePartOld> {
  late Future<List?> types;
  int typeId = 1;
  late EdgeInsets mainPadding;

  TextEditingController brandEc = TextEditingController();
  TextEditingController modelEc = TextEditingController();
  TextEditingController serialNumberEc = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    mainPadding = !kIsWeb
        ? const EdgeInsets.symmetric(horizontal: 24)
        : const EdgeInsets.symmetric(horizontal: 600);
    types = fetchSparePartTypes();
    super.initState();
  }

  Future<List?> fetchSparePartTypes() async {
    final data = await Services.getAllSparePartTypes();
    if (data == null) {
      return [];
    }
    typeId = data.first['id'];
    return data;
  }

  void clearTextFields() {
    brandEc.clear();
    modelEc.clear();
    serialNumberEc.clear();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Scaffold(
          appBar: customAppBar(context, "Register Old Spare Part"),
          body: Padding(
            padding: mainPadding,
            child: Column(
              children: [
                const SizedBox(
                  height: 24,
                ),
                sparePartTypeDropDownBuilder(
                  context,
                  future: types,
                  label: "Tipe",
                  value: typeId,
                  onChange: (value) {
                    setState(() {
                      typeId = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                regularTextFieldBuilder(
                  labelText: "Merk",
                  controller: brandEc,
                  obscureText: false,
                ),
                const SizedBox(
                  height: 16,
                ),
                regularTextFieldBuilder(
                  labelText: "Model",
                  controller: modelEc,
                  obscureText: false,
                ),
                const SizedBox(
                  height: 16,
                ),
                regularTextFieldBuilder(
                  labelText: "Serial Number",
                  controller: serialNumberEc,
                  obscureText: false,
                ),
                const SizedBox(
                  height: 24,
                ),
                SizedBox(
                  width: size.width,
                  height: 41,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (brandEc.text.isEmpty ||
                          modelEc.text.isEmpty ||
                          serialNumberEc.text.isEmpty) {
                        showDialog(
                          context: context,
                          builder: (context) => alert(
                              context, "Error", "Semua kolom harus diisi."),
                        );
                        return;
                      }
                      String brand = brandEc.text.trim();
                      String model = modelEc.text.trim();
                      String serialNumber = serialNumberEc.text.trim();
                      setState(() {
                        isLoading = true;
                      });
                      try {
                        Response? response =
                            await Services.registerOldSparePart(
                          typeId: typeId,
                          brand: brand,
                          model: model,
                          serialNumber: serialNumber,
                        );
                        setState(() {
                          isLoading = false;
                          clearTextFields();
                        });
                        if(mounted){
                          showDialog(
                            context: context,
                            builder: (context) => alert(
                              context,
                              "Berhasil",
                              response!.data['message']
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
                                alert(context, "Error", e.toString()),
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
                    child: const Text('Daftarkan Spare Part'),
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
