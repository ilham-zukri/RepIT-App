import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:repit_app/services.dart';
import 'package:repit_app/widgets/alert.dart';
import 'package:repit_app/widgets/custom_app_bar.dart';
import 'package:repit_app/widgets/custom_text_field_builder.dart';
import 'package:repit_app/widgets/drop_down_builder.dart';
import 'package:repit_app/widgets/loading_overlay.dart';
import 'package:url_launcher/url_launcher.dart';


class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final TextEditingController _yearController = TextEditingController();
  bool isLoading = false;
  List<String> months = [
    "Januari",
    "Februari",
    "Maret",
    "April",
    "Mei",
    "Juni",
    "Juli",
    "Agustus",
    "September",
    "Oktober",
    "November",
    "Desember",
  ];
  DateTime now = DateTime.now();
  late String _selectedMonth;
  late Future<List?> locations;
  late int locationId;

  @override
  void initState() {
    locations = fetchLocations();
    super.initState();
  }

  Future<List?> fetchLocations() async {
    final data = await Services.getLocationList();
    if (data == null) {
      return [];
    }
    locationId = data[0]['id'];
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: customAppBar(context, "Reporting"),
          body: Center(
            child: Card(
              elevation: 4,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                Radius.circular(10),
              )),
              child: Container(
                width: 525,
                height: 250,
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text("Pilih Jenis Report",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            showLocationDialog();
                          },
                          child: Container(
                            width: 150,
                            height: 150,
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                                color: Color(0xff00ABB3),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                )),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  CupertinoIcons.cube_box,
                                  size: 100,
                                  color: Colors.white,
                                ),
                                Text(
                                  "Assets",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            showPeriodDialog(usage: "purchases");
                          },
                          child: Container(
                            width: 150,
                            height: 150,
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                                color: Color(0xff00ABB3),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                )),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  CupertinoIcons.creditcard,
                                  size: 100,
                                  color: Colors.white,
                                ),
                                Text(
                                  "Purchase",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            showPeriodDialog(usage: "tickets");
                          },
                          child: Container(
                            width: 150,
                            height: 150,
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                                color: Color(0xff00ABB3),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                )),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  CupertinoIcons.ticket,
                                  size: 100,
                                  color: Colors.white,
                                ),
                                Text(
                                  "Tickets",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        loadingOverlay(isLoading, context)
      ],
    );
  }

  void showPeriodDialog({required String usage}) {
    String type = usage == "tickets" ? "Tiket" : "Pembelian";
    Size size = MediaQuery.of(context).size;
    String year = now.year.toString();
    _yearController.text = year;
    _selectedMonth = months[now.month - 1];
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              scrollable: true,
              title: Text("Pilih Periode Laporan $type"),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  halfSizeTextFieldBuilder(
                      labelText: "Tahun",
                      controller: _yearController,
                      obscureText: false,
                      size: size / 5),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 41,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54, width: 1),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              isExpanded: true,
                              value: _selectedMonth,
                              items: months.map((data) {
                                return DropdownMenuItem(
                                  value: data,
                                  child: Text(data),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedMonth = value.toString();
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffF05050),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                  child: const Text("Batal"),
                ),
                ElevatedButton(
                  onPressed: () {
                    int selectedMonthNumber =
                        months.indexOf(_selectedMonth) + 1;
                    String selectedMonthNumberStr = (selectedMonthNumber < 10)
                        ? "0$selectedMonthNumber"
                        : "$selectedMonthNumber";
                    String date =
                        "${_yearController.text}-$selectedMonthNumberStr";
                    requestMonthlyReport(date: date, usage: usage);

                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff00ABB3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                  child: const Text("Export"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> requestMonthlyReport(
      {required String usage, required String date}) async {
    late String downloadUrl;
    setState(() {
      isLoading = true;
    });
    try {
      Map? responseData = await Services.exportMonthlyReport(usage, date);
      setState(() {
        isLoading = false;
      });
      downloadUrl = "${Services.url}/${responseData!['path']}";
      showDownloadDialog(downloadUrl: downloadUrl);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => alert(
            context,
            "Peringatan",
            e.toString(),
          ),
        );
      }
    }
  }



  void showLocationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              scrollable: true,
              title: const Text("Pilih Lokasi"),
              content: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: locationDropdownButtonBuilder(
                      context,
                      future: locations,
                      label: "location",
                      value: locationId,
                      onChange: (value) {
                        setState(() {
                          locationId = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        showExportAllLocationDialog();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff00ABB3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text("Semua Lokasi"),
                    ),
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffF05050),
                  ),
                  child: const Text("Batal"),
                ),
                ElevatedButton(
                  onPressed: () {
                    requestAssetReport(locationId);
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff00ABB3),
                  ),
                  child: const Text("Export"),
                )
              ],
              actionsAlignment: MainAxisAlignment.center,
            );
          },
        );
      },
    );
  }

  void showExportAllLocationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Apakah Anda yakin?"),
        content: const Text(
            "Apakah anda yakin ingin export data asset dari semua lokasi? \nProses ini akan memakan waktu yang lama."),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xffF05050),
            ),
            child: const Text("Tidak"),
          ),
          ElevatedButton(
            onPressed: () {
              requestAssetReport(null);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff00ABB3),
            ),
            child: const Text("Ya"),
          )
        ],
      ),
    );
  }

  Future<void> requestAssetReport(int? locationId) async {
    setState(() {
      isLoading = true;
    });
    try {
      Map? responseData = await Services.exportAssetReport(locationId: locationId);
      setState(() {
        isLoading = false;
      });
      String downloadUrl = "${Services.url}/${responseData!['path']}";
      showDownloadDialog(downloadUrl: downloadUrl);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => alert(
            context,
            "Peringatan",
            e.toString(),
          ),
        );
      }
    }
  }

  void showDownloadDialog({required String downloadUrl}) {
    Uri parsedUrl = Uri.parse(downloadUrl);
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Export Berhasil"),
        content: const Text("Unduh berkas export"),
        actions: [
          ElevatedButton(
            onPressed: () async {
              _launchUrl(parsedUrl);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff00ABB3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                )),
            child: const Text("Ok"),
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw Exception('Could not launch $url');
    }
  }
}
