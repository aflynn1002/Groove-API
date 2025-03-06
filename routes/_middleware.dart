import 'package:dart_frog/dart_frog.dart';

Handler middleware(Handler handler) {
  // TODO: implement middleware
  return handler.use(requestLogger()) // requestLogger is a middleware which prints the time of the request, the type of request, and the directory it accessed.
  .use(provider<String>((context) => 'Dart Frog Tutorial 2025',));
}
