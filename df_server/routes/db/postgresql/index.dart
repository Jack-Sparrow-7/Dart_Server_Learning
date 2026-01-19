import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:postgres/postgres.dart';

Future<Response> onRequest(RequestContext context) {
  return switch (context.request.method) {
    HttpMethod.get => _getLists(context),
    HttpMethod.post => _createList(context),
    _ => Future.value(
      Response.json(
        statusCode: HttpStatus.methodNotAllowed,
        body: {'message': 'Method Not Allowed.'},
      ),
    ),
  };
}

Future<Response> _getLists(RequestContext context) async {
  final conn = context.read<Connection>();
  final lists = <Map<String, dynamic>>[];

  final results = await conn.execute('SELECT id , name FROM lists');

  for (final row in results) {
    lists.add({'id': row[0], 'name': row[1]});
  }
  return Response.json(body: lists);
}

Future<Response> _createList(RequestContext context) async {
  final body = await context.request.json() as Map<String, dynamic>;
  final conn = context.read<Connection>();
  final name = body['name'] as String?;

  if (name != null) {
    final results = await conn.execute(
      Sql.named('INSERT INTO lists (name) VALUES (@name)'),
      parameters: {'name': name},
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
