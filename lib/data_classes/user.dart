class User {
  String? id;
  String? email;
  String? name;
  String? branch;
  String? department;
  String? role;
  final String _token;

  User({required this.name, required token, this.email, this.id, this.branch, this.department, this.role})
      : _token = token;

  get token => _token;
}
