enum GenderEnum {
  male,
  female,
  unknow,
}

class User {
  final int id;
  final String firstName;
  final String lastName;
  final String fullName;
  final String maidenName;
  final int age;
  final GenderEnum gender;
  final String email;
  final String phone;
  final String username;
  final String birthDate;
  final String image;
  final int height;
  final double weight;
  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.maidenName,
    required this.age,
    required this.gender,
    required this.email,
    required this.phone,
    required this.username,
    required this.birthDate,
    required this.image,
    required this.height,
    required this.weight,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id']?.toInt() ?? 0,
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      fullName: _getFullName(map['firstName'], map['lastName']),
      maidenName: map['maidenName'] ?? '',
      age: map['age']?.toInt() ?? 0,
      gender: _genderEnum(map["gender"] ?? "unknown"),
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      username: map['username'] ?? '',
      birthDate: map['birthDate'] ?? '',
      image: map['image'] ?? '',
      height: map['height']?.toInt() ?? 0,
      weight: map['weight']?.toDouble() ?? 0.0,
    );
  }

  static GenderEnum _genderEnum(String value) {
    for (GenderEnum type in GenderEnum.values) {
      if (type.toString() == value) {
        return type;
      }
    }

    return GenderEnum.unknow;
  }

  @override
  String toString() {
    return 'User(id: $id, firstName: $firstName, lastName: $lastName, fullName: $fullName, maidenName: $maidenName, age: $age, gender: $gender, email: $email, phone: $phone, username: $username, birthDate: $birthDate, image: $image, height: $height, weight: $weight)';
  }
}

String _getFullName(String firstName, String lastName) {
  if (firstName.isEmpty || lastName.isEmpty) {
    return "";
  }

  return '$firstName $lastName';
}

class UserPaginateResponse {
  final List<User> users;
  final int skip;
  final int limit;
  final int total;
  UserPaginateResponse({
    required this.users,
    required this.skip,
    required this.limit,
    required this.total,
  });

  factory UserPaginateResponse.fromMap(
      Map<String, dynamic> map, List<User> users) {
    return UserPaginateResponse(
      users: users,
      skip: map['skip']?.toInt() ?? 0,
      limit: map['limit']?.toInt() ?? 0,
      total: map['total']?.toInt() ?? 0,
    );
  }

  @override
  String toString() {
    return 'UserPaginateResponse(users: $users, skip: $skip, limit: $limit, total: $total)';
  }
}
