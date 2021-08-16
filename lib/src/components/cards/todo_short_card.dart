import 'package:flutter/material.dart';
import 'package:flutter_movies/src/components/cards/todo_detailed_info.dart';

import 'package:flutter_movies/src/components/dialogs/simple_dialog.dart';
import 'package:flutter_movies/src/components/typography/typography.dart';

import 'package:flutter_movies/src/models/todos/todo_short.dart';
import 'package:flutter_movies/src/utils/tag_colors.dart';
import 'package:intl/intl.dart';

/// --> Карточка дела.
class TodoShortCard extends StatelessWidget {
  final TodoShort todoShort;
  final Function(TodoShort todo) markAsCompleted;
  final Function(TodoShort todo) returnToWork;
  final Function(TodoShort todo) deleteTask;
  final Function({required TodoShort todo}) editTodo;

  late SimpleAlertDialog<String> returnToWorkDialog;
  bool returnToWorkDialogInitialized = false;

  late SimpleAlertDialog<String> markAsCompletedDialog;
  bool markAsCompletedDialogInitialized = false;

  TodoShortCard(
      {Key? key,
      required this.todoShort,
      required this.markAsCompleted,
      required this.returnToWork,
      required this.deleteTask,
      required this.editTodo})
      : super(key: key);

  final List<MaterialColor> colors = TagColors.colors;

  /// --> Отображает статус выполнения.
  Widget _renderStatus() {
    Widget iconInProcess = Icon(Icons.adjust, color: Colors.redAccent);
    Widget iconCompleted = Icon(Icons.check_circle_outline, color: Colors.green);

    return Container(
      padding: EdgeInsets.all(8),
      child: todoShort.isCompleted ? iconCompleted : iconInProcess,
    );
  }

  /// --> Отображает описание дела.
  Widget _renderContent() {
    Widget renderTag() {
      if (todoShort.selectedTag != null) {
        return Container(
            child: Chip(
          label: ChipTypography(
            text: '#${todoShort.selectedTag!.title}',
            color: Colors.white,
          ),
          backgroundColor: colors[todoShort.selectedTag!.colorId],
        ));
      }
      return Container();
    }

    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 240,
            padding: EdgeInsets.only(bottom: 8),
            child: SubtitleTypography(
              text: todoShort.title,
              textOverflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          Container(
            width: 240,
            padding: EdgeInsets.only(bottom: 8),
            child: BodyTypography(
              text: todoShort.description,
              textOverflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          renderTag(),
        ],
      ),
    );
  }

  /// --> Отображает дату создания.
  Widget _renderCreatedAt() {
    return Container(
      padding: EdgeInsets.all(8),
      child: CaptionTypography(
        text: DateFormat("dd/MM").format(DateTime.parse(todoShort.createdAt.toString())),
      ),
    );
  }

  /// --> Отображает SnackBar.
  void _showSnackBar({required String text, required BuildContext context}) {
    final snackBar = SnackBar(content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /// --> Отображает диалог подтверждения возврата в работу.
  Future<String?> _showReturnToWorkDialog(BuildContext context) {
    if (!returnToWorkDialogInitialized) {
      returnToWorkDialog = SimpleAlertDialog<String>(
          context: context,
          title: 'Возврат в работу',
          body: 'Вы уверены, что желаете вернуть задачу «${todoShort.title}» в работу?',
          onConfirm: () {
            returnToWork(todoShort);
            _showSnackBar(text: 'Задача возвращена в работу.', context: context);
          });

      returnToWorkDialogInitialized = true;
    }

    return returnToWorkDialog.show();
  }

  /// --> Отображает диалог подтверждения возврата в работу.
  Future<String?> _showMarkAsCompletedDialog(BuildContext context) {
    if (!markAsCompletedDialogInitialized) {
      returnToWorkDialog = SimpleAlertDialog<String>(
          context: context,
          title: 'Выполнить задачу',
          body: 'Вы уверены, что желаете пометить задачу «${todoShort.title}» как выполненную?',
          onConfirm: () {
            markAsCompleted(todoShort);
            _showSnackBar(text: 'Задача выполнена!', context: context);
          });

      markAsCompletedDialogInitialized = true;
    }

    return returnToWorkDialog.show();
  }

  /// --> Обработчик длительного нажатия.
  void _onLongPress(BuildContext context) {
    if (todoShort.isCompleted) {
      _showReturnToWorkDialog(context);
    } else {
      _showMarkAsCompletedDialog(context);
    }
  }

  /// --> Обработчик нажатия на задачу.
  void _onTap(BuildContext context) {
    showModalBottomSheet(
        context: context,
        elevation: 16,
        builder: (context) {
          return TodoDetailedInfo(
            todo: todoShort,
            closeModal: () {
              Navigator.pop(context);
            },
            completeTask: () {
              markAsCompleted(todoShort);
              _showSnackBar(text: 'Задача выполнена!', context: context);
            },
            returnToWorkTask: () {
              returnToWork(todoShort);
              _showSnackBar(text: 'Задача возвращена в работу.', context: context);
            },
            deleteTask: () {
              deleteTask(todoShort);
              _showSnackBar(text: 'Задача удалена.', context: context);
            },
            editTodo: ({required TodoShort todo}) {
              editTodo(todo: todo);
              Navigator.pop(context);
              _showSnackBar(text: 'Задача обновлена.', context: context);
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onLongPress: () {
        _onLongPress(context);
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            _onTap(context);
          },
          child: Container(
              padding: EdgeInsets.all(8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _renderStatus(),
                      _renderContent(),
                    ],
                  ),
                  _renderCreatedAt()
                ],
              )),
        ),
      ),
    );
  }
}
