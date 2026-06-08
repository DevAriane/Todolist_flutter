import 'package:flutter/material.dart';
import '../core/app_color.dart';

class Searchbars extends StatelessWidget {
  const Searchbars({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        color: AppColor.fond,
        borderRadius: BorderRadius.circular(30.0),
        border: Border.all(color: AppColor.bordure, width: 1.0),
      ),
      child: TextField(
        style: const TextStyle(color: AppColor.blanc),
        decoration: InputDecoration(
          hintText: "Rechercher...",
          hintStyle: const TextStyle(color: AppColor.placeholder),
          prefixIcon: const Icon(
            Icons.search,
            color: AppColor.placeholder,
            size: 50,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
          suffixIcon: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Container(
              height: 10,
              decoration: const BoxDecoration(
                color: AppColor.or,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.tune, color: AppColor.noir, size: 15.0),
                onPressed: () {},
              ),
            ),
          ),
        ),
      ),
    );
  }
}
