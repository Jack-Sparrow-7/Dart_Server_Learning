import 'package:df_server/extensions/hash_extension.dart';
import 'package:df_server/models/task_item/task_item.dart';
import 'package:meta/meta.dart';

@visibleForTesting
Map<String, TaskItem> itemDb = {};

class TaskItemRepository {
  Future<TaskItem?> itemById({required String id}) async => itemDb[id];

  Map<String, dynamic> getAllItems() {
    final formattedLists = <String, dynamic>{};

    if (itemDb.isNotEmpty) {
      itemDb.forEach(
        (id, taskList) {
          formattedLists['id'] = taskList.toJson();
        },
      );
    }

    return formattedLists;
  }

  String createItem({
    required String name,
    required String listId,
    required String description,
  }) {
    final id = name.hashValue;

    final taskItem = TaskItem(
      id: id,
      name: name,
      description: description,
      listId: listId,
      status: true,
    );

    itemDb[id] = taskItem;

    return id;
  }

  void deleteItem({required String id}) {
    itemDb.remove(id);
  }

  Future<void> updateItem({
    required String id,
    required String name,
    required String listId,
    required String description,
    required bool status,
  }) async {
    final currentItem = itemDb[id];

    if (currentItem == null) {
      return Future.error('List not found.');
    }

    final updatedList = currentItem.copyWith(
      name: name,
      listId: listId,
      description: description,
      status: status,
    );

    itemDb[id] = updatedList;
  }
}
