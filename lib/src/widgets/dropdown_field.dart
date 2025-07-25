import 'dart:async';
import 'package:advance_dropdown_plus/advance_dropdown_plus.dart';
import 'package:collection/collection.dart';

import 'package:flutter/material.dart';
import 'multi_select_widget.dart';

class DropdownField extends StatefulWidget {
  const DropdownField({
    super.key,
    this.controller,
    this.initialValue,
    required this.dropDownList,
    this.padding,
    this.textStyle,
    this.onCheckChange,
    this.onChanged,
    this.validator,
    this.isSelectAll = false,
    this.isEnabled = true,
    this.enableSearch = false,
    this.readOnly = true,
    this.dropdownRadius = 12,
    this.textFieldDecoration,
    this.dropDownIconProperty,
    this.dropDownItemCount = 6,
    this.searchTextStyle,
    this.searchFocusNode,
    this.textFieldFocusNode,
    this.searchAutofocus = false,
    this.searchDecoration,
    this.searchShowCursor,
    this.searchKeyboardType,
    this.listSpace = 0,
    this.clearOption = true,
    this.clearIconProperty,
    this.listPadding,
    this.listTextStyle,
    this.keyboardType,
    this.autovalidateMode,
  }) : assert(
         !(initialValue != null && controller != null),
         "you cannot add both initialValue and singleController,\nset initial value using controller \n\tEg: SingleValueDropDownController(data:initial value) ",
       ),
       assert(
         !(!readOnly && enableSearch),
         "readOnly!=true or enableSearch=true both condition does not work",
       ),
       assert(
         !(controller != null &&
             !(controller is SingleValueDropDownController)),
         "controller must be type of SingleValueDropDownController",
       ),
       checkBoxProperty = null,
       isMultiSelection = false,
       singleController = controller,
       multiController = null,
       displayCompleteItem = false,
       submitButtonColor = null,
       submitButtonText = null,
       submitButtonTextStyle = null;
  const DropdownField.multiSelection({
    super.key,
    this.controller,
    this.displayCompleteItem = false,
    this.initialValue,
    required this.dropDownList,
    this.enableSearch = false,
    this.searchTextStyle,
    this.searchFocusNode,
    this.searchAutofocus = false,
    this.searchDecoration,
    this.searchShowCursor,
    this.searchKeyboardType,
    this.padding,
    this.onCheckChange,
    this.textStyle,
    this.onChanged,
    this.validator,
    this.isEnabled = true,
    this.dropdownRadius = 12,
    this.dropDownIconProperty,
    this.textFieldDecoration,
    this.dropDownItemCount = 6,
    this.textFieldFocusNode,
    this.listSpace = 0,
    this.clearOption = true,
    this.clearIconProperty,
    this.submitButtonColor,
    this.submitButtonText,
    this.submitButtonTextStyle,
    this.listPadding,
    this.listTextStyle,
    this.checkBoxProperty,
    this.isSelectAll = false,
    this.autovalidateMode,
  }) : assert(
         initialValue == null || controller == null,
         "you cannot add both initialValue and multiController\nset initial value using controller\n\tMultiValueDropDownController(data:initial value)",
       ),
       assert(
         !(controller != null && !(controller is MultiValueDropDownController)),
         "controller must be type of MultiValueDropDownController",
       ),
       multiController = controller,
       isMultiSelection = true,
       readOnly = true,
       singleController = null,
       keyboardType = null;

  ///single and multiple dropdown controller.
  ///It must be type of SingleValueDropDownController or MultiValueDropDownController.
  final dynamic controller;

  ///single dropdown controller,
  final SingleValueDropDownController? singleController;

  ///multi dropdown controller
  final MultiValueDropDownController? multiController;

  ///define the radius of dropdown List ,default value is 12
  final double dropdownRadius;

  ///initial value ,if it is null or not exist in dropDownList then it will not display value.
  final dynamic initialValue;

