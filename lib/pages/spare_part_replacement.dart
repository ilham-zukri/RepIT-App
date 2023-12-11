import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:repit_app/widgets/alert.dart';
import 'package:repit_app/widgets/custom_app_bar.dart';
import 'package:repit_app/widgets/drop_down_builder.dart';
import 'package:repit_app/widgets/loading_overlay.dart';
import 'package:repit_app/widgets/spare_part_card.dart';

import '../data_classes/spare_part.dart';
import '../services.dart';

class SparePartReplacement extends StatefulWidget {
  final int assetId;

  const SparePartReplacement({super.key, required this.assetId});

  @override
  State<SparePartReplacement> createState() => _SparePartReplacementState();
}

class _SparePartReplacementState extends State<SparePartReplacement> {
  late Future<List?> types;
  late int typeId;
  int page = 1;
  late int lastPage;
  List spareParts = [];
  int sparePartsLength = 0;
  final scrollController = ScrollController();
  bool isLoadingMore = false;
  List selectedSpareParts = [];
  int selectedSparePartsLength = 0;
  List<int> selectedSparePartsIds = <int>[];
  bool isLoading = false;
  late EdgeInsets mainPadding;

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    mainPadding = !kIsWeb
        ? const EdgeInsets.all(24)
        : const EdgeInsets.symmetric(horizontal: 600, vertical: 24);
    scrollController.addListener(_scrollListener);
    types = fetchSparePartTypes();
    super.initState();
  }

  Future<void> fetchSpareParts({bool isRefresh = false}) async {
    var data = await Services.getAllSpareParts(
        page: page, typeId: typeId, statusId: 1);
    if (data == null) {
      spareParts += [];
    } else {
      List<SparePart> fetchedSpareParts =
          data['data'].map<SparePart>((sparePart) {
        return SparePart(
          id: sparePart['id'],
          type: sparePart['type'],
          purchaseId: sparePart['purchase_id'],
          brand: sparePart['brand'],
          model: sparePart['model'],
          qrPath: sparePart['qr_path'],
          serialNumber: sparePart['serial_number'],
          status: sparePart['status'],
          assetId: sparePart['device_id'],
          createdAt: sparePart['created_at'],
        );
      }).toList();
      if (isRefresh) {
        spareParts = fetchedSpareParts;
      } else {
        spareParts += fetchedSpareParts;
      }
      setState(() {
        spareParts;
        sparePartsLength = spareParts.length;
        lastPage = data['meta']['last_page'];
      });
    }
  }

  Future<List?> fetchSparePartTypes() async {
    final data = await Services.getSparePartTypes();
    if (data == null) {
      return [];
    }
    typeId = data.first['id'];
    return data;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Scaffold(
          appBar: customAppBar(context, "Spare Part Replacement", 'spare_parts',
              () {
            showAddSparePartDialog(context);
          }),
          body: Padding(
            padding: mainPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "No. Asset: ${widget.assetId}",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 16),
                  height: size.height / 1.4,
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.black26),
                      bottom: BorderSide(color: Colors.black26),
                    ),
                  ),
                  child: Column(
                    children: [
                      if (selectedSparePartsLength > 0)
                        Expanded(
                          child: ListView.builder(
                            itemCount: selectedSparePartsLength,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  SparePartCard(
                                    sparePart: selectedSpareParts[index],
                                    withDetail: false,
                                  ),
                                  (index < selectedSparePartsLength - 1)
                                      ? const SizedBox.shrink()
                                      : const SizedBox(
                                          height: 8,
                                        ),
                                ],
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                  width: size.width,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff009199),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      elevation: 5,
                    ),
                    onPressed: () async {
                      if (selectedSpareParts.isEmpty) {
                        showDialog(
                          context: context,
                          builder: (context) => alert(
                              context,
                              "Pilih Spare Part",
                              "Anda harus memilih minimal 1 spare parts"),
                        );
                        return;
                      }
                      try {
                        setState(() {
                          isLoading = true;
                        });
                        Response? response =
                            await Services.registerSparePartToAsset(
                                assetId: widget.assetId,
                                sparePartsIds: selectedSparePartsIds);
                        setState(() {
                          isLoading = false;
                        });
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: const Color(0xff00ABB3),
                              content: Text(
                                response!.data['message'],
                                style: const TextStyle(color: Colors.white),
                              )));
                          Navigator.pop(context);
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
                    child: const Text('Ganti Spare Part'),
                  ),
                ),
              ],
            ),
          ),
        ),
        loadingOverlay(isLoading, context),
      ],
    );
  }

  void showAddSparePartDialog(BuildContext context) async {
    Size size = MediaQuery.of(context).size;
    try {
      await fetchSpareParts(isRefresh: true);
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => alert(context, "Error", e.toString()),
        );
      }
      return;
    }
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return Dialog(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  height: 400,
                  width: size.width,
                  child: Column(
                    children: [
                      sparePartTypeDropDownBuilder(
                        context,
                        future: types,
                        label: "Jenis Spare Part*",
                        value: typeId,
                        onChange: (value) async {
                          setState(() {
                            spareParts = [];
                            sparePartsLength = 0;
                            typeId = value;
                          });
                          await fetchSpareParts(
                            isRefresh: true,
                          ); // Memanggil fetchSpareParts setelah perubahan typeId
                          setState(() {
                            page = 1;
                            spareParts;
                            sparePartsLength = spareParts.length;
                          });
                        },
                      ),
                      Expanded(
                        child: (sparePartsLength != 0)
                            ? ListView.builder(
                                controller: scrollController,
                                itemCount:
                                    sparePartsLength + (isLoadingMore ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if (index < sparePartsLength) {
                                    return Column(children: [
                                      const SizedBox(
                                        height: 16,
                                      ),
                                      SparePartCard(
                                        sparePart: spareParts[index],
                                        withDetail: true,
                                        additionalAction: () {
                                          addSelectedSparePart(
                                            spareParts[index],
                                          );
                                          Navigator.pop(context);
                                        },
                                      ),
                                      (index == sparePartsLength - 1)
                                          ? const SizedBox(height: 16)
                                          : const SizedBox.shrink(),
                                    ]);
                                  } else {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                },
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
    }
  }

  void addSelectedSparePart(SparePart sparePart) {
    setState(() {
      selectedSpareParts.add(sparePart);
      selectedSparePartsLength = selectedSpareParts.length;
    });
    selectedSparePartsIds.add(sparePart.id!);
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
        await fetchSpareParts();
        setState(() {
          isLoadingMore = false;
        });
      }
    }
  }
}
