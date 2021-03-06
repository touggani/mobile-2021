// Multi Select widget
// This widget is reusable
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../../data/models/genre.dart';

class MultiSelect extends StatefulWidget {
  final ListGenre? items;
  const MultiSelect({Key? key, required this.items}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  // this variable holds the selected items
  final List<Genres> _selectedItems = [];

// This function is triggered when a checkbox is checked or unchecked
  void _itemChange(Genres itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedItems.add(itemValue);
      } else {
        _selectedItems.remove(itemValue);
      }
    });
  }

  // this function is called when the Cancel button is pressed
  void _cancel() {
    Navigator.pop(context);
  }

// this function is called when the Submit button is tapped
  void _submit() {
    Navigator.pop(context, _selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Selectionner un genre'),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.items!.genres!
              .map((item) => CheckboxListTile(
            value: _selectedItems.contains(item),
            title: Text(item.name.toString()),
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (isChecked) => _itemChange(item, isChecked!),
          ))
              .toList(),
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: _cancel,
        ),
        ElevatedButton(
          child: const Text('Submit'),
          onPressed: _submit,
        ),
      ],
    );
  }
}