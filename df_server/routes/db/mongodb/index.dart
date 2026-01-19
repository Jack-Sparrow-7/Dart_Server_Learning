import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:mongo_dart/mongo_dart.dart';

Future<Response> onRequest(RequestContext context) {
  final req = context.request;
  return switch (req.method) {
    HttpMethod.get => _getLists(context),
    HttpMethod.post => _createList(context),
    _ => Future.value(
      Response.json(
        statusCode: HttpStatus.methodNotAllowed,
        body: {'message': 'Method not allowed.'},
      ),
    ),
  };
}

Future<Response> _getLists(RequestContext context) async {
  final db = context.read<Db>();

  final lists = await db.collection('lists').find().toList();

  return Response.json(body: lists);
}

Future<Response> _createList(
  RequestContext context,
) async {
  final body = await context.request.json() as Map<String, dynamic>;

  final name = body['name'] as String?;

  final list = <String, dynamic>{'name': name};

  final db = context.read<Db>();

  final result = await db.collection('lists').insertOne(list);

  return Response.json(
    statusCode: HttpStatus.created,
    body: {
      'id': result.id,
    },
  );
}
