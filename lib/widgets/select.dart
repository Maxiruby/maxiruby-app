import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:maxiruby/services/setting.dart';

class Select extends StatefulWidget {
  final String placeHolder;
  final String hint;
  final int backgroundType;
  final double? width;

  final String? selected;
  final void Function(String value)? selectedUpdate;
  final void Function()? onTap;
  final List<DropdownMenuItem<String>> veriler;
  final bool? disabled;

  const Select({
    Key? key,
    required this.placeHolder,
    this.width,
    required this.backgroundType,
    this.selected,
    this.selectedUpdate,
    required this.veriler,
    this.onTap,
    this.disabled,
    required this.hint,
  }) : super(key: key);

  @override
  _SelectState createState() => _SelectState();
}

class _SelectState extends State<Select> {
  EdgeInsets bosluklar = new EdgeInsets.fromLTRB(20, 15, 20, 5);
  Color iconColor = Color.fromARGB(255, 255, 255, 255);
  Color textColor = Color.fromARGB(255, 255, 255, 255);
  Color hintColor = Color.fromARGB(160, 255, 255, 255);
  final TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    var sol = 10;
    var sag = 10;

    bosluklar = EdgeInsets.fromLTRB(sol.toDouble(), 15, sag.toDouble(), 0);

    if (widget.backgroundType == 1) {
      iconColor = Settings.primary;
      textColor = Colors.black;
      hintColor = Color.fromARGB(70, 0, 0, 0);
    }

    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Container(
        width: widget.width ?? MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            width: 1,
            color: Color.fromARGB(31, 69, 69, 69),
          ),
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(8.0),
            bottomLeft: Radius.circular(8.0),
            topRight: Radius.circular(8.0),
            topLeft: Radius.circular(8.0),
          ),
        ),
        child: Stack(children: [
          Positioned(
            top: 7,
            left: 10,
            child: Text(
              widget.placeHolder + ": ",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: Settings.primary,
              ),
            ),
          ),
          Padding(
            padding: bosluklar,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.disabled == true) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Text(
                      widget.selected!,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ] else ...[
                  DropdownButton2<String>(
                    buttonStyleData: ButtonStyleData(
                        width: MediaQuery.of(context).size.width),
                    iconStyleData: const IconStyleData(
                      icon: Icon(FontAwesome5.chevron_down, size: 18),
                      iconSize: 14,
                    ),
                    //menuMaxHeight: MediaQuery.of(context).size.height / 2,
                    //borderRadius: BorderRadius.circular(20),
                    //onTap: widget.onTap,
                    isExpanded: true,
                    alignment: AlignmentDirectional.centerStart,
                    hint: Text(widget.hint),
                    value: widget.selected,
                    /*icon: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Icon(FontAwesome5.chevron_down, size: 18),
                    ),*/
                    //elevation: 16,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    underline: Container(
                      height: 0,
                    ),
                    onChanged: (String? value) {
                      widget.selectedUpdate!(value!);
                    },
                    items: widget.veriler,
                    dropdownStyleData: DropdownStyleData(
                      width: MediaQuery.of(context).size.width / 3 * 2,
                      maxHeight: MediaQuery.of(context).size.height / 2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                      scrollbarTheme: ScrollbarThemeData(
                        radius: const Radius.circular(40),
                        thickness: MaterialStateProperty.all(6),
                        thumbVisibility: MaterialStateProperty.all(true),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
