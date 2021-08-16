import 'package:flutter/material.dart';
import 'package:flutter_movies/src/models/todos/todo_short.dart';
import 'package:intl/intl.dart';

class TodoCard extends StatelessWidget {
  final TodoShort todo;
  final void Function(TodoShort todo) markAsCompleted;

  TodoCard({required this.todo, required this.markAsCompleted});

  String _setStatus() {
    if (todo.isCompleted) return 'Выполнено!';
    return 'В процессе';
  }

  void _handlePress() {}

  Future<String?> _showDeleteConfirmationDialog(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Пометить как выполнено'),
        content: const Text(
            'Вы уверены, выполнили дело и готовы его пометить завершенным?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: Text('Отмена'.toUpperCase()),
          ),
          TextButton(
            onPressed: () {
              markAsCompleted(todo);
              Navigator.pop(context, 'OK');
            },
            child: Text('Подтвердить'.toUpperCase()),
          ),
        ],
      ),
    );
  }

  void _handleLongPress(BuildContext context) {
    if (!todo.isCompleted) {
      _showDeleteConfirmationDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onLongPress: () => _handleLongPress(context),
      child: Card(
          child: InkWell(
        onTap: _handlePress,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              minLeadingWidth: 8,
              leading: CircleAvatar(
                backgroundColor:
                    todo.isCompleted ? Colors.green : Colors.redAccent,
                radius: 12,
              ),
              trailing: Text(_setStatus()),
              title: Text(
                  '${DateFormat("dd/MM").format(DateTime.parse('${todo.createdAt}'))} ${todo.title}'),
              subtitle: Text(todo.description),
            ),
          ],
        ),
      )),
    );
  }
}
