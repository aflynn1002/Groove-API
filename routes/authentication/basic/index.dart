import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:tapin_api/repository/user/user_repository.dart';

Future<Response> onRequest(RequestContext context) {
  return switch (context.request.method) {
    HttpMethod.post => _createUser(context),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed))
  };
}

Future<Response> _createUser(RequestContext context) async {
  final body = await context.request.json() as Map<String, dynamic>;
  final firstName = body['firstName'] as String?;
  final lastName = body['lastName'] as String?;
  final email = body['email'] as String?;
  final password = body['password'] as String?;

  final userRepository = context.read<UserRepository>();

  if (firstName != null && lastName != null && email != null && password != null) {
    final id = await userRepository.createUser(
        firstName: firstName, lastName: lastName, email: email, password: password);
    return Response.json(body: {'id': id});
  } else {
    return Response(statusCode: HttpStatus.badRequest);
  }
}
