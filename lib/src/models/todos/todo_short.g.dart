// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_short.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TodoShort _$TodoShortFromJson(Map<String, dynamic> json) {
  return TodoShort(
    title: json['title'] as String,
    description: json['description'] as String,
    isCompleted: json['isCompleted'] as bool,
    createdAt: DateTime.parse(json['createdAt'] as String),
    selectedTag: json['selectedTag'] == null
        ? null
        : Tag.fromJson(json['selectedTag'] as Map<String, dynamic>),
    completedAt: json['completedAt'] == null
        ? null
        : DateTime.parse(json['completedAt'] as String),
  );
}

Map<String, dynamic> _$TodoShortToJson(TodoShort instance) => <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'isCompleted': instance.isCompleted,
      'createdAt': instance.createdAt.toIso8601String(),
      'selectedTag': instance.selectedTag,
      'completedAt': instance.completedAt?.toIso8601String(),
    };

TodoShortCollection _$TodoShortCollectionFromJson(Map<String, dynamic> json) {
  return TodoShortCollection(
    items: (json['items'] as List<dynamic>)
        .map((e) => TodoShort.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$TodoShortCollectionToJson(
        TodoShortCollection instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
    };
