// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskItem _$TaskItemFromJson(Map<String, dynamic> json) => TaskItem(
  description: json['description'] as String,
  listId: json['listId'] as String,
  status: json['status'] as bool,
  id: json['id'] as String,
  name: json['name'] as String,
);

Map<String, dynamic> _$TaskItemToJson(TaskItem instance) => <String, dynamic>{
  'id': instance.id,
  'listId': instance.listId,
  'name': instance.name,
  'description': instance.description,
  'status': instance.status,
};
