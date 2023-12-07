import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:repit_app/widgets/custom_app_bar.dart';
import 'package:repit_app/widgets/custom_text_field_builder.dart';
import 'package:repit_app/widgets/drop_down_builder.dart';
import 'package:repit_app/widgets/loading_overlay.dart';

import '../services.dart';

class SlaSetting extends StatefulWidget {
  const SlaSetting({super.key});

  @override
  State<SlaSetting> createState() => _SlaSettingState();
}

class _SlaSettingState extends State<SlaSetting> {
  final TextEditingController _responseTimeController = TextEditingController();
  final TextEditingController _resolveTimeController = TextEditingController();
  late Future<List> priorities;
  late List prioritiesList;

  late int priorityId;
  bool isEnabled = true;
  bool isLoading = false;

  @override
  void initState() {
    priorities = fetchPriorities();
    super.initState();
  }

  Future<List> fetchPriorities() async {
    final data = await Services.getPriorities();
    if (data == null) {
      return [];
    }
    priorityId = data.last['id'];
    prioritiesList = data;
    setState(() {
      _resolveTimeController.text = data.last['max_resolve_time'].toString();
      _responseTimeController.text = data.last['max_response_time'].toString();
    });
    return data;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Scaffold(
          appBar: customAppBar(context, "SLA Setting"),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 16,
                ),
                priorityDropdownBuilder(
                  context,
                  future: priorities,
                  enabled: isEnabled,
                  initialIndex: 3,
                  size: size,
                  onSelected: (value) {
                    priorityId = int.tryParse(value as String)!;
                    int index = prioritiesList
                        .indexWhere((element) => element['id'] == priorityId);
                    setState(() {
                      _resolveTimeController.text =
                          prioritiesList[index]['max_resolve_time'].toString();
                      _responseTimeController.text =
                          prioritiesList[index]['max_response_time'].toString();
                    });
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    halfSizeTextFieldBuilder(
                      enabled: isEnabled,
                      labelText: "Response Time (Menit)",
                      controller: _responseTimeController,
                      obscureText: false,
                      size: size,
                    ),
                    halfSizeTextFieldBuilder(
                      enabled: isEnabled,
                      labelText: "Resolve Time (Jam)",
                      controller: _resolveTimeController,
                      obscureText: false,
                      size: size,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                  width: size.width / 3,
                  height: 41,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 5,
                      backgroundColor: const Color(0xff00ABB3),
                    ),
                    onPressed: isEnabled ? () async {
                      if (_resolveTimeController.text.isEmpty ||
                          _responseTimeController.text.isEmpty) {
                        showDialog(
                          context: context,
                          builder: (context) => const AlertDialog(
                            content: Text("Field tidak boleh kosong"),
                          ),
                        );
                        return;
                      }
                      int maxResponseTime =
                          int.tryParse(_responseTimeController.text.trim())!;
                      int maxResolveTime =
                          int.tryParse(_resolveTimeController.text.trim())!;
                      setState(() {
                        isLoading = true;
                      });
                      try {
                        Response? response = await Services.updatePriority(
                            priorityId, maxResponseTime, maxResolveTime);
                        setState(() {
                          isEnabled = false;
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
                      }
                    } : null,
                    child: const Text("Perbarui"),
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
