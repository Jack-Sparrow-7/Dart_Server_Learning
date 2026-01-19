import 'dart:convert';

import 'package:first_server/db.dart';
import 'package:first_server/models/post.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';

Future<Response> createPost(Request request) async {
  final body = await request.readAsString();
  final Map<String, dynamic> data = jsonDecode(body);

  final post = Post.fromJson(data);
  try {
    final inserted = await db.collection('posts').insertOne(post.toJson());
    final createdPost = inserted.document;
    return Response(201, body: jsonEncode({"post": createdPost}));
  } catch (e) {
    return Response.internalServerError(
      body: jsonEncode({"error": e.toString()}),
    );
  }
}

Future<Response> getPosts(Request request) async {
  try {
    final posts = [];
    await db
        .collection('posts')
        .find()
        .forEach((element) => posts.add(element));
    return Response.ok(jsonEncode({'posts': posts}));
  } catch (e) {
    return Response.internalServerError(
      body: jsonEncode({"error": e.toString()}),
    );
  }
}

Future<Response> updatePost(Request request,String id) async {
  try {
    final body = await request.readAsString();
    if (body.isEmpty) {
      return Response.badRequest(
        body: jsonEncode({"message": "Fields not provided."}),
      );
    }

    final Map<String, dynamic> data = jsonDecode(body);

    await db.collection('posts').replaceOne(where.id(ObjectId.fromHexString(id)),data);

    return Response(200, body: jsonEncode({"message": "Updated"}));
  } catch (e) {
    return Response.internalServerError(
      body: jsonEncode({"error": e.toString()}),
    );
  }
}

Future<Response> deletePost(Request request,String id) async {
  try {
    await db.collection('posts').deleteOne(where.id(ObjectId.fromHexString(id)));

    return Response(200, body: jsonEncode({"message": "Deleted"}));
  } catch (e) {
    return Response.internalServerError(
      body: jsonEncode({"error": e.toString()}),
    );
  }
}