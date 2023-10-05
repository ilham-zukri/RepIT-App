class AssetRequest {
  final int id;
  final String priority;
  String status;
  final String createdAt;
  final String title;
  final String description;
  final String forUser;
  final String location;
  final String requester;
  String? approvedAt;

  AssetRequest(
      this.id,
      this.priority,
      this.createdAt,
      this.title,
      this.description,
      this.forUser,
      this.location,
      this.requester,
      {required this.status});

}