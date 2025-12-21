
// lib/src/models/res_partner.dart
class ResPartner {
  final int id;
  final String name;
  final String? email;

  ResPartner({required this.id, required this.name, this.email});

  factory ResPartner.fromJson(Map<String, dynamic> json) {
    return ResPartner(
      id: json['id'],
      name: json['name'],
      email: json['email'] ?? '',
    );
  }
}
