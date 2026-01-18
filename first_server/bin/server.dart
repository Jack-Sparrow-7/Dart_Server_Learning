import 'dart:io';

import 'package:dotenv/dotenv.dart';
import 'package:first_server/db.dart';
import 'package:first_server/routes/post_routes.dart';
import 'package:first_server/routes/user_routes.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

// Configure routes.
final _router = Router()
  ..get('/', _rootHandler)
  ..mount('/api/v1/users', getUserRoutes().call)
  ..mount('/api/v1/posts', getPostRoutes().call);

Response _rootHandler(Request request) {
  return Response.ok('Hello Buddy!');
}

void main(List<String> args) async {
  var env = DotEnv(includePlatformEnvironment: true)..load();
  final mongoDbUri = env['MONGODB_URI'];
  print("Uri from env - $mongoDbUri");

  if (mongoDbUri != null && mongoDbUri.isNotEmpty) {
    await connectDb(mongoDbUri);
  }

  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  // Configure a pipeline that logs requests.
  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addHandler(_router.call);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}
