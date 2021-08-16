import 'package:flutter_movies/src/models/tags/tag.dart';

import 'package:json_annotation/json_annotation.dart';

part 'todo_short.g.dart';

@JsonSerializable()
class TodoShort {
  String title;
  String description;
  bool isCompleted;
  DateTime createdAt;
  Tag? selectedTag;
  DateTime? completedAt;

  TodoShort(
      {required this.title,
      required this.description,
      required this.isCompleted,
      required this.createdAt,
      this.selectedTag,
      this.completedAt});

  factory TodoShort.fromJson(Map<String, dynamic> json) => _$TodoShortFromJson(json);

  Map<String, dynamic> toJson() => _$TodoShortToJson(this);
}

@JsonSerializable(explicitToJson: true)
class TodoShortCollection {
  List<TodoShort> items;

  TodoShortCollection({required this.items});

  factory TodoShortCollection.fromJson(Map<String, dynamic> json) => _$TodoShortCollectionFromJson(json);

  Map<String, dynamic> toJson() => _$TodoShortCollectionToJson(this);
}
