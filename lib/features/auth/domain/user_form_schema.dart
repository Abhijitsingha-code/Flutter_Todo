class UserFormSchema {
  final String name;
  final String email;
  final String password;
  final String phone;

  UserFormSchema({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
  });

  factory UserFormSchema.fromMap(Map<String, dynamic> map) {
    return UserFormSchema(
      name: map['name'],
      email: map['email'],
      password: map['password'],
      phone: map['phone'],
    );
  }
}