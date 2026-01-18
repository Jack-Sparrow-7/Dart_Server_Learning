import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'task_item.g.dart';

@JsonSerializable()
class TaskItem extends Equatable {
  const TaskItem({
    required this.description,
    required this.listId,
    required this.status,
    required this.id,
    required this.name,
  });

  factory TaskItem.fromJson(Map<String, dynamic> json) =>
      _$TaskItemFromJson(json);

  Map<String, dynamic> toJson() => _$TaskItemToJson(this);

  TaskItem copyWith({
    String? id,
    String? name,
    String? description,
    String? listId,
    bool? status,
  }) => TaskItem(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
    listId: listId ?? this.listId,
    status: status ?? this.status,
  );

  final String id;
  final String listId;
  final String name;
  final String description;
  final bool status;

  @override
  List<Object?> get props => [id, name];
}
