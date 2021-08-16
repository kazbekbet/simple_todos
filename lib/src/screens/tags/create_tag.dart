import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_movies/src/components/typography/typography.dart';

import 'package:flutter_movies/src/models/tags/tag.dart';
import 'package:flutter_movies/src/utils/tag_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateTag extends StatefulWidget {
  final void Function({required Tag tag}) addTag;
  final List<Tag> tags;

  const CreateTag({Key? key, required this.addTag, required this.tags}) : super(key: key);

  @override
  _CreateTagState createState() => _CreateTagState();
}

class _CreateTagState extends State<CreateTag> {
  MaterialColor? selectedColor;

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();

  final List<MaterialColor> colors = TagColors.colors;

  String? _handleValidateField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Поле обязательно для заполнения';
    }
    return null;
  }

  void _addNewTag() {
    bool isTitleExist = _formKey.currentState!.validate();
    bool isColorSelected = selectedColor != null;

    if (!isColorSelected) {
      final snackBar = SnackBar(content: Text('Выберите цвет'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    if (isTitleExist && isColorSelected) {
      Tag newTag = Tag(
        id: Tag.count,
        title: _titleController.text,
        colorId: colors.indexOf(selectedColor as MaterialColor),
      );

      widget.addTag(tag: newTag);
      Navigator.pop(context);
    }
  }

  bool isSelectedColor(MaterialColor color) => color == selectedColor;

  Widget _colorContainer(MaterialColor color) {
    return Material(
      borderRadius: BorderRadius.all(Radius.circular(16.00)),
      color: color,
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(16.00)),
        onTap: () {
          if (!isSelectedColor(color)) {
            setState(() {
              selectedColor = color;
            });
          }
        },
        child: isSelectedColor(color)
            ? Center(
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 32,
                ),
              )
            : Container(),
      ),
    );
  }

  Widget _renderColorsSet() {
    return GridView.count(
      primary: false,
      padding: const EdgeInsets.all(16),
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      crossAxisCount: 4,
      children: colors.map((color) => _colorContainer(color)).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: AppBarTypography(
            text: 'Создание тэгов',
          ),
          actions: [
            IconButton(
              onPressed: _addNewTag,
              icon: Icon(Icons.save),
              tooltip: 'Сохранить тэг',
            )
          ],
        ),
        body: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    child: TextFormField(
                        controller: _titleController,
                        validator: _handleValidateField,
                        onChanged: (_) => _formKey.currentState!.validate(),
                        textCapitalization: TextCapitalization.sentences,
                        style: GoogleFonts.openSans(),
                        decoration: InputDecoration(
                          filled: true,
                          labelText: 'Название тэга',
                        )),
                  ),
                ],
              ),
            ),
            Expanded(child: _renderColorsSet()),
          ],
        ));
  }
}
