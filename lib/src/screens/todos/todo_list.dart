import 'package:flutter/material.dart';

import 'package:flutter_movies/src/models/todos/todo_short.dart';

import 'package:flutter_movies/src/components/cards/todo_short_card.dart';
import 'package:flutter_movies/src/components/typography/typography.dart';
import 'package:flutter_movies/src/utils/todo_tabs.dart';

/// --> Контейнерный компонент отображения списка дел.
class TodoList extends StatelessWidget {
  final List<TodoShort> todos;
  final TabTypes type;
  final Function(TodoShort todo) markAsCompleted;
  final Function(TodoShort todo) returnToWork;
  final Function(TodoShort todo) deleteTask;
  final Function({required TodoShort todo}) editTodo;

  const TodoList(
      {Key? key,
      required this.todos,
      required this.type,
      required this.markAsCompleted,
      required this.returnToWork,
      required this.deleteTask,
      required this.editTodo})
      : super(key: key);

  /// --> Обработчик завершения задачи.
  void completeTodo(TodoShort todo) {
    TodoShort completedTodo = TodoShort(
        title: todo.title,
        description: todo.description,
        isCompleted: todo.isCompleted,
        createdAt: todo.createdAt,
        selectedTag: todo.selectedTag,
        completedAt: DateTime.now().toLocal());

    markAsCompleted(completedTodo);
  }

  /// --> Обработчик возвращения задачи в работу.
  void returnToWorkTodo(TodoShort todo) {
    TodoShort returnedTodo = TodoShort(
        title: todo.title,
        description: todo.description,
        isCompleted: todo.isCompleted,
        createdAt: todo.createdAt,
        selectedTag: todo.selectedTag);

    returnToWork(returnedTodo);
  }

  /// --> Рендерит список задач.
  Widget _buildTodoList(List<TodoShort> todosList) {
    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: todosList.length,
        itemBuilder: (BuildContext context, int index) {
          return TodoShortCard(
            todoShort: todosList[index],
            markAsCompleted: completeTodo,
            returnToWork: returnToWorkTodo,
            deleteTask: deleteTask,
            editTodo: editTodo,
          );
        });
  }

  /// --> Возвращает только активные задачи.
  Widget _renderActiveTodos() {
    if (todos.length > 0) {
      List<TodoShort> activeTodos = todos.where((todo) => !todo.isCompleted).toList();
      if (activeTodos.length > 0) {
        return _buildTodoList(activeTodos);
      }
      return Center(child: BodyTypography(text: 'Активных задач пока нет'));
    }
    return Center(child: BodyTypography(text: 'Список дел пуст...'));
  }

  /// --> Возвращает только завершенные задачи.
  Widget _renderClosedTodos() {
    if (todos.length > 0) {
      List<TodoShort> closedTodos = todos.where((todo) => todo.isCompleted).toList();
      if (closedTodos.length > 0) {
        return _buildTodoList(closedTodos);
      }
      return Center(child: BodyTypography(text: 'Закрытых задач пока нет'));
    }
    return Center(child: BodyTypography(text: 'Список дел пуст...'));
  }

  /// --> Рендерит список задач в зависимости от типа контейнера.
  Widget _renderTodoList() {
    if (type == TabTypes.ACTIVE) {
      return _renderActiveTodos();
    }

    if (type == TabTypes.CLOSED) {
      return _renderClosedTodos();
    }

    return Center(child: BodyTypography(text: 'Список дел пуст...'));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _renderTodoList(),
    );
  }
}
