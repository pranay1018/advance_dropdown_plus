import 'package:advance_dropdown_plus/advance_dropdown_plus.dart';
import 'package:flutter/material.dart';

class MultiSelectExample extends StatelessWidget {
  final multiController = MultiValueDropDownController();

  MultiSelectExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Multi Select Example")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: DropdownField.multiSelection(
          controller: multiController,
          dropDownList: [
            DropDownValueModel(name: 'Football', value: 'football'),
            DropDownValueModel(name: 'Cricket', value: 'cricket'),
            DropDownValueModel(name: 'Basketball', value: 'basketball'),
          ],
          isSelectAll: true,
          displayCompleteItem: true,
          submitButtonText: "Submit",
          submitButtonColor: Colors.blue,
          submitButtonTextStyle: const TextStyle(color: Colors.white),
          textFieldDecoration: const InputDecoration(
            labelText: "Select Sports",
            border: OutlineInputBorder(),
          ),
          onChanged: (selectedList) {
            print(
              "Selected Items: ${selectedList.map((e) => e.name).join(', ')}",
            );
          },
        ),
      ),
    );
  }
}
