class Ticket {
  final int? id;
  final String? createdBy;
  String? handler;
  final String title;
  final int categoryId;
  final String? category;
  final int? assetId;
  final String description;
  final int priorityId;
  final String? priority;
  String? status;
  String? createdAt;
  String? respondedAt;
  String? resolvedAt;
  String? closedAt;
  final String? location;
  final List? images;

  Ticket({
    this.id,
    this.createdBy,
    this.handler,
    required this.title,
    required this.categoryId,
    this.category,
    this.assetId,
    required this.description,
    required this.priorityId,
    this.priority,
    this.status,
    this.createdAt,
    this.respondedAt,
    this.resolvedAt,
    this.closedAt,
    this.location,
    this.images
  });

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "ticket_category_id": categoryId,
      "asset_id": assetId,
      "description": description,
      "priority_id": priorityId,
      "images": images
    };
  }
}