import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:tapin_api/repository/session/session_repository.dart';
import 'package:tapin_api/repository/user/user_repository.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.post => _createUser(context),
    HttpMethod.get => _authenticateUser(context),
    _=> Future.value(Response(statusCode: HttpStatus.methodNotAllowed)),
  };
}

Future<Response>_createUser(RequestContext context) async {
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

Future<Response> _authenticateUser(RequestContext context) async {
  final body = await context.request.json() as Map<String, dynamic>;
  final email = body['email'] as String?;
  final password = body['password'] as String?;

  final userRepository = context.read<UserRepository>();
  final sessionRepository = context.read<SessionRepository>();

  if(email != null && password != null) {
    final user = await userRepository.userFromCredentials(email, password);

    if(user == null) {
      return Response(statusCode: HttpStatus.unauthorized);
    } else {
      final session = await sessionRepository.createSession(user.id);
      return Response.json(body: {'token': session.token});
    }
  } else {
    return Response(statusCode: HttpStatus.badRequest);
  }
}