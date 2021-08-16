import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter_movies/src/components/dialogs/simple_dialog.dart';
import 'package:flutter_movies/src/components/typography/typography.dart';

import 'package:flutter_movies/src/models/tags/tag.dart';
import 'package:flutter_movies/src/screens/tags/create_tag.dart';
import 'package:flutter_movies/src/utils/storage_types.dart';
import 'package:flutter_movies/src/utils/tag_colors.dart';

import 'package:localstorage/localstorage.dart';

class TagList extends StatefulWidget {
  final Function? updateStorageFromOtherScreen;

  const TagList({Key? key, this.updateStorageFromOtherScreen}) : super(key: key);

  @override
  _TagListState createState() => _TagListState();
}

class _TagListState extends State<TagList> {
  List<Tag> tags = [];

  final List<MaterialColor> colors = TagColors.colors;
  final LocalStorage storage = LocalStorage(StorageTypes.TAGS_LIST.toString());
  bool storageInitialized = false;

  late SimpleAlertDialog<String> deleteAllDialog;
  bool deleteAllDialogIsInitialized = false;

  late SimpleAlertDialog<String> deleteTagDialog;

  /// --> Обработчик добавления тэга.
  void _addTag({required Tag tag}) async {
    List<Tag> updatedTags = [tag, ...tags];

    setState(() {
      tags = updatedTags;
    });

    await _saveToStorage(value: updatedTags);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Тэг успешно добавлен!')));

    if (widget.updateStorageFromOtherScreen != null) {
      widget.updateStorageFromOtherScreen!();
    }
  }

  /// --> Сохранение данных в хранилище.
  Future<void> _saveToStorage({required List<Tag> value}) async {
    await _clearStorage();
    TagCollection storageJSON = TagCollection(items: value);
    await storage.setItem(StorageTypes.TAGS_LIST.toString(), storageJSON.toJson());
  }

  /// --> Очистка хранилища
  Future<void> _clearStorage() async {
    await storage.deleteItem(StorageTypes.TAGS_LIST.toString());
  }

  /// --> Очистка и обновление состояния.
  Future<void> _clearAndUpdate() async {
    await _clearStorage();
    setState(() {
      tags = [];
    });
  }

  /// --> Получение данных их хранилища.
  Future<void> _getItemsFromStorage() async {
    dynamic storageItems = await storage.getItem(StorageTypes.TAGS_LIST.toString());
    if (storageItems != null) {
      setState(() {
        tags = TagCollection.fromJson(storageItems).items;
      });
    }
  }

  /// --> Удаление всех тэгов.
  void _deleteTag(Tag tag) {
    var filteredTags = tags.where((element) => '${tag.title}/${tag.id}' != '${element.title}/${element.id}').toList();
    _saveToStorage(value: filteredTags);
    setState(() {
      tags = filteredTags;
    });
  }

  /// --> Инициализация и отображение диалога удаления определенного тэга.
  Future<String?> _showDeleteTagConfirmationDialog(Tag tag) {
    deleteTagDialog = SimpleAlertDialog<String>(
        context: context,
        title: 'Удаление тега',
        body: 'Вы уверены, что желаете удалить тэг "${tag.title}"?',
        onConfirm: () => _deleteTag(tag));

    return deleteTagDialog.show();
  }

  /// --> Инициализация и отображение диалога очистки всех тэгов.
  Future<String?> _showDeleteAllConfirmationDialog() {
    if (!deleteAllDialogIsInitialized) {
      deleteAllDialog = SimpleAlertDialog<String>(
          context: context,
          title: 'Удаление всех тэгов',
          body: 'Вы уверены, что желаете удалить весь список тэгов?',
          onConfirm: _clearAndUpdate);

      deleteAllDialogIsInitialized = true;
    }

    return deleteAllDialog.show();
  }

  /// --> Возвращает все тэги.
  Iterable<Widget> _renderTags() {
    return tags.map((tag) => Chip(
          deleteIcon: Icon(
            Icons.cancel_outlined,
            color: Colors.white,
          ),
          onDeleted: () => _showDeleteTagConfirmationDialog(tag),
          label: ChipTypography(
            text: '#${tag.title}',
            color: Colors.white,
          ),
          backgroundColor: colors[tag.colorId],
        ));
  }

  /// --> Обработчик нажатия кнопки добавления.
  void _handlePressFAB() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return CreateTag(
        addTag: _addTag,
        tags: tags,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarTypography(text: 'Список тэгов'),
        actions: [
          IconButton(
            onPressed: tags.isNotEmpty ? _showDeleteAllConfirmationDialog : null,
            icon: Icon(Icons.delete_outline),
            tooltip: 'Удалить все тэги',
          )
        ],
      ),
      body: Container(
          padding: EdgeInsets.all(12),
          child: Container(
              child: FutureBuilder(
            future: storage.ready,
            builder: (BuildContext context, snapshot) {
              if (snapshot.data == true) {
                if (!storageInitialized) {
                  _getItemsFromStorage();
                  storageInitialized = true;
                }

                if (tags.isEmpty) {
                  return Center(
                    child: BodyTypography(text: 'Список тэгов пока пуст...'),
                  );
                }
                return Wrap(
                  spacing: 8,
                  children: _renderTags().toList(),
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ))),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _handlePressFAB,
        label: ButtonTypography(
          text: 'Добавить',
          color: Colors.white,
          toUpperCase: true,
        ),
        icon: Icon(Icons.add),
        tooltip: 'Добавить тэг',
      ),
    );
  }
}
