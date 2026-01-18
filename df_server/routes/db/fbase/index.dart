import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:firedart/firedart.dart';

const String taskCollection = 'tasklists';

Future<Response> onRequest(RequestContext context) {
  final req = context.request;
  return switch (req.method) {
    HttpMethod.get => _getLists(context),
    HttpMethod.post => _createList(context),
    _ => Future.value(
      Response.json(
        statusCode: HttpStatus.methodNotAllowed,
        body: {
          'message':'Method Not Allowed.'
        }
      ),
    ),
  };
}

Future<Response> _getLists(RequestContext context) async {
  final lists = <Map<String, dynamic>>[];
  await Firestore.instance.collection(taskCollection).get().then(
    (event) {
      for (final doc in event) {
        lists.add(doc.map);
      }
    },
  );
  return Response.json(body: lists);
}

Future<Response> _createList(RequestContext context) async {
  final req = context.request;
  final body = await req.json() as Map<String, dynamic>;

  final name = body['name'] as String?;

  final list = <String, dynamic>{'name': name};

  final id = await Firestore.instance
      .collection(taskCollection)
      .add(list)
      .then(
        (doc) => doc.id,
      );

  return Response.json(statusCode: HttpStatus.created, body: {'id': id});
}
