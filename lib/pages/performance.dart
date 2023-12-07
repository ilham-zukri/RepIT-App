import 'package:flutter/material.dart';
import 'package:repit_app/data_classes/performance_data.dart';
import 'package:repit_app/pages/sla_setting.dart';
import 'package:repit_app/widgets/custom_app_bar.dart';
import 'package:repit_app/widgets/performance_card.dart';

import '../services.dart';

class Performance extends StatefulWidget {
  const Performance({super.key});

  @override
  State<Performance> createState() => _PerformanceState();
}

class _PerformanceState extends State<Performance> {
  int page = 0;
  late int lastPage;
  List performanceData = [];
  int performanceDataLength = 0;
  final scrollController = ScrollController();
  bool isLoadingMore = false;

  @override
  void initState() {
    fetchPerformanceData();
    scrollController.addListener(_scrollListener);
    super.initState();
  }

  Future<void> fetchPerformanceData({bool? isRefresh}) async {
    var data = await Services.getPerformances(page: page);
    if (data == null) {
      performanceData += [];
    } else {
      var fetchedPerformanceData = data['data'].map((performance) {
        return PerformanceData(
          period: performance['period'],
          totalTickets: performance['total_tickets'],
          ticketsMeetingRequirement: performance['tickets_meeting_requirements'],
          sla: performance['sla'].toDouble(),
        );
      }).toList();
      if (isRefresh == true) {
        performanceData = fetchedPerformanceData;
      } else {
        performanceData += fetchedPerformanceData;
      }
      setState(() {
        performanceData;
        lastPage = data['meta']['last_page'];
        performanceDataLength = performanceData.length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        context,
        "Performance",
        'setting',
        () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SlaSetting(),
            ),
          );
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: RefreshIndicator(
          onRefresh: () async {},
          child: (performanceDataLength > 0)
              ? ListView.builder(
                  controller: scrollController,
                  itemCount: (isLoadingMore)
                      ? performanceDataLength + 1
                      : performanceDataLength,
                  itemBuilder: (context, index) {
                    if (index < performanceDataLength) {
                      return Column(
                        children: [
                          const SizedBox(
                            height: 16,
                          ),
                          PerformanceCard(
                            performance: performanceData[index],
                          ),
                          if (index == performanceDataLength - 1)
                            const SizedBox(height: 16)
                        ],
                      );
                    }else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ),
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
        await fetchPerformanceData();
        setState(() {
          isLoadingMore = false;
        });
      }
    }
  }
}
