import 'package:advance_dropdown_plus/advance_dropdown_plus.dart';
import 'package:flutter/material.dart';

class SingleSelectExample extends StatelessWidget {
  final singleController = SingleValueDropDownController();

  SingleSelectExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Single Select Example")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: DropdownField(
          controller: singleController,
          dropDownList: [
            DropDownValueModel(name: 'Apple', value: 'apple'),
            DropDownValueModel(name: 'Banana', value: 'banana'),
            DropDownValueModel(name: 'Grapes', value: 'grapes'),
          ],
          textFieldDecoration: const InputDecoration(
            labelText: "Select a Fruit",
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            print("Selected: ${(value as DropDownValueModel).name}");
          },
        ),
      ),
    );
  }
}
