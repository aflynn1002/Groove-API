import 'package:dart_frog/dart_frog.dart';

import '../database/db.dart';

Future<Response> onRequest(RequestContext context) {
  return switch (context.request.method) {
    HttpMethod.get => _getUsers(),
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