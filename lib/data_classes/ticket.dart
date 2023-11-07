import 'dart:io';

class Ticket {
  final int? id;
  final String title;
  final int categoryId;
  final int assetId;
  final String description;
  final int priorityId;
  final List<File>? images;

  Ticket({
    this.id,
    required this.title,
    required this.categoryId,
    required this.assetId,
    required this.description,
    required this.priorityId,
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