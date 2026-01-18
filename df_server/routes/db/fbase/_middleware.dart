import 'package:dart_frog/dart_frog.dart';
import 'package:firedart/firestore/firestore.dart';

Handler middleware(Handler handler) {
  return (context) async {
    if (!Firestore.initialized) {
      Firestore.initialize('gate-pass-d7557');
    }

    final response = await handler(context);

    return response;
  };
}
