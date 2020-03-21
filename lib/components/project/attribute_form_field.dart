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


class AttributeFormField extends StatelessWidget {
  final TextEditingController controller;
  final String initialValue;
  final bool isMinusable;
  // void Function(String) onFieldSubmitted;
  AttributeFormField({
    Key key,
    this.controller,
    this.initialValue,
    this.isMinusable,
    // this.onFieldSubmitted
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      inputFormatters: isMinusable ? [WhitelistingTextInputFormatter(RegExp(r'^[-]{0,1}\d*$'))] : [WhitelistingTextInputFormatter.digitsOnly],
      decoration: InputDecoration.collapsed(hintText: null,).copyWith(isDense: true, contentPadding: EdgeInsets.only(top: 8)),
      style: Theme.of(context).textTheme.caption,
      textAlign: TextAlign.center,
      maxLength: 4,
      textAlignVertical: TextAlignVertical.center,
      // initialValue: _leftPadding.toString(),
      // onFieldSubmitted: onFieldSubmitted,
      // buildCounter: null,
      buildCounter: (_, {currentLength, maxLength, isFocused}) => null,
    );
  }
}