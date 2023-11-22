import 'package:flutter/material.dart';
import 'package:repit_app/widgets/custom_text_field_builder.dart';

import '../services.dart';
import '../widgets/alert.dart';
import '../widgets/custom_app_bar.dart';

class SparePartRequestForm extends StatefulWidget {
  const SparePartRequestForm({super.key});

  @override
  State<SparePartRequestForm> createState() => _SparePartRequestFormState();
}

class _SparePartRequestFormState extends State<SparePartRequestForm> {
  TextEditingController titleEc = TextEditingController();
  TextEditingController descEc = TextEditingController();
  bool isLoading = false;
  bool isButtonDisabled = false;

  @override
  void dispose() {
    titleEc.dispose();
    descEc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Scaffold(
          appBar: customAppBar(context, "Request Spare Part"),
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(children: [
              regularTextFieldBuilder(
                labelText: "Judul*",
                controller: titleEc,
                obscureText: false,
              ),
              const SizedBox(
                height: 24,
              ),
              descriptionTextFieldBuilder(
                  labelText: "Deskripsi*", controller: descEc),
              const SizedBox(
                height: 24,
              ),
              SizedBox(
                width: size.width,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff00ABB3),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      elevation: 5),
                  onPressed: (!isButtonDisabled)
                      ? () async {
                          if (titleEc.text.trim().isEmpty ||
                              descEc.text.trim().isEmpty) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => alert(
                                context,
                                'Lengkapi form',
                                'Judul dan Deskripsi tidak boleh kosong',
                              ),
                            );
                            return;
                          }
                          Map<String, dynamic> data = {
                            'title': titleEc.text,
                            'description': descEc.text
                          };
                          try {
                            setState(() {
                              isLoading = true;
                            });
                            var response =
                                await Services.createSparePartRequest(data);
                            setState(() {
                              isLoading = false;
                              isButtonDisabled = true;
                            });
                            if (mounted) {
                              showDialog(
                                  context: context,
                                  builder: (context) => alert(context,
                                      "Berhasil", response!.data['message']));
                            }
                          } catch (e) {
                            setState(() {
                              isLoading = false;
                            });
                            if (mounted) {
                              showDialog(
                                  context: context,
                                  builder: (context) =>
                                      alert(context, "Error", e.toString()));
                            }
                          }
                        }
                      : null,
                  child: const Text(
                    "Kirim",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              )
            ]),
          ),
        ),
      ],
    );
  }
}
