import 'package:json_annotation/json_annotation.dart';

part 'tag.g.dart';

@JsonSerializable()
class Tag {
  int id;
  String title;
  int colorId;
  static int count = 0;

  Tag({required this.id, required this.title, required this.colorId}) {
    count++;
  }

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);

  Map<String, dynamic> toJson() => _$TagToJson(this);
}

@JsonSerializable(explicitToJson: true)
class TagCollection {
  List<Tag> items;

  TagCollection({required this.items});

  factory TagCollection.fromJson(Map<String, dynamic> json) => _$TagCollectionFromJson(json);
  Map<String, dynamic> toJson() => _$TagCollectionToJson(this);
}
