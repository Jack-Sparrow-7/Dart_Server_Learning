import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:postgres/postgres.dart';

Future<Response> onRequest(
  RequestContext context,
  String id,
) {
  final req = context.request;

  return switch (req.method) {
    HttpMethod.patch => _updateList(context, id),
    HttpMethod.delete => _deleteList(context, id),
    _ => Future.value(
      Response.json(
        statusCode: HttpStatus.methodNotAllowed,
        body: {'message': 'Method Not Allowed.'},
      ),
    ),
  };
}

Future<Response> _updateList(RequestContext context, String id) async {
  final body = await context.request.json() as Map<String, dynamic>;
  final name = body['name'] as String?;
  final conn = context.read<Connection>();
  if (name != null) {
    final results = await conn.execute(
      Sql.named('UPDATE  lists SET name = @name WHERE id = @id'),
      parameters: {'name': name, 'id': id},
    );

    try {
      if (results.affectedRows == 1) {
        return Response.json(
          statusCode: HttpStatus.created,
          body: {'message': 'succes'},
        );
      } else {
        return Response.json(body: {'message': 'failed'});
      }
    } on Exception {
      return Response.json(
        statusCode: HttpStatus.connectionClosedWithoutResponse,
      );
    }
  } else {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'message': 'name must not be null.'},
    );
  }
}

Future<Response> _deleteList(RequestContext context, String id) async {
  final conn = context.read<Connection>();
  try {
    await conn.execute(
      Sql.named('DELETE FROM lists WHERE id = @id'),
      parameters: {'id': id},
    );
    return Response(
      statusCode: HttpStatus.noContent,
    );
  } on Exception {
    return Response(statusCode: HttpStatus.badRequest);
  }
}
