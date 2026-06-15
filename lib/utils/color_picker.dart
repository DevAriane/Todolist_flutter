import 'package:flutter/material.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';
import 'package:getxtra/get.dart';
import '../controller/color_controller.dart';

class ColorsPicker extends StatelessWidget {
  ColorsPicker({super.key});

  final ColorController controller = Get.find<ColorController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final Color currentColor = controller.selectedColor.value;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: currentColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade300, width: 2),
              ),
            ),
            const SizedBox(height: 20),

            SliderPicker(
              value: HSVColor.fromColor(currentColor).hue,
              min: 0.0,
              max: 360.0,
              onChanged: (double hue) {
                final newHsvColor = HSVColor.fromAHSV(1.0, hue, 1.0, 1.0);
                controller.changeColor(newHsvColor.toColor());
              },
              colors: [
                Colors.red,
                Colors.yellow,
                Colors.green,
                Colors.cyan,
                Colors.blue,
                const Color(0xFFFF00FF),
                Colors.red,
              ],
            ),
          ],
        ),
      );
    });
  }
}

void showColorPickerDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Container(
          width: double.maxFinite,
          constraints: BoxConstraints(
            maxWidth: 400,
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Text(
                  'Choisir une couleur',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              const Divider(),
              Flexible(child: ColorsPicker()),
              const Divider(),
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Fermer'),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
