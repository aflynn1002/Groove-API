import 'package:dart_frog/dart_frog.dart';

import '../../database/db.dart';

Future<Response> onRequest(RequestContext context) {
  return switch (context.request.method) {
    HttpMethod.get => _getLocations(),
    _ => Future.value(Response(body: 'Invalid request method')),
  };
}

Future<Response> _getLocations() async {
  final connection = await Database.openConnection();
  final result = await connection.execute('SELECT * FROM locations');
  await connection.close();

  final locations = result.map((row) {
    return {
      'id': row[0],
      'latitude': row[1],
      'longitude': row[2],
      'timestamp': (row[3] as DateTime).toIso8601String(),
      'user_id': row[4],
      'weight': row[5],
    };
  }).toList();

  return Response.json(body: locations);
}