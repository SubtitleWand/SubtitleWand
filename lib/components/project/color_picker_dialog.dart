// Copyright (C) 2020 Tokenyet
// 
// This file is part of subtitle-wand.
// 
// subtitle-wand is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// subtitle-wand is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with subtitle-wand.  If not, see <http://www.gnu.org/licenses/>.

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:subtitle_wand/design/color_palette.dart';

class ColorPickerDialog extends StatefulWidget {
  final Color initColor;
  ColorPickerDialog({Key key, this.initColor}) : super(key: key);

  @override
  ColorPickerDialogState createState() => ColorPickerDialogState();
}

class ColorPickerDialogState extends State<ColorPickerDialog> {
  Color pickerColor = Color(0xff000000);
  // Color currentColor = Color(0xff000000);
  @override
  void initState() {
    super.initState();
    pickerColor = widget.initColor ?? pickerColor;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ColorPalette.accentColor,
      title: const Text('Pick a color!'),
      content: SingleChildScrollView(
        child: Theme(
          data: Theme.of(context).copyWith(canvasColor: ColorPalette.secondaryColor, textTheme: TextTheme(bodyText2: TextStyle(color: ColorPalette.primaryColor))),
          child: ColorPicker(
            pickerColor: pickerColor,
            onColorChanged: (Color changedColor){
              pickerColor = changedColor;
            },
            enableLabel: true,
            pickerAreaHeightPercent: 0.8,
          )
        )
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Cancel', style: Theme.of(context).textTheme.subtitle2),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text('Select', style: Theme.of(context).textTheme.subtitle2,),
          onPressed: () {
            Navigator.of(context).pop(pickerColor);
          },
        ),
      ]
    );
  }
}