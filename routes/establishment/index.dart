import 'package:dart_frog/dart_frog.dart';

import '../../database/db.dart';

Future<Response> onRequest(RequestContext context) {
  return switch (context.request.method) {
    HttpMethod.get => _getEstablishments(),
    _ => Future.value(Response(body: 'Invalid request method')),
  };
}

Future<Response> _getEstablishments() async {
  final connection = await Database.openConnection();
  final result = await connection.execute('SELECT * FROM establishments');
  await connection.close();

  final establishments = result.map((row) {
    return {
      'id': row[0],
      'name': row[1],
      'address': row[2],
      'phone': row[3],
      'email': row[4],
      'website': row[5],
    };
  }).toList();

  return Response.json(body: establishments);
}