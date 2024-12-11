class UserModel {
  final String name;
  final String? avatarUrl;

  UserModel({
    required this.name,
    this.avatarUrl,
  });

  String getInitial() {
    return name.isNotEmpty ? name[0].toUpperCase() : '';
  }
}
