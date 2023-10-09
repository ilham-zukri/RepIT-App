class User {
  String? id;
  String? email;
  String? name;
  String? branch;
  String? department;
  Map<String, dynamic> role;
  final String _token;

  User({required this.name, required token, this.email, this.id, this.branch, this.department, required this.role})
      : _token = token;

  get token => _token;
}
