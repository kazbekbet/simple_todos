import 'package:flutter/material.dart';
import 'package:flutter_movies/src/components/buttons/tab_button.dart';

import 'package:localstorage/localstorage.dart';

import 'package:flutter_movies/src/models/todos/todo_short.dart';

import 'package:flutter_movies/src/screens/tags/tag_list.dart';
import 'package:flutter_movies/src/screens/todos/create_todo.dart';
import 'package:flutter_movies/src/screens/todos/todo_list.dart';

import 'package:flutter_movies/src/components/dialogs/simple_dialog.dart';
import 'package:flutter_movies/src/components/typography/typography.dart';

import 'package:flutter_movies/src/utils/storage_types.dart';
import 'package:flutter_movies/src/utils/todo_tabs.dart';

/// --> Большой компонент списка дел с табами.
class TodoTabController extends StatefulWidget {
  const TodoTabController({Key? key}) : super(key: key);

  @override
  _TodoTabControllerState createState() => _TodoTabControllerState();
}

class _TodoTabControllerState extends State<TodoTabController> with SingleTickerProviderStateMixin {
  List<TodoShort> todos = [];

  final LocalStorage storage = LocalStorage(StorageTypes.TODOS.toString());
  bool storageInitialized = false;

  TabTypes currentTab = TabTypes.ACTIVE;

  late SimpleAlertDialog<String> deleteActiveTasksDialog;
  bool deleteActiveTasksDialogInitialized = false;

  late SimpleAlertDialog<String> deleteCompletedTasksDialog;
  bool deleteCompletedTasksDialogInitialized = false;

  /// --> Обработчик нажатия на таб.
  void _changeCurrentTab(int index) {
    switch (index) {
      case 0:
        _setCurrentTab(TabTypes.ACTIVE);
        break;
      case 1:
        _setCurrentTab(TabTypes.CLOSED);
        break;
    }
  }

  /// --> Установка текущего таба.
  void _setCurrentTab(TabTypes type) {
    if (currentTab != type) {
      setState(() {
        currentTab = type;
      });
    }
  }

  /// --> Обработчик добавления таска.
  void _addTodo({required TodoShort todo}) {
    setState(() {
      todos = [todo, ...todos];
    });
    _saveDataToStorage();
  }

  /// --> Редактирование таска.
  void _editTodo({required TodoShort todo}) {
    int findIndexTodo = todos.indexWhere((existedTodo) => existedTodo.createdAt == todo.createdAt);
    if (findIndexTodo != -1) {
      List<TodoShort> updatedList = [...todos];
      updatedList[findIndexTodo] = todo;
      _updateList(updatedList);
    }
  }

  /// --> Обновление списка.
  void _updateList(List<TodoShort> updatedList) {
    setState(() {
      todos = updatedList;
    });
    _saveDataToStorage();
  }

  /// --> Поиск и обработка по статусу завершенности.
  void _findAndUpdateByStatus({required TodoShort todo, required bool isCompletedStatus}) {
    TodoShort findTodo = todos.firstWhere((element) => element.createdAt == todo.createdAt)
      ..isCompleted = isCompletedStatus
      ..completedAt = todo.completedAt;
    Iterable<TodoShort> sortedTodos = todos.where((element) => element.createdAt != findTodo.createdAt).toList();
    _updateList([findTodo, ...sortedTodos]);
  }

  /// --> Пометка таска как выполненного.
  void _markTodoAsCompleted(TodoShort todo) {
    _findAndUpdateByStatus(todo: todo, isCompletedStatus: true);
  }

  /// --> Возврат таска в работу.
  void _returnTaskToWork(TodoShort todo) {
    _findAndUpdateByStatus(todo: todo, isCompletedStatus: false);
  }

  /// --> Сохранение данных в хранилище.
  Future<void> _saveDataToStorage() async {
    await _clearStorage();
    TodoShortCollection todosCollection = TodoShortCollection(items: todos);
    await storage.setItem(StorageTypes.TODOS.toString(), todosCollection.toJson());
  }

  /// --> Получение и установка данных их хранилища.
  Future<void> _getStorageData() async {
    dynamic storageItems = await storage.getItem(StorageTypes.TODOS.toString());
    if (storageItems != null) {
      TodoShortCollection storageTodos = TodoShortCollection.fromJson(storageItems);

      setState(() {
        todos = storageTodos.items;
      });
    }
  }

  /// --> Очистка хранилища.
  Future<void> _clearStorage() async {
    await storage.deleteItem(StorageTypes.TODOS.toString());
  }

  /// --> Возвращает список дел по статусу.
  List<TodoShort> _getTasksByStatus({required bool isCompleted}) {
    return todos.where((todo) => todo.isCompleted == isCompleted).toList();
  }

  /// --> Удаление определенной задачи.
  void _deleteTodo(TodoShort todoShort) {
    List<TodoShort> newTodos = todos
        .where((todo) => '${todo.title}/${todo.createdAt}' != '${todoShort.title}/${todoShort.createdAt}')
        .toList();
    setState(() {
      todos = newTodos;
    });

    _saveDataToStorage();
  }

