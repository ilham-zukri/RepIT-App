import 'dart:io';

class Ticket {
  final int? id;
  final String? createdBy;
  final String? handler;
  final String title;
  final int categoryId;
  final int? assetId;
  final String description;
  final int priorityId;
  String? status;
  final String? location;
  final List<File>? images;

  Ticket({
    this.id,
    this.createdBy,
    this.handler,
    required this.title,
    required this.categoryId,
    this.assetId,
    required this.description,
    required this.priorityId,
    this.status,
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