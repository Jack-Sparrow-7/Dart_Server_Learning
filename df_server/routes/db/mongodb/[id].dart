import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:mongo_dart/mongo_dart.dart';

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
        body: {'message': 'Method not allowed.'},
      ),
    ),
  };
}

Future<Response> _updateList(RequestContext context, String id) async {
  final body = await context.request.json() as Map<String, dynamic>;

  final name = body['name'];

  final db = context.read<Db>();

  try {
    await db
        .collection('lists')
        .updateOne(
          where.eq('_id', ObjectId.fromHexString(id)),
          modify.set('name', name),
        );

    return Response(
      statusCode: HttpStatus.noContent,
    );
  } on Exception {
    return Response(
      statusCode: HttpStatus.badRequest,
    );
  }
}

Future<Response> _deleteList(RequestContext context, String id) async {
  final db = context.read<Db>();

  try {
    await db
        .collection('lists')
        .deleteOne(where.eq('_id', ObjectId.fromHexString(id)));

    return Response(
      statusCode: HttpStatus.noContent,
    );
  } on Exception {
    return Response(
      statusCode: HttpStatus.badRequest,
    );
  }
}
