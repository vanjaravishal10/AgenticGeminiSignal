class UserModel {
  final String userId;
  final String name;
  final String role;
  final List<String> zoneIds;

  UserModel({
    required this.userId,
    required this.name,
    required this.role,
    required this.zoneIds,
  });

  factory UserModel.fromMap(String userId, Map<String, dynamic> data) {
    return UserModel(
      userId: userId,
      name: data['name'] ?? '',
      role: data['role'] ?? 'citizen',
      zoneIds: List<String>.from(data['zoneIds'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'role': role,
      'zoneIds': zoneIds,
    };
  }

  bool get isAdmin => role.toLowerCase() == 'admin';
}
