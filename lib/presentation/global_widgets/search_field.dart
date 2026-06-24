import "package:flutter/material.dart";

import "package:iconsax/iconsax.dart";

class SearchField extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String? hintText;

  const SearchField({
    super.key,
    this.controller,
    this.onChanged,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText ?? "Search",
        prefixIcon: const Icon(Iconsax.search_normal),
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
      ),
    );
  }
}
