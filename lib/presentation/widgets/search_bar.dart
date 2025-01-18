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
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.blue),
        ),
        prefixIcon: const Icon(Icons.search, color: Colors.grey),
        suffixIcon: currentText.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  onClear();
                  searchController.clear(); // Wyczyszczenie pola tekstowego
                },
              )
            : null,
        hintText: 'Wyszukaj lekarza',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15.0, horizontal: 16.0),
      ),
      onChanged: onChanged,
    );
  }
}
