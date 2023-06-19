class User {
  String? id;
  String? email;
  String? name;
  final String _token;

  User({required this.name, required token, this.email, this.id})
      : _token = token;

  get token => _token;
}
