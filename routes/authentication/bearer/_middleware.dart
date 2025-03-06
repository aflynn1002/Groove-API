import 'package:dart_frog/dart_frog.dart';
import 'package:tapin_api/repository/session/session_repository.dart';
import 'package:tapin_api/repository/user/user_repository.dart';
import 'package:dart_frog_auth/dart_frog_auth.dart';


final userRepository = UserRepository();
final sessionRepository = SessionRepository();

Handler middleware(Handler handler) {
  return handler  
    .use(
      bearerAuthentication<User>(
        authenticator: (context, token) async {
          final sessionRepo = context.read<SessionRepository>(); //using session repository
          final userRepo = context.read<UserRepository>(); //using user repository
          final session = sessionRepo.sessionFromToken(token);
          return session != null
              ? userRepo.userFromId(session.userId)
              : null;
      },
      applies: (RequestContext context) async =>
          context.request.method != HttpMethod.post &&
          context.request.method != HttpMethod.get,
      ),
    )
      .use(provider<UserRepository>((_) => userRepository))//injected an isntance of user repository
      .use(provider<SessionRepository>((_) => sessionRepository));

}
