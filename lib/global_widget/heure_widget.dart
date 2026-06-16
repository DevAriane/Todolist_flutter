import 'package:flutter/material.dart';
import '../core/app_color.dart';

class HeureWidget extends StatefulWidget {
  final VoidCallback pickStartTime;
  final TimeOfDay? startTime;
  final VoidCallback pickEndTime;
  final TimeOfDay? endTime;
  const HeureWidget({
    super.key,
    required this.pickStartTime,
    this.startTime,
    required this.pickEndTime,
    this.endTime,
  });

  @override
  State<HeureWidget> createState() => _HeureWidgetState();
}

class _HeureWidgetState extends State<HeureWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Heure', style: TextStyle(color: Colors.white70)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: widget.pickStartTime,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColor.bordure),
                  ),
                  child: Text(
                    widget.startTime != null
                        ? widget.startTime!.format(context)
                        : 'Début',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Text('—', style: TextStyle(color: Colors.white70)),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: widget.pickEndTime,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColor.bordure),
                  ),
                  child: Text(
                    widget.endTime != null
                        ? widget.endTime!.format(context)
                        : 'Fin',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
