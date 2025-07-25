import 'package:advance_dropdown_plus/advance_dropdown_plus.dart';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class MultiSelectWidget extends StatefulWidget {
  final List<DropDownValueModel> dropDownList;
  final ValueSetter onChanged;
  final Function(int index, bool isCheck)? onCheckChange;
  final List<bool> list;
  final double height;
  final Color? buttonColor;
  final String? buttonText;
  final TextStyle? buttonTextStyle;
  final double listTileHeight;
  final TextStyle? listTextStyle;
  final ListPadding listPadding;
  final CheckBoxProperty? checkBoxProperty;
  final bool enableSearch;
  final TextStyle? searchTextStyle;
  final FocusNode? searchFocusNode;
  final TextInputType? searchKeyboardType;
  final bool searchAutofocus;
  final InputDecoration? searchDecoration;
  final bool? searchShowCursor;
  final double searchHeight;
  final VoidCallback? onSearchTap;
  final VoidCallback? onSearchSubmit;
  final bool isSelectAll;

  const MultiSelectWidget({
    Key? key,
    required this.onChanged,
    required this.dropDownList,
    required this.list,
    required this.height,
    this.onCheckChange,
    this.buttonColor,
    this.buttonText,
    this.buttonTextStyle,
    required this.listTileHeight,
    required this.listPadding,
    this.listTextStyle,
    this.checkBoxProperty,
    this.enableSearch = false,
    this.searchTextStyle,
    this.searchFocusNode,
    this.searchKeyboardType,
    this.searchAutofocus = false,
    this.searchDecoration,
    this.searchShowCursor,
    this.searchHeight = 40.0,
    this.onSearchTap,
    this.onSearchSubmit,
    this.isSelectAll = false,
  }) : super(key: key);

  @override
  _MultiSelectWidgetState createState() => _MultiSelectWidgetState();
}

class _MultiSelectWidgetState extends State<MultiSelectWidget> {
  List<bool> multiSelectionValue = [];
  TextEditingController searchController = TextEditingController();
  List<DropDownValueModel> filteredList = [];
  List<int> originalIndices = [];

  @override
  void initState() {
    multiSelectionValue = List.from(widget.list);
    filteredList = List.from(widget.dropDownList);
    originalIndices = List.generate(
      widget.dropDownList.length,
      (index) => index,
    );
    super.initState();
  }

  void onItemChanged(String value) {
    setState(() {
      if (value.isEmpty) {
        filteredList = List.from(widget.dropDownList);
        originalIndices = List.generate(
          widget.dropDownList.length,
          (index) => index,
        );
      } else {
        filteredList = [];
        originalIndices = [];
        for (int i = 0; i < widget.dropDownList.length; i++) {
          if (widget.dropDownList[i].name.toLowerCase().contains(
            value.toLowerCase(),
          )) {
            filteredList.add(widget.dropDownList[i]);
            originalIndices.add(i);
          }
        }
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //create new search feature refer single select
        if (widget.enableSearch)
          GestureDetector(
            onTap: () {
              widget.onSearchTap?.call();
            },
            child: Container(
              height: widget.searchHeight,
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 8.0,
              ),
              child: TextField(
                controller: searchController,
                focusNode: widget.searchFocusNode,
                keyboardType: widget.searchKeyboardType,
                autofocus: widget.searchAutofocus,
                showCursor: widget.searchShowCursor,
                style: widget.searchTextStyle,
                decoration:
                    widget.searchDecoration ??
                    InputDecoration(
                      hintText: "Search here",
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      suffixIcon: searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                searchController.clear();
                                onItemChanged('');
                              },
                            )
                          : null,
                    ),
                onChanged: onItemChanged,
                onSubmitted: (_) => widget.onSearchSubmit?.call(),
              ),
            ),
          ),
        //select all checkboc
        if (widget.isSelectAll)
          Row(
            children: [
              Checkbox(
                value: widget.list.isNotEmpty && widget.list.every((e) => e),
                onChanged: (value) {
                  setState(() {
                    bool isChecked = value ?? false;
                    for (int i = 0; i < widget.list.length; i++) {
                      if (widget.dropDownList[i].isEnabled != false) {
                        widget.list[i] = isChecked;
                        widget.dropDownList[i].isSelected.value = isChecked;
                        // widget.onCheckChange?.call(i, isChecked);
                      }
                    }
                  });
                },
              ),
              Text(
                "Select All",
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w400),
              ),
            ],
          ),
        SizedBox(
          height: widget.height,
          child: Scrollbar(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: filteredList.length,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: widget.listPadding.bottom,
                      top: widget.listPadding.top,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    filteredList[index].name,
                                    style: widget.listTextStyle,
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                                if (filteredList[index].toolTipMsg != null)
                                  ToolTipWidget(
                                    msg: filteredList[index].toolTipMsg!,
                                  ),
                              ],
                            ),
                          ),
                        ),
                        Obx(
                          () => Checkbox(
                            value: filteredList[index].isSelected.value,
                            // Check if the item has an isEnabled property and use it to conditionally disable the checkbox
                            onChanged: filteredList[index].isEnabled == false
                                ? null // Disabled when isEnabled is false
                                : (value) {
                                    if (value != null) {
                                      // Use original index for callback
                                      int originalIndex =
                                          originalIndices[index];

                                      // Update the state to trigger UI refresh
                                      setState(() {
                                        widget.list[originalIndex] = value;
                                      });

                                      widget.onCheckChange?.call(
                                        originalIndex,
                                        value,
                                      );
                                    }
                                  },
                            tristate:
                                widget.checkBoxProperty?.tristate ?? false,
                            mouseCursor: widget.checkBoxProperty?.mouseCursor,
                            activeColor: widget.checkBoxProperty?.activeColor,
                            fillColor: widget.checkBoxProperty?.fillColor,
                            checkColor: widget.checkBoxProperty?.checkColor,
                            focusColor: widget.checkBoxProperty?.focusColor,
                            hoverColor: widget.checkBoxProperty?.hoverColor,
                            overlayColor: widget.checkBoxProperty?.overlayColor,
                            splashRadius: widget.checkBoxProperty?.splashRadius,
                            materialTapTargetSize:
                                widget.checkBoxProperty?.materialTapTargetSize,
                            visualDensity:
                                widget.checkBoxProperty?.visualDensity,
                            focusNode: widget.checkBoxProperty?.focusNode,
                            autofocus:
                                widget.checkBoxProperty?.autofocus ?? false,
                            shape: widget.checkBoxProperty?.shape,
                            side: widget.checkBoxProperty?.side,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Row(
          children: [
            const Expanded(child: SizedBox.shrink()),
            Padding(
              padding: const EdgeInsets.only(
                right: 8.0,
                left: 8.0,
                top: 0,
                bottom: 10,
              ),
              child: InkWell(
                onTap: () => widget.onChanged(multiSelectionValue),
                child: Container(
                  // height: widget.listTileHeight * 0.9,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 30,
                  ),
                  decoration: BoxDecoration(
                    color: widget.buttonColor ?? Colors.green,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Align(
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        widget.buttonText ?? "Ok",
                        style:
                            widget.buttonTextStyle ??
                            const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
