import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onTapFunction;
  final void Function(String) onChangedFunction;
  const CustomSearchBar({
    super.key,
    required this.controller,
    required this.onTapFunction,
    required this.onChangedFunction,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onTap: onTapFunction,
      controller: controller,
      onChanged: onChangedFunction,
      decoration: InputDecoration(
        hintText: "Enter a username here..",
        hintStyle: const TextStyle(
          fontStyle: FontStyle.italic,
          color: Colors.amber,
        ),
        prefixIcon: const Icon(
          Icons.search,
          color: Colors.grey,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(color: Colors.amber, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(color: Colors.amber, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
    );
  }
}
