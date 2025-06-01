class User {
  final String code;
  final String name;
  String? description;
  String? password;
  String? createdAt;
  String? role = 'agent'; // Default role is 'agent'

  User({
    required this.code,
    required this.name,
    this.description,
    this.password,
    this.createdAt,
    this.role,
  });

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'name': name,
      'description': description ?? '',
      'password': password ?? '',
      'createdAt': DateTime.now().toIso8601String(),
      'role': role ?? 'agent',
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      code: map['code'],
      name: map['name'],
      description: map['description'],
      password: map['password'],
      createdAt: map['createdAt'],
      role: map['role'] ?? 'agent',
    );
  }
}
