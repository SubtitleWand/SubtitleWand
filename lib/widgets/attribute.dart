import 'package:configurable_expansion_tile_null_safety/configurable_expansion_tile.dart';
import 'package:flutter/material.dart';
import 'package:subtitle_wand/design/color_palette.dart';
import 'package:subtitle_wand/widgets/project/attribute_form_field.dart';
import 'package:subtitle_wand/widgets/project/color_picker_dialog.dart';

class AttributePanel extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const AttributePanel({
    Key? key,
    this.title = 'Untitled',
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            ColorPalette.accentColor,
            ColorPalette.secondaryColor,
          ],
        ),
        border: Border.all(color: ColorPalette.accentColor),
      ),
      child: ConfigurableExpansionTile(
        header: Expanded(
          child: Container(
            height: 36,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
          ),
        ),
        animatedWidgetFollowingHeader: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Icon(Icons.keyboard_arrow_up, color: ColorPalette.fontColor),
        ),
        children: <Widget>[
          Container(
            width: double.maxFinite,
            padding: const EdgeInsets.only(bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          )
        ],
      ),
    );
  }
}

class AttributeBase extends StatelessWidget {
  final double titleWidth;
  final String? title;
  final Widget? child;
  final double? childWidth;
  const AttributeBase({
    Key? key,
    this.title,
    this.titleWidth = 48,
    this.childWidth = 36,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            width: titleWidth,
            child: Text(
              '$title',
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ),
          const SizedBox(
            width: 4,
          ),
          Container(
            width: childWidth,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(8),
            ),
            child: child,
          )
        ],
      ),
    );
  }
}

class TextAttribute extends StatelessWidget {
  final String title;
  final double titleWidth;
  final TextEditingController? controller;
  final String? initValue;
  // final bool isNegative = false;
  final AttributeFormFieldType type;
  final bool readOnly;
  const TextAttribute({
    Key? key,
    this.title = 'Untitled',
    this.titleWidth = 48,
    this.controller,
    this.initValue,
    this.readOnly = false,
    this.type = AttributeFormFieldType.digit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AttributeBase(
      title: title,
      titleWidth: titleWidth,
      child: Center(
        child: AttributeFormField(
          controller: controller,
          initialValue: initValue,
          type: type,
          readOnly: readOnly,
        ),
      ),
    );
  }
}

class ButtonAttribute extends StatelessWidget {
  final String title;
  final String? buttonName;
  final double titleWidth;
  final double? childWidth;
  final void Function()? onPressed;

  const ButtonAttribute({
    Key? key,
    this.title = 'Untitled',
    this.buttonName,
    this.titleWidth = 48,
    this.childWidth = 36,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AttributeBase(
      title: title,
      titleWidth: titleWidth,
      childWidth: childWidth,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Center(
              child: Text(
                '$buttonName',
                style: Theme.of(context).textTheme.subtitle2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ColorAttribute extends StatelessWidget {
  final String title;
  final Color? color;
  final double titleWidth;
  final void Function(Color color)? onSelected;

  const ColorAttribute({
    Key? key,
    this.title = 'Untitled',
    this.color,
    this.titleWidth = 48,
    this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AttributeBase(
      title: title,
      titleWidth: titleWidth,
      child: Material(
        color: color,
        child: InkWell(
          child: const SizedBox(width: 36, height: 24),
          onTap: () async {
            Color? selectedColor = await showDialog(
              context: context,
              builder: (context) {
                return ColorPickerDialog(initColor: color);
              },
            );
            if (selectedColor == null) return;
            onSelected?.call(selectedColor);
          },
        ),
      ),
    );
  }
}

class SelectorAttribute<T> extends StatelessWidget {
  final Map<String, T> nameToValues;
  final T? selected;
  final void Function(T value)? onSelect;

  const SelectorAttribute({
    Key? key,
    this.nameToValues = const {},
    this.selected,
    this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextStyle? focusSelectionStyle = Theme.of(context)
        .textTheme
        .bodyText1
        ?.copyWith(color: ColorPalette.fontColor);
    final TextStyle? selectionStyle = Theme.of(context)
        .textTheme
        .bodyText1
        ?.copyWith(color: ColorPalette.primaryColor);
    final Color focusButtonColor = ColorPalette.primaryColor;
    final Color buttonColor = ColorPalette.fontColor;
    return Row(
      children: nameToValues.entries
          .toList()
          .map(
            (entry) => Expanded(
              child: MaterialButton(
                color: selected == entry.value ? focusButtonColor : buttonColor,
                padding: const EdgeInsets.all(0),
                child: Text(
                  entry.key,
                  style: selected == entry.value
                      ? focusSelectionStyle
                      : selectionStyle,
                ),
                onPressed: () {
                  onSelect?.call(entry.value);
                },
              ),
            ),
          )
          .toList(),
    );
  }
}
