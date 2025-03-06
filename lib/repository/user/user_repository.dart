import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:math';




@visibleForTesting
Map<String, User> userDb = {};

/// User's class
class User extends Equatable {
  /// User constructor
  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
  });

  /// The user id
  final String id;

  /// The user first name
  final String firstName;

  /// The user last name
  final String lastName;

  /// The user email
  final String email;

  /// The user password
  final String password;

  @override
  List<Object> get props => [id, firstName, lastName, email, password];
}

// /// Generate random value
// String generateSalt([int length = 16]) {
//   final random = Random.secure();
//   final values = List<int>.generate(length, (i) => random.nextInt(256));
//   return base64Url.encode(values);
// }

// /// Generate password hash
// String generatePasswordHash(String password, String salt) {
//   final input = '$password$salt';
//   final bytes = utf8.encode(input); // Convert input string to bytes
//   final digest = sha256.convert(bytes); // Generate SHA-256 hash
//   return digest.toString(); // Convert hash to string
// }

/// Generate hash
String generateHash(String word) {
  final input = '$word';
  final bytes = utf8.encode(input); // Convert input string to bytes
  final digest = sha256.convert(bytes); // Generate SHA-256 hash
  return digest.toString(); // Convert hash to string
}

/// User Repository
class UserRepository {
  /// Checks in the database for a user with the provided username and password
  Future<User?> userFromCredentials(String email, String password) async {
    // final salt = generateSalt();
    final hashedPassword = generateHash(password);

    final users = userDb.values.where(
      (user) => user.email == email && user.password == hashedPassword
    );

    if(users.isNotEmpty) {
      return users.first;
    }

    return null;
  }

  /// Search for a user by id
  User? userFromId(String id) { // possible that value is not there so add ?
    return userDb[id];
  }

  /// Creates a new user
  Future<String> createUser({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) {
    
    final id = generateHash(email);

    final user = User(
      id: id,
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: generateHash(password),
    );

    userDb[id] = user;
    return Future.value(id) ;
  }

  /// Delete a user
  void deleteUser(String id) {
    userDb.remove(id);
  }

  /// Update a user
  Future<void> updateUser({
    required String id,
    required String? firstName,
    required String? lastName,
    required String? email,
    required String? password,
  }) async {
    final currentUser = userDb[id];
    
    if(currentUser == null) {
     return Future.error(Exception('User not found'));
    }

    if(password != null) {
      password = generateHash(password);
    }

    final user = User(
      id: id,
      firstName: firstName ?? currentUser.firstName,
      lastName: lastName ?? currentUser.lastName,
      email: email ?? currentUser.email,
      password: password ?? currentUser.password
      );


    userDb[id] = user;
  }


}