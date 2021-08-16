import 'package:flutter/material.dart';

import 'package:flutter_movies/src/components/typography/typography.dart';

import 'package:flutter_movies/src/models/tags/tag.dart';
import 'package:flutter_movies/src/models/todos/todo_short.dart';
import 'package:flutter_movies/src/screens/tags/tag_list.dart';
import 'package:flutter_movies/src/utils/tag_colors.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:localstorage/localstorage.dart';

import 'package:flutter_movies/src/utils/storage_types.dart';

class CreateTodo extends StatefulWidget {
  final Function({required TodoShort todo}) addTodo;
  final TodoShort? todoForEdit;

  CreateTodo({required this.addTodo, this.todoForEdit});

  @override
  _CreateTodoState createState() => _CreateTodoState();
}

class _CreateTodoState extends State<CreateTodo> {
  List<Tag> tags = [];
  Tag? selectedTag;

  String screenTitle = 'Новая задача';

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  final LocalStorage tagsStorage = LocalStorage(StorageTypes.TAGS_LIST.toString());
  bool storageInitialized = false;

  final List<MaterialColor> colors = TagColors.colors;

  /// --> Создаёт объект таска.
  TodoShort _createTodo() {
    if (widget.todoForEdit != null) {
      TodoShort editedTodo = TodoShort(
          title: _titleController.text,
          description: _descriptionController.text,
          isCompleted: widget.todoForEdit!.isCompleted,
          createdAt: widget.todoForEdit!.createdAt,
          selectedTag: selectedTag,
          completedAt: widget.todoForEdit!.completedAt);

      return editedTodo;
    }

    TodoShort newTodo = TodoShort(
        title: _titleController.text,
        description: _descriptionController.text,
        isCompleted: false,
        createdAt: DateTime.now().toLocal(),
        selectedTag: selectedTag);

    return newTodo;
  }

  /// --> Сохраняет дело.
  _handleSaveTodo() {
    if (_formKey.currentState!.validate()) {
      widget.addTodo(todo: _createTodo());
      Navigator.pop(context);
    }
  }

  /// --> Валидирует поля.
  String? _handleValidate(String? value, String text) {
    if (value == null || value.isEmpty) {
      return text;
    }
    return null;
  }

  /// --> Валидирует поле названия.
  String? _validateTitle(String? value) => _handleValidate(value, 'Заполните название задачи');

  /// --> Валидирует поле названия.
  String? _validateDescription(String? value) => _handleValidate(value, 'Заполните описание задачи');

  /// --> Сайд-эффекты при изменении текста.
  void _onChangeText(String _) {
    if (_titleController.text.length <= 1 || _descriptionController.text.length <= 1) {
      _formKey.currentState!.validate();
    }
  }

  /// --> Обработчик выбора тэга.
  void _handleSelectTag(Tag tag, bool isSelected) {
    if (isSelected) {
      setState(() {
        selectedTag = tag;
      });
    } else {
      setState(() {
        selectedTag = null;
      });
    }
  }

  /// --> Получение данных о тэгах из хранилища.
  Future<void> _getItemsFromStorage() async {
    dynamic storageItems = await tagsStorage.getItem(StorageTypes.TAGS_LIST.toString());
    if (storageItems != null) {
      setState(() {
        tags = TagCollection.fromJson(storageItems).items;
      });
    }
  }

  /// --> Отрисовывает полученные из хранилища тэги.
  Iterable<Widget> _renderTags() {
    return tags.map((tag) => FilterChip(
          showCheckmark: false,
          onSelected: (bool value) => _handleSelectTag(tag, value),
          selected: '${selectedTag?.title}/${selectedTag?.id}' == '${tag.title}/${tag.id}',
          label: ChipTypography(
            text: '#${tag.title}',
            color: Colors.white,
          ),
          selectedColor: colors[tag.colorId],
          checkmarkColor: Colors.white,
        ));
  }

  @override
  void initState() {
    super.initState();
    if (widget.todoForEdit != null) {
      setState(() {
        screenTitle = 'Редактирование задачи';
        selectedTag = widget.todoForEdit!.selectedTag;
      });

      _titleController.text = widget.todoForEdit!.title;
      _descriptionController.text = widget.todoForEdit!.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          actions: [
            IconButton(
              onPressed: _handleSaveTodo,
              icon: Icon(Icons.save),
              tooltip: 'Сохранить',
            )
          ],
          title: AppBarTypography(
            text: screenTitle,
          )),
      body: Container(
          child: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(8),
                    child: TextFormField(
                        controller: _titleController,
                        validator: _validateTitle,
                        onChanged: _onChangeText,
                        textCapitalization: TextCapitalization.sentences,
                        style: GoogleFonts.openSans(),
                        decoration: InputDecoration(
                          filled: true,
                          labelText: 'Название',
                        )),
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    child: TextFormField(
                        controller: _descriptionController,
                        validator: _validateDescription,
                        textCapitalization: TextCapitalization.sentences,
                        onChanged: _onChangeText,
                        minLines: 1,
                        maxLines: 4,
                        style: GoogleFonts.openSans(),
                        decoration: InputDecoration(
                          filled: true,
                          labelText: 'Описание задачи',
                        )),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.all(8),
                    child: FutureBuilder(
                      future: tagsStorage.ready,
                      builder: (BuildContext context, snapshot) {
                        if (snapshot.data == true) {
                          if (!storageInitialized) {
                            _getItemsFromStorage();
                            storageInitialized = true;
                          }
                          if (tags.isNotEmpty) {
                            return Wrap(
                              spacing: 8,
                              children: _renderTags().toList(),
                            );
                          }
                          return Center(
                            child: Column(
                              children: [
                                BodyTypography(text: 'Список тэгов пока пуст...'),
                                TextButton(
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                                        return TagList(
                                          updateStorageFromOtherScreen: _getItemsFromStorage,
                                        );
                                      }));
                                    },
                                    child: ButtonTypography(
                                      text: 'Создать тэг',
                                      toUpperCase: true,
                                      color: Colors.blueAccent,
                                    ))
                              ],
                            ),
                          );
                        }
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
