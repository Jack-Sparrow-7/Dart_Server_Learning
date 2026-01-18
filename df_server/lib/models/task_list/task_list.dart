import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'task_list.g.dart';

@JsonSerializable()
class TaskList extends Equatable {
  const TaskList({required this.id, required this.name});

  factory TaskList.fromJson(Map<String, dynamic> json) =>
      _$TaskListFromJson(json);

  Map<String, dynamic> toJson() => _$TaskListToJson(this);

  TaskList copyWith({String? id, String? name}) =>
      TaskList(id: id ?? this.id, name: name ?? this.name);

  final String id;
  final String name;

  @override
  List<Object?> get props => [id, name];
}
