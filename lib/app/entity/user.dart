class User {
  final int? userId;
  final String? userName;
  final String? fullName;
  final String? email;
  final String? password;
  final String? roles;

  User({
    this.userId,
    this.userName,
    this.fullName,
    this.email,
    this.password,
    this.roles,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'],
      userName: json['user_name'],
      fullName: json['full_name'],
      email: json['email'],
      password: json['password'],
      roles: json['roles'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'user_name': userName,
      'full_name': fullName,
      'email': email,
      'password': password,
      'roles': roles,
    };
  }
}
