class Location {
  final String code;
  final String name;
  String? occupation; // optional occupation for the location
  String? type; // optional type for the location, e.g., "warehouse", "store"
  String? description; // optional description for the location
  String? createdAt;
  String? updatedAt;
  String agentCode;

  Location({
    required this.code,
    required this.name,
    this.description,
    this.occupation,
    this.type,
    required this.createdAt,
    required this.updatedAt,
    required this.agentCode,
  });

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      code: map['code'],
      name: map['name'],
      occupation: map['occupation'],
      type: map['type'],
      description: map['description'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      agentCode: map['agentCode'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'name': name,
      'occupation': occupation,
      'type': type,
      'description': description,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'agentCode': agentCode,
    };
  }
}
