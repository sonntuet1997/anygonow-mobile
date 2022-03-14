import 'package:flutter/material.dart';

ButtonTheme getDropDown(List<String> itemList, Function(String) callback) {
  print(itemList);
  return ButtonTheme(
    alignedDropdown: true,
    child: DropdownButton(
        isExpanded: true,
        underline: SizedBox(),
        items: itemList.map<DropdownMenuItem<String>>((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: (dynamic value) {
          callback(value);
        }),
  );
}
