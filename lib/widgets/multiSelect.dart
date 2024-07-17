import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:maxiruby/services/setting.dart';

class MultiSelect extends StatefulWidget {
  final String label;
  final List<MultiSelectItem> veriler;
  final List<dynamic> selected;
  final void Function(List<dynamic> values, int? sID, int? sIS) onConfrim;
  final int? selectedItemId;
  final int? selectedItemSort;

  const MultiSelect({
    Key? key,
    required this.label,
    required this.veriler,
    required this.selected,
    required this.onConfrim,
    this.selectedItemId,
    this.selectedItemSort,
  }) : super(key: key);

  @override
  _MultiSelectState createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  List<dynamic> _selectedd = [];

  @override
  void initState() {
    super.initState();
    for (var c in widget.selected) {
      _selectedd.add(int.parse(c));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: Color.fromARGB(25, 0, 0, 0),
          ),
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(8.0),
            bottomLeft: Radius.circular(8.0),
            topRight: Radius.circular(8.0),
            topLeft: Radius.circular(8.0),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MultiSelectDialogField(
                title: Text(
                  widget.label,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                buttonText: Text(widget.label,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Settings.primary,
                    )),
                buttonIcon: Icon(FontAwesome5.chevron_down, size: 15),
                selectedColor: Settings.primary,
                backgroundColor: Colors.white,
                itemsTextStyle: TextStyle(
                  fontSize: 14,
                ),
                selectedItemsTextStyle: TextStyle(
                  fontSize: 14,
                ),
                searchable: true,
                searchHint: "Ara",
                searchTextStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                confirmText: Text(
                  "Tamam",
                  style: TextStyle(
                      fontWeight: FontWeight.w700, color: Colors.black),
                ),
                cancelText: Text(
                  "İptal",
                  style: TextStyle(
                      fontWeight: FontWeight.w700, color: Colors.black),
                ),
                chipDisplay: MultiSelectChipDisplay(
                  chipColor: Colors.black12,
                ),
                listType: MultiSelectListType.LIST,
                items: widget.veriler,
                initialValue: _selectedd,
                onConfirm: (values) {
                  widget.onConfrim(values, widget.selectedItemId ?? null,
                      widget.selectedItemSort ?? null);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
