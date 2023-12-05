class PerformanceData {
  final String period;
  final int totalTickets;
  final int ticketsMeetingRequirement;
  final double sla;

  PerformanceData({
    required this.period,
    required this.totalTickets,
    required this.ticketsMeetingRequirement,
    required this.sla,
  });
}
