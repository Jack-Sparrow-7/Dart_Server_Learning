import 'package:first_server/handlers/post_handler.dart';
import 'package:shelf_router/shelf_router.dart';

Router getPostRoutes() {
  final router = Router()
    ..post('/create', createPost)
    ..get('/getPosts', getPosts)
    ..put('/update/<id>', updatePost)
    ..delete('/delete/<id>', deletePost);

  return router;
}
