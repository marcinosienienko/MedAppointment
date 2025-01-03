import 'package:flutter/material.dart';

class MainSearchBar extends StatelessWidget {
  final TextEditingController searchController;
  final String currentText;
  final VoidCallback onClear;
  final ValueChanged<String> onChanged;

  const MainSearchBar({
    super.key,
    required this.searchController,
    required this.currentText,
    required this.onClear,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: searchController,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.blue),
        ),
        prefixIcon: currentText.isNotEmpty
            ? null
            : const Icon(Icons.search, color: Colors.grey),
        suffixIcon: currentText.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: onClear,
              )
            : null,
        hintText: 'Wyszukaj lekarza',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.grey),
        ),
        contentPadding: currentText.isNotEmpty
            ? const EdgeInsets.symmetric(vertical: 15.0, horizontal: 16.0)
            : const EdgeInsets.only(
                left: 48.0, right: 16.0, top: 15.0, bottom: 15.0),
      ),
      onChanged: onChanged,
    );
  }
}
