// ignore_for_file: file_names

class User {
  final int? id;
  final String name;
  final String email;
  final String? profilePicturePath; 

  User({
    this.id,
    required this.name,
    required this.email,
    this.profilePicturePath, // Include in constructor
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profilePicturePath': profilePicturePath, 
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      profilePicturePath: map['profilePicturePath'], 
    );
  }

  @override
  String toString() {
    return 'User{id: $id, name: $name, email: $email}';
  }
}