import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

/// --> Большой заголовок.
class AppBarTypography extends StatelessWidget {
  final String text;

  const AppBarTypography({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.montserrat(),
    );
  }
}

/// --> Большой заголовок.
class TitleTypography extends StatelessWidget {
  final String text;

  const TitleTypography({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.headline6),
    );
  }
}

/// --> Подзаголовок.
class SubtitleTypography extends StatelessWidget {
  final String text;
  final TextOverflow? textOverflow;
  final int? maxLines;

  const SubtitleTypography({Key? key, required this.text, this.textOverflow, this.maxLines}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.subtitle1),
      overflow: textOverflow,
      maxLines: maxLines,
    );
  }
}

/// --> Текст.
class BodyTypography extends StatelessWidget {
  final String text;
  final TextOverflow? textOverflow;
  final int? maxLines;

  const BodyTypography({Key? key, required this.text, this.textOverflow, this.maxLines}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.openSans(textStyle: Theme.of(context).textTheme.bodyText1, color: Colors.black54),
      overflow: textOverflow,
      maxLines: maxLines,
    );
  }
}

/// --> Подпись.
class CaptionTypography extends StatelessWidget {
  final String text;

  const CaptionTypography({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.openSans(textStyle: Theme.of(context).textTheme.caption, color: Colors.black54),
    );
  }
}

/// --> Текст в кнопке.
class ButtonTypography extends StatelessWidget {
  final String text;
  final Color? color;
  final bool? toUpperCase;

  const ButtonTypography({Key? key, required this.text, this.color, this.toUpperCase}) : super(key: key);

  String _setTextValue() {
    if (toUpperCase == true) {
      return text.toUpperCase();
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _setTextValue(),
      style: GoogleFonts.openSans(
          textStyle: Theme.of(context).textTheme.button, fontWeight: FontWeight.w600, color: color),
    );
  }
}

/// --> Обычное применение шрифта Sans без изменения стилей.
class TextTypographySans extends StatelessWidget {
  final String text;
  final Color? color;

  const TextTypographySans({Key? key, required this.text, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.openSans(color: color),
    );
  }
}

/// --> Обычное применение шрифта TextTypographyMontserrat без изменения стилей.
class TextTypographyMontserrat extends StatelessWidget {
  final String text;
  final bool? toUpperCase;

  const TextTypographyMontserrat({Key? key, required this.text, this.toUpperCase}) : super(key: key);

  String _setTextValue() {
    if (toUpperCase == true) {
      return text.toUpperCase();
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _setTextValue(),
      style: GoogleFonts.montserrat(),
    );
  }
}

/// --> Для chips.
class ChipTypography extends StatelessWidget {
  final String text;
  final Color? color;

  const ChipTypography({Key? key, required this.text, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.montserrat(color: color),
    );
  }
}
