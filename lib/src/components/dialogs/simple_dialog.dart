import 'package:flutter/material.dart';

import 'package:flutter_movies/src/components/typography/typography.dart';

/// --> Компонент простейшего диалога.
class SimpleAlertDialog<T> {
  final BuildContext context;
  final String title;
  final String body;

  final String? cancelText;
  final String? confirmText;

  final Function onConfirm;

  SimpleAlertDialog(
      {required this.context,
      required this.title,
      required this.body,
      this.cancelText,
      this.confirmText,
      required this.onConfirm});

  Future<T?> show() {
    return showDialog<T>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: TextTypographyMontserrat(
          text: title,
        ),
        content: TextTypographySans(
          text: body,
          color: Colors.black54,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: TextTypographyMontserrat(
              text: cancelText != null ? cancelText as String : 'Отмена',
              toUpperCase: true,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            child: TextTypographyMontserrat(
              text: confirmText != null ? confirmText as String : 'Подтвердить',
              toUpperCase: true,
            ),
          ),
        ],
      ),
    );
  }
}
