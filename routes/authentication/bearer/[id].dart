import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:tapin_api/repository/user/user_repository.dart';

Future<Response> onRequest(
  RequestContext context,
  String id,
) async {
  return switch (context.request.method) {
    HttpMethod.patch => _updateUser(context, id),
    HttpMethod.delete => _deleteUser(context, id),
    HttpMethod.get => _getUser(context, id),
    _=> Future.value(Response(statusCode: HttpStatus.methodNotAllowed)),
  };
}

Future<Response> _getUser(RequestContext context, String id) async {
  final user = await context.read<UserRepository>().userFromId(id);

  if(user == null) {
    return Response(statusCode: HttpStatus.forbidden);
  } else {
    if(user.id != id) {
      return Response(statusCode: HttpStatus.forbidden);
    }
    return Response.json(body: {
    'id': user.id,
    'firstName': user.firstName,
    'lastName': user.lastName,
    'email': user.email 
    });
  }
}
Future<Response> _updateUser(RequestContext context, String id) async{
  final body = await context.request.json() as Map<String, dynamic>;
  final firstName = body['firstName'] as String?;
  final lastName = body['lastName'] as String?;
  final email = body['email'] as String?;
  final password = body['password'] as String?;

  final userRepository = context.read<UserRepository>();

  if(firstName != null || lastName != null || email != null || password != null) {
    await userRepository.updateUser(
      id: id,
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
    );
    return Response(statusCode: HttpStatus.noContent);
  } else {
    return Response(statusCode: HttpStatus.badRequest);
  }
}
Future<Response> _deleteUser(RequestContext context, String id) async {
    final user = await context.read<UserRepository>().userFromId(id);

    if(user == null) {
      return Response(statusCode: HttpStatus.forbidden);
    } else {
      if(user.id != id) {
        return Response(statusCode: HttpStatus.forbidden);
      }
      context.read<UserRepository>().deleteUser(id);

      return Response(statusCode: HttpStatus.noContent);
    }
}