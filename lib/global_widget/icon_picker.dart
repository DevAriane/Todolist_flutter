import 'package:flutter/material.dart';
import 'package:todolist_flutter/global_widget/icon_list.dart';

class IconPicker extends StatefulWidget {
  final Function(String) onIconSelected;
  const IconPicker({super.key, required this.onIconSelected});

  @override
  _IconPickerState createState() => _IconPickerState();
}

class _IconPickerState extends State<IconPicker> {
  String? selectedIcon;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1.0,
      ),
      itemCount: availableIconNames.length,
      itemBuilder: (context, index) {
        final iconName = availableIconNames[index];
        final isSelected = (selectedIcon == iconName);
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedIcon = iconName;
            });
            widget.onIconSelected(iconName);
          },
          child: Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue.shade100 : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? Colors.blue : Colors.grey.shade300,
              ),
            ),
            child: Icon(
              getIconDataFromName(iconName),
              size: 32,
              color: isSelected ? Colors.blue : Colors.grey.shade700,
            ),
          ),
        );
      },
    );
  }
}
