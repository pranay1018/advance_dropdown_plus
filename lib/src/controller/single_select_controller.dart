import 'package:advance_dropdown_plus/advance_dropdown_plus.dart';
import 'package:flutter/foundation.dart';

class SingleValueDropDownController extends ChangeNotifier {
  DropDownValueModel? dropDownValue;
  SingleValueDropDownController({DropDownValueModel? data}) {
    setDropDown(data);
  }
  setDropDown(DropDownValueModel? model) {
    if (dropDownValue != model) {
      dropDownValue = model;
      notifyListeners();
    }
  }

  clearDropDown() {
    if (dropDownValue != null) {
      dropDownValue = null;
      notifyListeners();
    }
  }
}