  ///dropDownList,List of dropdown values
  ///List<DropDownValueModel>
  final List<DropDownValueModel> dropDownList;

  ///function,called when value selected from dropdown.
  ///for single Selection Dropdown it will return single DropDownValueModel object,
  ///and for multi Selection Dropdown ,it will return list of DropDownValueModel object,
  final ValueSetter? onChanged;

  final Function(DropDownValueModel model, bool isCheck, int index)?
  onCheckChange;

  final bool isMultiSelection;

  final TextStyle? textStyle;

  final EdgeInsets? padding;

  ///override default textfield decoration
  final InputDecoration? textFieldDecoration;

  ///customize dropdown icon size and color
  final IconProperty? dropDownIconProperty;

  ///by setting isEnabled=false to disable textfield,default value true
  final bool isEnabled;

  final FormFieldValidator<String>? validator;

  ///by setting enableSearch=true enable search option in dropdown,as of now this feature enabled only for single selection dropdown
  final bool enableSearch;

  final bool readOnly;

  ///set displayCompleteItem=true, if you want show complete list of item in textfield else it will display like "number_of_item item selected"
  final bool displayCompleteItem;

  ///Maximum number of dropdown item to display,default value is 6
  final int dropDownItemCount;

  final FocusNode? searchFocusNode;
  final FocusNode? textFieldFocusNode;
  final TextStyle? searchTextStyle;

  ///override default search decoration
  final InputDecoration? searchDecoration;

  ///override default search keyboard type,only applicable if enableSearch=true,
  final TextInputType? searchKeyboardType;

  ///by setting searchAutofocus=true to autofocus search textfield,only applicable if enableSearch=true,
  ///  ///default value is false
  final bool searchAutofocus;

  ///by setting searchShowCursor=false to hide cursor from search textfield,only applicable if enableSearch=true,
  final bool? searchShowCursor;

  ///by set clearOption=false to hide clear suffix icon button from textfield.
  final bool clearOption;
  final bool isSelectAll;

  ///customize Clear icon size and color
  final IconProperty? clearIconProperty;

  ///space between textfield and list ,default value is 0
  final double listSpace;

  ///dropdown List item padding
  final ListPadding? listPadding;

  ///multi dropdown submit button text
  final String? submitButtonText;

  ///multi dropdown submit button color
  final Color? submitButtonColor;

  ///multi dropdown submit button text style
  final TextStyle? submitButtonTextStyle;

  ///dropdown list item text style
  final TextStyle? listTextStyle;

  final TextInputType? keyboardType;
  final AutovalidateMode? autovalidateMode;

  ///customize checkbox property
  final CheckBoxProperty? checkBoxProperty;

  @override
  _DropDownFieldState createState() => _DropDownFieldState();
}

