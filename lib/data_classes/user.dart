class User {
  String? id;
  String? email;
  String? userName;
  String? fullName;
  String? empNumber;
  String? branch;
  String? department;
  String? createdAt;
  int? active;
  Map<String, dynamic> role;
  final String? _token;

  User(
      {required this.userName,
      this.fullName,
      this.empNumber,
      required token,
      this.email,
      this.id,
      this.branch,
      this.department,
      this.createdAt,
      this.active,
      required this.role})
      : _token = token;

  get token => _token;
}
