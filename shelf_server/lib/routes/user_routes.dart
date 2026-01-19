import '../handlers/user_handler.dart';
import 'package:shelf_router/shelf_router.dart';

Router getUserRoutes() {
  final router = Router()
    ..post('/register', registerUser)
    ..post('/login', loginUser)
    ..post('/logout', logoutUser);

  return router;
}
