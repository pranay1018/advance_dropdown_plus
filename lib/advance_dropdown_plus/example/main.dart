import 'package:advance_dropdown_plus/advance_dropdown_plus.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dropdown Plus Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ExampleHomePage(),
    );
  }
}

class ExampleHomePage extends StatelessWidget {
  const ExampleHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dropdown Plus Examples'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MultiSelectExample(),
                    ),
                  );
                },
                child: const Text('Multi Select Example'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SingleSelectExample(),
                    ),
                  );
                },
                child: const Text('Single Select Example'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MultiSelectExample extends StatefulWidget {
  const MultiSelectExample({super.key});

  @override
  State<MultiSelectExample> createState() => _MultiSelectExampleState();
}

class _MultiSelectExampleState extends State<MultiSelectExample> {
  final multiController = MultiValueDropDownController();

  // List of available sports options
  final List<DropDownValueModel> sportsOptions = [
    DropDownValueModel(name: 'Football', value: 'football'),
    DropDownValueModel(name: 'Cricket', value: 'cricket'),
    DropDownValueModel(name: 'Basketball', value: 'basketball'),
    DropDownValueModel(name: 'Tennis', value: 'tennis'),
    DropDownValueModel(name: 'Swimming', value: 'swimming'),
  ];

  void changeSelection(DropDownValueModel value, bool isCheck, int index) {
    if (isCheck) {
      value.isSelected.value = true;
    } else {
      value.isSelected.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Multi Select Example with Checkboxes"),
        backgroundColor: Colors.blue.shade100,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown field from the package
            DropdownField.multiSelection(
              enableSearch: true,
              controller: multiController,
              dropDownList: sportsOptions,
              isSelectAll: true,
              displayCompleteItem: true,
              submitButtonText: "Submit",
              submitButtonColor: Colors.blue,
              submitButtonTextStyle: const TextStyle(color: Colors.white),
              textFieldDecoration: const InputDecoration(
                labelText: "Select Sports (Package Dropdown)",
                border: OutlineInputBorder(),
              ),
              onCheckChange: (model, isCheck, index) {
                changeSelection(model, isCheck, index);
              },
              onChanged: (selectedList) {
                print(
                  "Package Dropdown - Selected Items: ${selectedList.map((e) => e.name).join(', ')}",
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

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
            DropDownValueModel(name: 'Option 1', value: 'option1'),
            DropDownValueModel(name: 'Option 2', value: 'option2'),
            DropDownValueModel(name: 'Option 3', value: 'option3'),
          ],
          textFieldDecoration: const InputDecoration(
            labelText: "Select an Option",
            border: OutlineInputBorder(),
          ),
          onChanged: (selectedItem) {
            print("Selected: ${selectedItem.name}");
          },
        ),
      ),
    );
  }
}
