import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

@visibleForTesting
/// In memory database
Map<String, Session> sessionDb = {};

/// A Session Class
class Session extends Equatable {

  /// Session constructor
  const Session({
    required this.token,
    required this.userId,
    required this.expiryDate,
    required this.createdAt,
  });

  /// The session token
  final String token;

  /// The user id
  final String userId;

  /// The expiry date
  final DateTime expiryDate;

  /// The creation date
  final DateTime createdAt;

  @override
  List<Object> get props => [token, userId, expiryDate, createdAt];
}

/// Session Repository
class SessionRepository {

  /// Create a new session
  Session createSession(String userId){
    final session = Session(
      token: generateToken(userId),
      userId: userId,
      expiryDate: DateTime.now().add(Duration(hours: 24)),
      createdAt: DateTime.now());

    sessionDb[session.token] = session;
    return session;

  }

  /// Generate token
  String generateToken(String userId) {
    final input = '${userId}_${DateTime.now().toIso8601String()}';
    final bytes = utf8.encode(input); // Convert input string to bytes
    final digest = sha256.convert(bytes); // Generate SHA-256 hash
    return digest.toString(); // Convert hash to string
  }

  /// Search a session of a particular token
  Session? sessionFromToken(String token) {
    final session = sessionDb[token];

    if (session != null && session.expiryDate.isAfter(DateTime.now())) {
      return session;
    }
    return null;
  }
}