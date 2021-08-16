import 'package:flutter/material.dart';

import 'package:flutter_movies/src/components/dialogs/simple_dialog.dart';
import 'package:flutter_movies/src/components/typography/typography.dart';

import 'package:flutter_movies/src/models/todos/todo_short.dart';
import 'package:flutter_movies/src/screens/todos/create_todo.dart';
import 'package:flutter_movies/src/utils/date_time_utils.dart';
import 'package:flutter_movies/src/utils/tag_colors.dart';

class TodoDetailedInfo extends StatelessWidget {
  final TodoShort todo;
  final Function closeModal;
  final Function completeTask;
  final Function returnToWorkTask;
  final Function() deleteTask;
  final Function({required TodoShort todo}) editTodo;

  final List<MaterialColor> colors = TagColors.colors;
  late SimpleAlertDialog<String> deleteTaskDialog;
  bool deleteTaskDialogInitialized = false;

  TodoDetailedInfo({Key? key,
    required this.todo,
    required this.closeModal,
    required this.completeTask,
    required this.returnToWorkTask,
    required this.deleteTask,
    required this.editTodo})
      : super(key: key);

  /// --> Модальное окно удаления задачи.
  Future<String?> _showDeleteTaskDialog(BuildContext context) {
    if (!deleteTaskDialogInitialized) {
      deleteTaskDialog = SimpleAlertDialog<String>(
          context: context,
          title: 'Удалить задачу',
          body: 'Вы уверены, что желаете удалить задачу?',
          onConfirm: () {
            deleteTask();
            closeModal();
          });

      deleteTaskDialogInitialized = true;
    }

    return deleteTaskDialog.show();
  }

  /// --> Рендерит верхние кнопки действий.
  Widget _renderTopButtons(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                tooltip: 'Удалить задачу',
                onPressed: () {
                  _showDeleteTaskDialog(context);
                },
                icon: Icon(
                  Icons.delete_outline,
                  color: Colors.redAccent,
                ),
              ),
              IconButton(
                tooltip: 'Редактировать',
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return CreateTodo(
                      addTodo: editTodo,
                      todoForEdit: todo,
                    );
                  }));
                },
                icon: Icon(
                  Icons.edit_outlined,
                  color: Colors.blueAccent,
                ),
              ),
            ],
          ),
          Container(
            child: IconButton(
              tooltip: 'Закрыть окно',
              onPressed: () {
                closeModal();
              },
              icon: Icon(
                Icons.close_rounded,
                color: Colors.black38,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// --> Рендерит тэг таска.
  Widget _renderTag() {
    if (todo.selectedTag != null) {
      return Container(
          child: Chip(
            label: ChipTypography(
              text: '#${todo.selectedTag!.title}',
              color: Colors.white,
            ),
            backgroundColor: colors[todo.selectedTag!.colorId],
          ));
    }
    return Container();
  }

  Widget _setCompletedTaskDate() {
    if (todo.completedAt != null) {
      return Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 4, bottom: 4),
            child: CaptionTypography(
              text: 'Дата завершения задачи: ${DateTimeUtils.getDateTimeByStandardFormat(date: todo.completedAt!)}',
            ),
          )
        ],
      );
    }

    return Container();
  }

  /// --> Рендерит дату и окончания задачи.
  Widget _setCompletedAtDate() {
    if (todo.completedAt != null) {
      return Container(
        padding: EdgeInsets.only(top: 4, bottom: 4),
        child: CaptionTypography(
          text: 'Дата завершения задачи: ${DateTimeUtils.getDateTimeByStandardFormat(date: todo.completedAt!)}',
        ),
      );
    }
    return Container();
  }

  /// --> Рендерит затраченное время на задачу.
  Widget _setSpentTime() {
    if (todo.completedAt != null) {
      var spentTimeResults = DateTimeUtils.getDifferenceByFormat(fromDate: todo.completedAt!, toDate: todo.createdAt);

      return Container(
        padding: EdgeInsets.only(top: 4, bottom: 4),
        child: CaptionTypography(
          text: 'Затраченное время: $spentTimeResults',
        ),
      );
    }
    return Container();
  }

  /// --> Рендерит контент таска.
  Widget _renderContent() {
    return Container(
      padding: EdgeInsets.only(top: 8, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(top: 4, bottom: 4),
            child: TitleTypography(text: todo.title),
          ),
          Container(
            padding: EdgeInsets.only(top: 4, bottom: 4),
            child: BodyTypography(text: todo.description),
          ),
          Container(
            padding: EdgeInsets.only(top: 4, bottom: 4),
            child: _renderTag(),
          ),
          Container(
            padding: EdgeInsets.only(top: 4, bottom: 4),
            child: CaptionTypography(
              text: 'Дата создания задачи: ${DateTimeUtils.getDateTimeByStandardFormat(date: todo.createdAt)}',
            ),
          ),
          _setCompletedAtDate(),
          _setSpentTime(),
        ],
      ),
    );
  }

  /// --> Рендерит кнопки действий над таском.
  Widget _renderActions() {
    return Container(
      constraints: BoxConstraints(minWidth: double.infinity),
      padding: EdgeInsets.only(top: 8, bottom: 8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: !todo.isCompleted ? Colors.blueAccent : Colors.redAccent,
            shape: StadiumBorder(),
            padding: EdgeInsets.all(12)),
        child: ButtonTypography(
          text: !todo.isCompleted ? 'Выполнить задачу' : 'Вернуть в работу',
          color: Colors.white,
          toUpperCase: true,
        ),
        onPressed: () {
          if (!todo.isCompleted) {
            completeTask();
          } else {
            returnToWorkTask();
          }
          closeModal();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Material(
                elevation: 1,
                child: Container(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    children: [
                      _renderTopButtons(context),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [_renderContent(), _renderActions()],
                    )),
              )
            ],
          ),
        ));
  }
}
