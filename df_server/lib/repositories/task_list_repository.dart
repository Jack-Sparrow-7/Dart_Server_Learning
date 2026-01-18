import 'package:df_server/extensions/hash_extension.dart';
import 'package:df_server/models/task_list/task_list.dart';
import 'package:meta/meta.dart';

@visibleForTesting
Map<String, TaskList> listDb = {};

class TaskListRepository {
  Future<TaskList?> listById({required String id}) async => listDb[id];

  Map<String, dynamic> getAllLists() {
    final formattedLists = <String, dynamic>{};

    if (listDb.isNotEmpty) {
      listDb.forEach(
        (id, taskList) {
          formattedLists['id'] = taskList.toJson();
        },
      );
    }

    return formattedLists;
  }

  String createList({required String name}) {
    final id = name.hashValue;

    final taskList = TaskList(id: id, name: name);

    listDb[id] = taskList;

    return id;
  }

  void deleteList({required String id}) {
    listDb.remove(id);
  }

  Future<void> updateList({required String id, required String name}) async {
    final currentList = listDb[id];

    if (currentList == null) {
      return Future.error('List not found.');
    }

    final updatedList = currentList.copyWith(name: name);

    listDb[id] = updatedList;
  }
}
