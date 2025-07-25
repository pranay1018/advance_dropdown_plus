import 'package:advance_dropdown_plus/advance_dropdown_plus.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class MultiValueDropDownController extends ChangeNotifier {
  List<DropDownValueModel>? dropDownValueList;
  MultiValueDropDownController({List<DropDownValueModel>? data}) {
    setDropDown(data);
  }
  setDropDown(List<DropDownValueModel>? modelList) {
    List<DropDownValueModel>? lst;
    if (modelList != null && modelList.isNotEmpty) {
      List<DropDownValueModel> list = [];
      for (DropDownValueModel item in modelList) {
        if (!list.contains(item)) {
          item.isSelected.value = true;
          list.add(item);
        }
      }
      lst = list;
    }
    Function unOrdDeepEq = const DeepCollectionEquality.unordered().equals;

    if (!unOrdDeepEq(lst, dropDownValueList)) {
      dropDownValueList = lst;
      notifyListeners();
    }
  }

  clearDropDown() {
    if (dropDownValueList != null) {
      dropDownValueList = null;
      notifyListeners();
    }
  }
}
