class SparePartRequest {
  final int id;
  final String title;
  final String description;
  String status;
  String requester;
  final String createdAt;
  final String? approvedAt;

  SparePartRequest({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.requester,
    required this.createdAt,
    this.approvedAt,
  });
}
