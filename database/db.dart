import 'package:postgres/postgres.dart';

class Database {
  
 static Future<Connection> openConnection() async {
  final conn = await Connection.open(
    Endpoint(
      host: 'localhost', // Use the service name defined in docker-compose.yml
      port: 5432,
      database: 'tapin-dev',
      username: 'postgres',
      password: 'postgres',
    ),
    settings: ConnectionSettings(sslMode: SslMode.disable),
  );
  return conn;
}

}