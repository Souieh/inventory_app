class Article {
  final String code;
  final String name;
  final int quantity;
  String? description;
  String? condition;
  String? category;
  String? location;
  String? createdAt;
  String? updatedAt;
  String agentCode;

  Article({
    required this.code,
    required this.name,
    required this.quantity,
    this.description,
    this.condition,
    this.category,
    this.location,
    this.createdAt,
    this.updatedAt,
    required this.agentCode,
  });

  factory Article.fromMap(Map<String, dynamic> map) {
    return Article(
      code: map['code'],
      name: map['name'],
      quantity: map['quantity'] ?? 0,
      description: map['description'],
      condition: map['condition'],
      category: map['category'],
      location: map['location'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      agentCode: map['agentCode'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'name': name,
      'quantity': quantity,
      'description': description,
      'condition': condition,
      'category': category,
      'location': location,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'agentCode': agentCode,
    };
  }
}
