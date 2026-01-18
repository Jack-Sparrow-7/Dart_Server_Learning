import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:firedart/firedart.dart';

import 'index.dart';

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

  await Firestore.instance.collection(taskCollection).document(id).update({
    'name': name,
  });

  return Response(
    statusCode: HttpStatus.noContent,
  );
}

Future<Response> _deleteList(RequestContext context, String id) async {
  try {
    await Firestore.instance.collection(taskCollection).document(id).delete();
    return Response(
      statusCode: HttpStatus.noContent,
    );
  } on Exception {
    return Response(statusCode: HttpStatus.badRequest);
  }
}
