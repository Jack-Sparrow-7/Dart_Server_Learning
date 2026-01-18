import 'dart:convert';
import 'package:bcrypt/bcrypt.dart';
import 'package:first_server/models/user.dart';

import '../extensions/email_extension.dart';
import '../extensions/password_extension.dart';
import '../db.dart';

import 'package:shelf/shelf.dart';

Future<Response> registerUser(Request request) async {
  final body = await request.readAsString();
  if (body.isEmpty) {
    return Response.badRequest(
      body: jsonEncode({"message": "All fields are required."}),
    );
  }

  final data = jsonDecode(body) as Map<String, dynamic>;

  final String userName = data['username'];
  final String email = data['email'];
  final String password = data['password'];

  if (userName.isEmpty || email.isEmpty || password.isEmpty) {
    return Response.badRequest(
      body: jsonEncode({"message": "All fields are required."}),
    );
  }

  if (!email.isValidEmail) {
    return Response.badRequest(body: jsonEncode({"message": "Invalid Email."}));
  }

  if (password.isStrongPassword) {
    return Response.badRequest(
      body: jsonEncode({"message": "Password must be atleast 6 characters."}),
    );
  }

  try {
    final existing = await db.collection('user').findOne({
      "email": email.normalizedEmail,
    });

    if (existing != null) {
      return Response.badRequest(
        body: jsonEncode({"message": "User already exists."}),
      );
    }

    final hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

    final user = User(
      username: userName.trim(),
      email: email.normalizedEmail,
      password: hashedPassword,
      createdAt: DateTime.now(),
    );

    final inserted = await db.collection('user').insertOne(user.toJson());
    final userJson = inserted.document;
    userJson?['createdAt'] = (userJson['createdAt'] as DateTime)
        .toIso8601String();

    return Response(
      201,
      body: jsonEncode({"message": "User registered.", "user": userJson}),
    );
  } on Exception catch (e) {
    return Response.internalServerError(
      body: jsonEncode({"error": e.toString()}),
    );
  }
}

Future<Response> loginUser(Request request) async {
  final body = await request.readAsString();
  final Map<String, dynamic> data = jsonDecode(body);

  final String email = data['email'];
  final String password = data['password'];

  try {
    final existing = await db.collection('user').findOne({
      'email': email.normalizedEmail,
    });

    if (existing == null) {
      return Response.notFound(jsonEncode({'message': "User does not exist."}));
    }

    final String hashedPassword = existing['password'];

    final bool isCorrect = BCrypt.checkpw(password, hashedPassword);

    final user = User.fromJson(existing);

    return isCorrect
        ? Response.ok(
            jsonEncode({
              "message": "User logged in.",
              "user": {
                "_id": user.id,
                "email": user.email,
                "username": user.username,
              },
            }),
          )
        : Response.badRequest(
            body: jsonEncode({"message": "Invalid Password."}),
          );
  } catch (e) {
    return Response.internalServerError(
      body: jsonEncode({"error": e.toString()}),
    );
  }
}

Future<Response> logoutUser(Request request) async {
  final body = await request.readAsString();
  final Map<String, dynamic> data = jsonDecode(body);
  final String email = data['email'];

  try {
    final existing = await db.collection('user').findOne({
      'email': email.normalizedEmail,
    });

    if (existing == null) {
      return Response.notFound(jsonEncode({'message': "User does not exist."}));
    }

    return Response.ok(jsonEncode({"message": "User logged out."}));
  } catch (e) {
    return Response.internalServerError(
      body: jsonEncode({"error": e.toString()}),
    );
  }
}
