import 'package:mongo_dart/mongo_dart.dart';

late Db db;

Future<void> connectDb(String uri) async {
  try {
    db = await Db.create(uri);
    await db.open();
    print('Database isConnected - ${db.isConnected}');
  } on Exception catch (e) {
    print('Database connection error: ${e.toString()}');
  }
}
