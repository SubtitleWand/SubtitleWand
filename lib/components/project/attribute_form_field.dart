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
import 'package:flutter/services.dart';

/// text for pure text, digit for only positive values, integer for all values
enum AttributeFormFieldType {
  /// All text supported
  text,
  /// value >= 0
  digit,
  /// value [-infinite ~ infinite]
  integer,
}

///
/// Creates an attribute form field that allow maximum length 4, and 
///
class AttributeFormField extends StatelessWidget {
  /// uses controller to listen value changing.
  final TextEditingController controller;
  /// init value
  final String initialValue;
  /// Input type, text, digit(+), integer(+/-)
  final AttributeFormFieldType type;
  /// 
  final bool readOnly;
  
  AttributeFormField({
    Key key,
    this.controller,
    this.initialValue,
    this.type,
    this.readOnly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      inputFormatters: type == AttributeFormFieldType.integer ? 
          [FilteringTextInputFormatter.allow(RegExp(r'^[-]{0,1}\d*$'))] : 
          type == AttributeFormFieldType.digit ?
            [FilteringTextInputFormatter.digitsOnly] : [], 
      decoration: InputDecoration.collapsed(hintText: null,).copyWith(isDense: true, contentPadding: EdgeInsets.only(top: 8)),
      style: Theme.of(context).textTheme.caption,
      textAlign: TextAlign.center,
      maxLength: 4,
      textAlignVertical: TextAlignVertical.center,
      readOnly: readOnly,
      buildCounter: (_, {currentLength, maxLength, isFocused}) => null,
    );
  }
}