class _DropDownFieldState extends State<DropdownField>
    with TickerProviderStateMixin {
  static final Animatable<double> _easeInTween = CurveTween(
    curve: Curves.easeInOut,
  );

  late TextEditingController _cnt;
  late String _hintText;

  late bool _isExpanded;
  OverlayEntry? _entry;
  OverlayEntry? _entry2;
  OverlayEntry? _barrierOverlay;
  final _layerLink = LayerLink();
  late AnimationController _controller;
  late Animation<double> _heightFactor;
  List<bool> _multiSelectionValue = [];
  // late String selectedItem;
  late double _height;
  late List<DropDownValueModel> _dropDownList;
  late int _maxListItem;
  late double _searchWidgetHeight;
  late FocusNode _searchFocusNode;
  late FocusNode _textFieldFocusNode;
  late bool _isOutsideClickOverlay;
  late bool _isScrollPadding;
  final int _duration = 500;
  late Offset _offset;
  late bool _searchAutofocus;
  late bool _isPortrait;
  late double _listTileHeight;
  late double _keyboardHeight;
  late TextStyle _listTileTextStyle;
  late ListPadding _listPadding;
  late TextDirection _currentDirection;
  // Keys to access overlay material widgets
  final GlobalKey mainOverlayKey = GlobalKey();
  final GlobalKey secondOverlayKey = GlobalKey();
  @override
  void initState() {
    _cnt = TextEditingController();
    _keyboardHeight = 450;
    _searchAutofocus = false;
    _isScrollPadding = false;
    _isOutsideClickOverlay = false;
    _searchFocusNode = widget.searchFocusNode ?? FocusNode();
    _textFieldFocusNode = widget.textFieldFocusNode ?? FocusNode();
    _isExpanded = false;
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _duration),
    );
    // Add animation status listener to handle cleanup after animation completes
    _controller.addStatusListener(_animationStatusListener);
    _heightFactor = _controller.drive(_easeInTween);
    _searchWidgetHeight = 60;
    _hintText = "Select Item";
    _searchFocusNode.addListener(() {
      if (!_searchFocusNode.hasFocus &&
          !_textFieldFocusNode.hasFocus &&
          _isExpanded &&
          !widget.isMultiSelection) {
        _isExpanded = !_isExpanded;
        hideOverlay();
      }
    });
    _textFieldFocusNode.addListener(() {
      if (!_searchFocusNode.hasFocus &&
          !_textFieldFocusNode.hasFocus &&
          _isExpanded) {
        _isExpanded = !_isExpanded;
        hideOverlay();
        if (!widget.readOnly &&
            widget.singleController?.dropDownValue?.name != _cnt.text) {
          setState(() {
            _cnt.clear();
          });
        }
      }
    });
    widget.singleController?.addListener(() {
      if (widget.singleController?.dropDownValue == null) {
        clearFun();
      }
    });
    widget.multiController?.addListener(() {
      if (widget.multiController?.dropDownValueList == null) {
        clearFun();
      }
    });
    for (int i = 0; i < widget.dropDownList.length; i++) {
      _multiSelectionValue.add(false);
    }

    ///initial value load
    if (widget.initialValue != null) {
      _dropDownList = List.from(widget.dropDownList);
      if (widget.isMultiSelection) {
        for (int i = 0; i < widget.initialValue.length; i++) {
          var index = _dropDownList.indexWhere(
            (element) => element.name.trim() == widget.initialValue[i].trim(),
          );
          if (index != -1) {
            _multiSelectionValue[index] = true;
          }
        }
        int count = _multiSelectionValue
            .where((element) => element)
            .toList()
            .length;

        _cnt.text = (count == 0
            ? ""
            : widget.displayCompleteItem
            ? (widget.initialValue ?? []).join(",")
            : "$count item selected");
      } else {
        var index = _dropDownList.indexWhere(
          (element) => element.name.trim() == widget.initialValue.trim(),
        );

        if (index != -1) {
          _cnt.text = widget.initialValue;
        }
      }
    }

    updateFunction();
    super.initState();
  }

  Size _textWidgetSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

  updateFunction({DropdownField? oldWidget}) {
    Function eq = const DeepCollectionEquality().equals;
    _dropDownList = List.from(widget.dropDownList);
    _listPadding = widget.listPadding ?? ListPadding();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isMultiSelection) {
        if (oldWidget != null && !eq(oldWidget.dropDownList, _dropDownList)) {
          _multiSelectionValue = [];
          _cnt.text = "";
          for (int i = 0; i < _dropDownList.length; i++) {
            _multiSelectionValue.add(false);
          }
        }
        // if (widget.isForceMultiSelectionClear &&
        //     _multiSelectionValue.isNotEmpty) {
        //   _multiSelectionValue = [];
        //   _cnt.text = "";
        //   for (int i = 0; i < _dropDownList.length; i++) {
        //     _multiSelectionValue.add(false);
        //   }
        // }

        // if (widget.multiController != null) {
        //   List<DropDownValueModel> multiCnt = [];
        //   for (int i = 0; i < dropDownList.length; i++) {
        //     if (multiSelectionValue[i]) {
        //       multiCnt.add(dropDownList[i]);
        //     }
        //   }
        //   widget.multiController!
        //       .setDropDown(multiCnt.isNotEmpty ? multiCnt : null);
        // }

        if (widget.multiController != null) {
          if (oldWidget != null &&
              oldWidget.multiController?.dropDownValueList != null) {}
          if (widget.multiController?.dropDownValueList != null) {
            _multiSelectionValue = [];
            for (int i = 0; i < _dropDownList.length; i++) {
              _multiSelectionValue.add(false);
            }
            for (
              int i = 0;
              i < widget.multiController!.dropDownValueList!.length;
              i++
            ) {
              var index = _dropDownList.indexWhere(
                (element) =>
                    element == widget.multiController!.dropDownValueList![i],
              );
              if (index != -1) {
                _multiSelectionValue[index] = true;
              }
            }

            if (oldWidget?.displayCompleteItem != widget.displayCompleteItem) {
              List<String> names =
                  (widget.multiController?.dropDownValueList ?? [])
                      .map((dataModel) => dataModel.name)
                      .toList();

              int count = _multiSelectionValue
                  .where((element) => element)
                  .toList()
                  .length;
              _cnt.text = (count == 0
                  ? ""
                  : widget.displayCompleteItem
                  ? names.join(",")
                  : "$count item selected");
            }
          } else {
            _multiSelectionValue = [];
            _cnt.text = "Please Select";
            for (int i = 0; i < _dropDownList.length; i++) {
              _multiSelectionValue.add(false);
            }
          }
        }
      } else {
        if (widget.singleController != null) {
          if (widget.singleController!.dropDownValue != null) {
            _cnt.text = widget.singleController!.dropDownValue!.name;
          } else {
            _cnt.clear();
          }
        }
      }

      _listTileTextStyle =
          (widget.listTextStyle ?? Theme.of(context).textTheme.titleMedium)!;
      _listTileHeight =
          _textWidgetSize("dummy Text", _listTileTextStyle).height +
          _listPadding.top +
          _listPadding.bottom;
      _maxListItem = widget.dropDownItemCount;

      _height =
          (!widget.isMultiSelection
              ? (_dropDownList.length < _maxListItem
                    ? _dropDownList.length * _listTileHeight
                    : _listTileHeight * _maxListItem.toDouble())
              : _dropDownList.length < _maxListItem
              ? _dropDownList.length * _listTileHeight
              : _listTileHeight * _maxListItem.toDouble()) +
          (widget.isMultiSelection ? 110 : 10);
    });
  }

  @override
  void didUpdateWidget(covariant DropdownField oldWidget) {
    super.didUpdateWidget(oldWidget);
    updateFunction(oldWidget: oldWidget);
  }

  @override
  void dispose() {
    if (widget.searchFocusNode == null) _searchFocusNode.dispose();
    if (widget.textFieldFocusNode == null) _textFieldFocusNode.dispose();
    if (_controller.isAnimating) {
      _controller.stop();
    }
    _controller.removeStatusListener(_animationStatusListener);
    _controller.dispose();
    _cnt.dispose();
    super.dispose();
  }

  clearFun() {
    if (_isExpanded) {
      _isExpanded = !_isExpanded;
      hideOverlay();
    }
    _cnt.clear();
    if (widget.isMultiSelection) {
      if (widget.multiController != null) {
        widget.multiController!.clearDropDown();
      }
      if (widget.onChanged != null) {
        widget.onChanged!([]);
      }

      _multiSelectionValue = [];
      for (int i = 0; i < _dropDownList.length; i++) {
        _multiSelectionValue.add(false);
      }
    } else {
      if (widget.singleController != null) {
        widget.singleController!.clearDropDown();
      }
      if (widget.onChanged != null) {
        widget.onChanged!("");
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    _currentDirection = Directionality.of(context);
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        if (!isKeyboardVisible && _isExpanded && _isScrollPadding) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            shiftOverlayEntry2to1();
          });
        }

        //added this code
        if (widget.isMultiSelection && _cnt.text.isEmpty) {
          _cnt.text = "Please Select";
        }
        return CompositedTransformTarget(
          link: _layerLink,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return TextFormField(
                controller: _cnt,
                focusNode: _textFieldFocusNode,
                keyboardType: widget.keyboardType,
                autovalidateMode: widget.autovalidateMode,
                maxLines: widget.isMultiSelection
                    ? null
                    : 1, // Allow multiple lines
                minLines: 1, // Start with one line
                style: widget.textStyle,
                enabled: widget.isEnabled,
                readOnly: widget.readOnly,
                onTapOutside: (event) {
                  final RenderBox? renderBox =
                      _entry != null && mainOverlayKey.currentContext != null
                      ? mainOverlayKey.currentContext!.findRenderObject()
                            as RenderBox
                      : null;
                  if (renderBox == null) return;
                  final overlayPosition = renderBox.localToGlobal(Offset.zero);
                  final overlaySize = renderBox.size;
                  bool isOverlayTap =
                      (overlayPosition.dx <= event.position.dx &&
                          event.position.dx <=
                              overlayPosition.dx + overlaySize.width) &&
                      (overlayPosition.dy <= event.position.dy &&
                          event.position.dy <=
                              overlayPosition.dy + overlaySize.height);

                  if (!isOverlayTap) {
                    _textFieldFocusNode.unfocus();
                  }
                },
                onTap: () {
                  _searchAutofocus = widget.searchAutofocus;
                  if (!_isExpanded) {
                    _isExpanded = !_isExpanded;
                    if (_dropDownList.isNotEmpty) {
                      _showOverlay();
                    }
                  } else {
                    if (widget.readOnly) hideOverlay();
                  }
                },
                validator: (value) =>
                    widget.validator != null ? widget.validator!(value) : null,
                decoration: widget.textFieldDecoration != null
                    ? widget.textFieldDecoration!.copyWith(
                        isCollapsed: false,
                        isDense: true,
                        alignLabelWithHint: true,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 10,
                        ),
                        suffixIcon: Icon(
                          widget.dropDownIconProperty?.icon ??
                              Icons.arrow_drop_down_outlined,
                          size: widget.dropDownIconProperty?.size,
                          color: widget.dropDownIconProperty?.color,
                        ),
                      )
                    : InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: _hintText,
                        hintStyle: const TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                        suffixIcon: Icon(
                          widget.dropDownIconProperty?.icon ??
                              Icons.arrow_drop_down_outlined,
                          size: widget.dropDownIconProperty?.size,
                          color: widget.dropDownIconProperty?.color,
                        ),
                      ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _showOverlay() async {
    // Reset and start animation to ensure it plays every time
    _controller.reset();
    _controller.forward();

    // Clear existing animation status listener and add it again
    _controller.removeStatusListener(_animationStatusListener);
    _controller.addStatusListener(_animationStatusListener);

    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    _offset = renderBox.localToGlobal(Offset.zero);
    double posFromTop = _offset.dy;
    double posFromBot = MediaQuery.of(context).size.height - posFromTop;

    double dropdownListHeight =
        _height +
        (widget.enableSearch ? _searchWidgetHeight : 0) +
        widget.listSpace;
    double ht = dropdownListHeight + 120;
    if (_searchAutofocus &&
        !(posFromBot < ht) &&
        posFromBot < _keyboardHeight &&
        !_isScrollPadding &&
        _isPortrait) {
      _isScrollPadding = true;
    }
    _isOutsideClickOverlay =
        _isScrollPadding ||
        (widget.readOnly &&
            dropdownListHeight >
                (posFromTop - MediaQuery.of(context).padding.top - 15) &&
            posFromBot < ht);
    final double topPaddingHeight = _isOutsideClickOverlay
        ? (dropdownListHeight -
              (posFromTop - MediaQuery.of(context).padding.top - 15))
        : 0;

    final double htPos = posFromBot < ht
        ? size.height - 100 + topPaddingHeight
        : _isScrollPadding
        ? size.height - (_keyboardHeight - posFromBot)
        : size.height;
    if (_isOutsideClickOverlay) {
      _openOutSideClickOverlay(context);
    }
    _entry = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          targetAnchor: posFromBot < ht
              ? Alignment.bottomCenter
              : Alignment.topCenter,
          followerAnchor: posFromBot < ht
              ? Alignment.bottomCenter
              : Alignment.topCenter,
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(
            0,
            posFromBot < ht
                ? htPos - widget.listSpace
                : htPos + widget.listSpace,
          ),
          child: AnimatedBuilder(
            animation: _controller.view,
            builder: (context, child) =>
                buildOverlay(context, child, uniqueKey: mainOverlayKey),
          ),
        ),
      ),
    );
    _entry2 = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          targetAnchor: Alignment.bottomCenter,
          followerAnchor: Alignment.bottomCenter,
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, htPos),
          child: AnimatedBuilder(
            animation: _controller.view,
            builder: (context, child) =>
                buildOverlay(context, child, uniqueKey: secondOverlayKey),
          ),
        ),
      ),
    );
    overlay.insert(_isScrollPadding ? _entry2! : _entry!);
  }

  _openOutSideClickOverlay(BuildContext context) {
    final overlay2 = Overlay.of(context);
    _barrierOverlay = OverlayEntry(
      builder: (context) {
        final size = MediaQuery.of(context).size;
        return GestureDetector(
          onTap: () {
            hideOverlay();
          },
          child: Container(
            width: size.width,
            height: size.height,
            color: Colors.transparent,
          ),
        );
      },
    );
    overlay2.insert(_barrierOverlay!);
  }

  void hideOverlay() {
    // Start reverse animation and clean up after animation completes
    _controller.reverse();
    _textFieldFocusNode.unfocus();
  }

  // Animation status listener to handle animation events
  void _animationStatusListener(AnimationStatus status) {
    if (status == AnimationStatus.dismissed) {
      // Clean up overlay entries after the animation completes
      if (_entry != null && _entry!.mounted) {
        _entry?.remove();
        _entry = null;
      }
      if (_entry2 != null && _entry2!.mounted) {
        _entry2?.remove();
        _entry2 = null;
      }

      if (_barrierOverlay != null && _barrierOverlay!.mounted) {
        _barrierOverlay?.remove();
        _barrierOverlay = null;
        _isOutsideClickOverlay = false;
      }
      _isScrollPadding = false;
      _isExpanded = false;
    }
  }

  void shiftOverlayEntry1to2() {
    _entry?.remove();
    _entry = null;
    if (_barrierOverlay != null && _barrierOverlay!.mounted) {
      _barrierOverlay?.remove();
      _barrierOverlay = null;
      _isOutsideClickOverlay = false;
    }
    _isScrollPadding = true;
    _showOverlay();
    _textFieldFocusNode.requestFocus();

    Future.delayed(Duration(milliseconds: _duration), () {
      _searchFocusNode.requestFocus();
    });
  }

  void shiftOverlayEntry2to1() {
    _searchAutofocus = false;
    _entry2?.remove();
    _entry2 = null;
    if (_barrierOverlay != null && _barrierOverlay!.mounted) {
      _barrierOverlay?.remove();
      _barrierOverlay = null;
      _isOutsideClickOverlay = false;
    }
    _controller.reset();
    _isScrollPadding = false;
    _showOverlay();
    _textFieldFocusNode.requestFocus();
  }

  Widget buildOverlay(context, child, {GlobalKey? uniqueKey}) {
    // final bool isRTL = currentDirection == TextDirection.rtl;
    return Directionality(
      textDirection: _currentDirection,
      child: ClipRect(
        child: Align(
          heightFactor: _heightFactor.value,
          child: Material(
            key: uniqueKey,
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(widget.dropdownRadius),
                  ),
                  boxShadow: const [
                    BoxShadow(color: Colors.grey, blurRadius: 5),
                  ],
                ),
                child: !widget.isMultiSelection
                    ? SingleSelectWidget(
                        mainController: _cnt,
                        autoSort: !widget.readOnly,
                        mainFocusNode: _textFieldFocusNode,
                        searchTextStyle: widget.searchTextStyle,
                        searchFocusNode: _searchFocusNode,
                        enableSearch: widget.enableSearch,
                        height: _height,
                        listTileHeight: _listTileHeight,
                        dropDownList: _dropDownList,
                        listTextStyle: _listTileTextStyle,
                        onChanged: (item) {
                          setState(() {
                            _cnt.text = item.name;
                            _isExpanded = !_isExpanded;
                          });
                          if (widget.singleController != null) {
                            widget.singleController!.setDropDown(item);
                          }
                          if (widget.onChanged != null) {
                            widget.onChanged!(item);
                          }
                          // Navigator.pop(context, null);

                          hideOverlay();
                        },
                        searchHeight: _searchWidgetHeight,
                        searchKeyboardType: widget.searchKeyboardType,
                        searchAutofocus: _searchAutofocus,
                        searchDecoration: widget.searchDecoration,
                        searchShowCursor: widget.searchShowCursor,
                        listPadding: _listPadding,
                        // onSearchTap: () {
                        //   double posFromBot =
                        //       MediaQuery.of(context).size.height - _offset.dy;
                        //   if (posFromBot < _keyboardHeight &&
                        //       !_isScrollPadding &&
                        //       _isPortrait) {
                        //     shiftOverlayEntry1to2();
                        //   }
                        // },
                        // onSearchSubmit: () {
                        //   if (_isScrollPadding) {
                        //     shiftOverlayEntry2to1();
                        //   }
                        // },
                        clearIconProperty: widget.clearIconProperty,
                      )
                    : MultiSelectWidget(
                        isSelectAll: widget.isSelectAll,
                        onSearchSubmit: () {},
                        onSearchTap: () {},
                        searchTextStyle: widget.searchTextStyle,
                        searchFocusNode: _searchFocusNode,
                        enableSearch: widget.enableSearch,
                        searchHeight: _searchWidgetHeight,
                        searchKeyboardType: widget.searchKeyboardType,
                        searchAutofocus: _searchAutofocus,
                        searchDecoration: widget.searchDecoration,
                        searchShowCursor: widget.searchShowCursor,
                        buttonTextStyle: widget.submitButtonTextStyle,
                        buttonText: widget.submitButtonText,
                        buttonColor: widget.submitButtonColor,
                        height: _height,
                        listTileHeight: _listTileHeight,
                        list: _multiSelectionValue,
                        dropDownList: _dropDownList,
                        listTextStyle: _listTileTextStyle,
                        listPadding: _listPadding,
                        checkBoxProperty: widget.checkBoxProperty,
                        onCheckChange: (index, value) {
                          DropDownValueModel selectedValue =
                              _dropDownList[index];
                          widget.onCheckChange?.call(
                            selectedValue,
                            value,
                            index,
                          );
                        },
                        onChanged: (val) {
                          _isExpanded = !_isExpanded;
                          _multiSelectionValue = val;
                          List<DropDownValueModel> result = widget.dropDownList
                              .where((data) => data.isSelected.value)
                              .toList();
                          List completeList = [];
                          for (int i = 0; i < result.length; i++) {
                            completeList.add(result[i].name);
                          }
                          int count = result.length;
                          _cnt.text = (count == 0
                              ? ""
                              : widget.displayCompleteItem
                              ? completeList.join(",")
                              : "$count item selected");
                          if (widget.multiController != null) {
                            widget.multiController!.setDropDown(
                              result.isNotEmpty ? result : null,
                            );
                          }
                          if (widget.onChanged != null) {
                            widget.onChanged!(result);
                          }

                          hideOverlay();

                          setState(() {});
                        },
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
