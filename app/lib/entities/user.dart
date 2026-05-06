// Định nghĩa lớp User dùng trong dự án Quản lý Chi tiêu

class User {
  final int id;
  String name;
  String email;
  String password;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
  });

  // Tạo bản sao với một số trường được thay đổi (hữu ích khi immutable-like updates)
  User copyWith({
    int? id,
    String? name,
    String? email,
    String? password,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  // Chuyển User -> Map để lưu trữ (JSON/DB)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
    };
  }

  // Tạo User từ Map (JSON/DB)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
    );
  }

  bool validateEmail() {
    final emailRegex = RegExp(r"^[\w\.\-]+@([\w\-]+\.)+[a-zA-Z]{2,}$");
    return emailRegex.hasMatch(email);
  }

  bool validatePassword({int minLength = 6}) {
    return password.length >= minLength;
  }

  void updatePassword(String newPassword) {
    password = newPassword;
  }

  bool authenticate(String inputPassword) {
    return inputPassword == password;
  }

  String displayName() {
    return name.isNotEmpty ? name : email;
  }

  @override
  String toString() {
    return 'User{id: $id, name: $name, email: $email}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
