import 'package:flutter/material.dart';
import 'package:todolist_flutter/core/app_color.dart';
import './icon_list.dart';

class IconPicker extends StatefulWidget {
  final Function(String) onIconSelected;
  final String? initialIcon;
  final String? title;

  const IconPicker({
    super.key,
    required this.onIconSelected,
    this.initialIcon,
    this.title,
  });

  @override
  _IconPickerState createState() => _IconPickerState();
}

class _IconPickerState extends State<IconPicker> {
  late String? selectedIcon;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    selectedIcon = widget.initialIcon;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<String> get _filteredIcons {
    if (_searchQuery.isEmpty) return availableIcons;
    return availableIcons
        .where(
          (icon) => icon.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.title != null) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Text(
              widget.title!,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ],
        LayoutBuilder(
          builder: (context, constraints) {
            int crossAxisCount = 4;
            if (constraints.maxWidth > 600) crossAxisCount = 6;
            if (constraints.maxWidth > 900) crossAxisCount = 8;

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: 1.0,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: _filteredIcons.length,
              itemBuilder: (context, index) {
                final iconName = _filteredIcons[index];
                final isSelected = (selectedIcon == iconName);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        selectedIcon = null;
                        widget.onIconSelected('');
                      } else {
                        selectedIcon = iconName;
                        widget.onIconSelected(iconName);
                      }
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: isSelected
                            ? AppColor.buttonColor
                            : Colors.grey.shade300,
                        width: isSelected ? 2.5 : 1.0,
                      ),
                    ),
                    child: Transform.scale(
                      scale: isSelected ? 1.1 : 1.0,
                      child: Icon(getIconData(iconName), size: 32),
                    ),
                  ),
                );
              },
            );
          },
        ),
        const SizedBox(height: 8.0),
        if (selectedIcon != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Icon(getIconData(selectedIcon), size: 20),
                const SizedBox(width: 8),
                Text(
                  'Sélectionnée : $selectedIcon',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
