import 'package:flutter/widgets.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';
import '../controller/color_controller.dart';
import 'package:getxtra/get.dart';

class ColorsPicker extends StatelessWidget {
  ColorsPicker({super.key});

  final ColorController controller = Get.find<ColorController>();

  @override
  Widget build(BuildContext context) {
    return ColorPicker(
      color: controller.selectedColor.value,
      onChanged: controller.changeColor,
    );
  }
}
