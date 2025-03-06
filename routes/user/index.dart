import 'package:dart_frog/dart_frog.dart';

import '../../database/db.dart';

Future<Response> onRequest(RequestContext context) {
  return switch (context.request.method) {
    HttpMethod.get => _getUsers(),
    HttpMethod.get => _getConnections(),
    HttpMethod.post => _createUser(context),
    _ => Future.value(Response(body: 'Invalid request method')),
  };
}

Future<Response> _getUsers() async {
  final connection = await Database.openConnection();
  final result = await connection.execute('SELECT * FROM users');
  await connection.close();

  final users = result.map((row) {
    return {
      'id': row[0],
      'first_name': row[1],
      'last_name': row[2],
      'email': row[3],
      'password': row[4],
      'age': row[5],
    };
  }).toList();

  return Response.json(body: users);
}

// Get friendships function
//! Will need to add a _createConnections function
Future<Response> _getConnections() async {
  final connection = await Database.openConnection();
  final result = await connection.execute('SELECT * FROM connections');
  await connection.close();

  final connections = result.map((row) {
    return {
      'id': row[0],
      'user_id': row[1],
      'friend_id': row[2],
      'created_at': (row[3] as DateTime).toIso8601String(),
    };
  }).toList();

  return Response.json(body: connections);
}


Future<Response> _createUser(RequestContext context) async {
  try {
    final json = (await context.request.json()) as Map<String, dynamic>;
    final firstName = json['first_name'];
    final lastName = json['last_name'];
    final age = json['age'];
    final email = json['email'];
    final password = json['password'];

    final connection = await Database.openConnection();
    await connection.execute(r'INSERT INTO users (first_name, last_name, age, email, password) VALUES ($1, $2, $3, $4, $5)',
      parameters: [firstName, lastName, age, email, password],
    );

    await connection.close();
    return Response.json(
      body: {
        'message': 'User created successfully!',
        'user': {
          'first_name': firstName,
          'last_name': lastName,
          'age': age,
          'email': email,
          'password': password,
        },
      },
    );
  } catch (e) {
    print('Error: $e');
    return Response.json(
      statusCode: 500,
      body: {'error': e.toString()},
    );
  }
}