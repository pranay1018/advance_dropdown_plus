// ignore: must_be_immutable
import 'package:equatable/equatable.dart';
import 'package:get/get_rx/get_rx.dart';

class DropDownValueModel extends Equatable {
  final String name;
  final dynamic value;
  final RxBool isEnabled = true.obs;
  final RxBool isSelected = false.obs;

  ///as of now only added for multiselection dropdown
  final String? toolTipMsg;

  DropDownValueModel({
    required this.name,
    required this.value,
    this.toolTipMsg,
  });

  factory DropDownValueModel.fromJson(Map<String, dynamic> json) =>
      DropDownValueModel(
        name: json["name"],
        value: json["value"],
        toolTipMsg: json["toolTipMsg"],
      );

  Map<String, dynamic> toJson() => {
    "name": name,
    "value": value,
    "toolTipMsg": toolTipMsg,
    "isEnabled": isEnabled,
  };
  @override
  List<Object> get props => [name, value];
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DropDownValueModel &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          value == other.value;

  @override
  int get hashCode => name.hashCode ^ value.hashCode;
}
