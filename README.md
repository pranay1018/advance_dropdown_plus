# Advance Dropdown Plus

An advanced Flutter dropdown widget that provides enhanced functionality beyond the standard dropdown. Features multi-selection, search capabilities, customizable styling, and robust validation.

## Features

✨ **Multi-Selection Support** - Select multiple items with checkboxes
🔍 **Search Functionality** - Built-in search to filter dropdown options
🎨 **Customizable Styling** - Extensive theming and styling options
✅ **Validation Support** - Form validation with custom validators
🎯 **Select All Option** - Convenient select/deselect all functionality
🎮 **Controller-Based** - Reactive state management with controllers
📱 **Responsive Design** - Works seamlessly across different screen sizes

## Getting Started

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  advance_dropdown_plus: ^1.0.0
```

Then run:
```bash
flutter pub get
```

Import the package:
```dart
import 'package:advance_dropdown_plus/advance_dropdown_plus.dart';
```

## Usage

### Single Selection Dropdown

```dart
final singleController = SingleValueDropDownController();

DropdownField.singleSelection(
  controller: singleController,
  dropDownList: [
    DropDownValueModel(name: 'Option 1', value: 'option1'),
    DropDownValueModel(name: 'Option 2', value: 'option2'),
    DropDownValueModel(name: 'Option 3', value: 'option3'),
  ],
  textFieldDecoration: const InputDecoration(
    labelText: "Select an option",
    border: OutlineInputBorder(),
  ),
  onChanged: (selectedItem) {
    print('Selected: ${selectedItem.name}');
  },
)
```

### Multi-Selection Dropdown

```dart
final multiController = MultiValueDropDownController();

DropdownField.multiSelection(
  controller: multiController,
  dropDownList: [
    DropDownValueModel(name: 'Football', value: 'football'),
    DropDownValueModel(name: 'Cricket', value: 'cricket'),
    DropDownValueModel(name: 'Basketball', value: 'basketball'),
  ],
  isSelectAll: true,
  displayCompleteItem: true,
  submitButtonText: "Done",
  submitButtonColor: Colors.blue,
  textFieldDecoration: const InputDecoration(
    labelText: "Select Sports",
    border: OutlineInputBorder(),
  ),
  onChanged: (selectedList) {
    print('Selected: ${selectedList.map((e) => e.name).join(', ')}');
  },
)
```

### With Search Functionality

```dart
DropdownField.singleSelection(
  controller: singleController,
  dropDownList: items,
  enableSearch: true,
  searchDecoration: const InputDecoration(
    hintText: 'Search...',
    prefixIcon: Icon(Icons.search),
  ),
  // ... other properties
)
```

## Customization Options

- **Styling**: Customize colors, fonts, borders, and spacing
- **Icons**: Custom dropdown and clear icons
- **Validation**: Built-in form validation support
- **Search**: Configurable search with custom styling
- **Animations**: Smooth dropdown animations
- **Accessibility**: Full accessibility support

## Example

Check out the `/example` folder for complete working examples of both single and multi-selection dropdowns.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Issues

Please file feature requests and bugs at the [issue tracker](https://github.com/pranay311/advance_dropdown_plus/issues).
