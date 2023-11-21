class User {
  String? id;
  String? email;
  String? userName;
  String? fullName;
  String? branch;
  String? department;
  String? createdAt;
  Map<String, dynamic> role;
  final String? _token;

  User(
      {required this.userName,
        this.fullName,
      required token,
      this.email,
      this.id,
      this.branch,
      this.department,
      this.createdAt,
      required this.role})
      : _token = token;

  get token => _token;
}
