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
import 'package:subtitle_wand/design/color_palette.dart';
import 'package:subtitle_wand/pages/home.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Subtitle Wand',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // See https://github.com/flutter/flutter/wiki/Desktop-shells#fonts
        fontFamily: 'Roboto',
        textTheme: TextTheme(
          headline6: TextStyle(
            color: ColorPalette.fontColor
          ),
          subtitle2: TextStyle(
            color: ColorPalette.fontColor
          ),
          subtitle1: TextStyle(
            color: ColorPalette.fontColor
          ),
          caption: TextStyle(
            color: ColorPalette.fontColor
          ),
        )
      ),
      home: HomePage()// HomePage(),//MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}