  /// --> Очистка всех дел по статусу.
  void _clearAllTodosByStatus({required bool isCompleted}) {
    List<TodoShort> newTodos = todos.where((todo) => todo.isCompleted != isCompleted).toList();
    setState(() {
      todos = newTodos;
    });

    _saveDataToStorage();
  }

  /// --> Обработчик нажатия на переход к экрану создания таска.
  void _navigateCreateTodo() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return CreateTodo(
        addTodo: _addTodo,
      );
    }));
  }

  /// --> Обработчик нажатия на переход к тэгам.
  void _navigateToTagScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return TagList();
    }));
  }

  /// --> Отображает диалог удаления всех тасков по типу завершенности.
  Future<String?> _handlePressDelete() {
    if (currentTab == TabTypes.ACTIVE) {
      if (!deleteActiveTasksDialogInitialized) {
        deleteActiveTasksDialog = SimpleAlertDialog<String>(
            context: context,
            title: 'Удаление активных задач',
            body: 'Вы уверены, что желаете удалить все активные задачи?',
            onConfirm: () {
              _clearAllTodosByStatus(isCompleted: false);
            });
        deleteActiveTasksDialogInitialized = true;
      }

      return deleteActiveTasksDialog.show();
    }

    if (!deleteCompletedTasksDialogInitialized) {
      deleteCompletedTasksDialog = SimpleAlertDialog<String>(
          context: context,
          title: 'Удаление завершенных задач',
          body: 'Вы уверены, что желаете удалить все завершенные задачи?',
          onConfirm: () {
            _clearAllTodosByStatus(isCompleted: true);
          });
      deleteCompletedTasksDialogInitialized = true;
    }

    return deleteCompletedTasksDialog.show();
  }

  /// --> Сеттит состояние кнопки удаления.
  void Function()? _setDeleteButtonStatus() {
    if (currentTab == TabTypes.ACTIVE) {
      var hasActiveTodos = _countActiveTodos();
      if (hasActiveTodos != null) return _handlePressDelete;
      return null;
    }

    if (currentTab == TabTypes.CLOSED) {
      var hasClosedTodos = _countClosedTodos();
      if (hasClosedTodos != null) return _handlePressDelete;
      return null;
    }
  }

  /// --> Вовзращает плавающую кнопку.
  Widget? _renderFloatingActionButton() {
    if (currentTab == TabTypes.ACTIVE) {
      return FloatingActionButton(
        onPressed: _navigateCreateTodo,
        child: Icon(Icons.add),
        tooltip: 'Добавить дело',
      );
    }
  }

  /// --> Возвращает количество активных задач.
  int? _countActiveTodos() {
    List<TodoShort> activeTodos = _getTasksByStatus(isCompleted: false);
    if (activeTodos.length > 0) return activeTodos.length;
  }

  /// --> Возвращает количество закрытых задач.
  int? _countClosedTodos() {
    List<TodoShort> closedTodos = _getTasksByStatus(isCompleted: true);
    if (closedTodos.length > 0) return closedTodos.length;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Builder(
          builder: (BuildContext context) {
            final TabController tabController = DefaultTabController.of(context)!;
            tabController.addListener(() {
              if (!tabController.indexIsChanging) {
                _changeCurrentTab(tabController.index);
              }
            });

            return FutureBuilder(
              future: storage.ready,
              builder: (BuildContext context, snapshot) {
                if (snapshot.data == true) {
                  if (!storageInitialized) {
                    _getStorageData();
                    storageInitialized = true;
                  }
                  return Scaffold(
                    appBar: AppBar(
                      title: AppBarTypography(text: 'Мои задачи'),
                      actions: [
                        IconButton(
                          onPressed: _navigateToTagScreen,
                          icon: Icon(Icons.tag),
                          tooltip: 'Список тэгов',
                        ),
                        IconButton(
                          onPressed: _setDeleteButtonStatus(),
                          icon: Icon(Icons.delete_outline),
                          tooltip: 'Очистка списка',
                        )
                      ],
                      bottom: TabBar(
                        onTap: _changeCurrentTab,
                        tabs: [
                          TabButton(
                              text:
                                  'Активные ${_countActiveTodos() != null ? '(${_countActiveTodos().toString()})' : ''}',
                              isActive: currentTab == TabTypes.ACTIVE),
                          TabButton(
                              text:
                                  'Завершенные ${_countClosedTodos() != null ? '(${_countClosedTodos().toString()})' : ''}',
                              isActive: currentTab == TabTypes.CLOSED),
                        ],
                      ),
                    ),
                    body: TabBarView(
                      children: [
                        TodoList(
                          key: Key(TabTypes.ACTIVE.toString()),
                          todos: todos,
                          type: TabTypes.ACTIVE,
                          markAsCompleted: _markTodoAsCompleted,
                          returnToWork: _returnTaskToWork,
                          deleteTask: _deleteTodo,
                          editTodo: _editTodo,
                        ),
                        TodoList(
                          key: Key(TabTypes.CLOSED.toString()),
                          todos: todos,
                          type: TabTypes.CLOSED,
                          markAsCompleted: _markTodoAsCompleted,
                          returnToWork: _returnTaskToWork,
                          deleteTask: _deleteTodo,
                          editTodo: _editTodo,
                        )
                      ],
                    ),
                    floatingActionButton: _renderFloatingActionButton(),
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            );
          },
        ));
  }
}
