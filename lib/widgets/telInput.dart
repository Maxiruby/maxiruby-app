import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:maxiruby/services/setting.dart';

GetStorage box = GetStorage();

class TelInput extends StatefulWidget {
  final TextEditingController controller;
  final String searchPlaceHolder;
  final String placeHolder;
  final TextInputType? keyboardType;
  final TextInputAction? keyboardAction;
  final int backgroundType;
  final double? width;
  final void Function(PhoneNumber)? phoneNumber;
  final void Function(bool)? phoneValid;

  const TelInput({
    Key? key,
    required this.controller,
    this.keyboardAction,
    required this.placeHolder,
    this.keyboardType,
    this.width,
    required this.backgroundType,
    this.phoneNumber,
    required this.phoneValid,
    required this.searchPlaceHolder,
  }) : super(key: key);

  @override
  _TelInputState createState() => _TelInputState();
}

class _TelInputState extends State<TelInput> {
  PhoneNumber TelefonNumber =
      PhoneNumber(isoCode: Platform.localeName.split('_')[1]);

  bool valid = false;
  bool passwordVisibility = false;
  late FocusNode myFocusNode = FocusNode();

  EdgeInsets bosluklar = new EdgeInsets.fromLTRB(20, 0, 20, 0);
  Color iconColor = Color.fromARGB(255, 255, 255, 255);
  Color textColor = Color.fromARGB(255, 255, 255, 255);
  Color hintColor = Color.fromARGB(255, 255, 255, 255);

  @override
  void initState() {
    var sol = 10;
    var sag = 10;

    if (widget.keyboardType == TextInputType.visiblePassword) {
      sag = 5;
    }

    bosluklar = EdgeInsets.fromLTRB(sol.toDouble(), 3, sag.toDouble(), 3);

    if (widget.backgroundType == 1) {
      iconColor = Settings.primary;
      textColor = Colors.black;
      hintColor = Settings.primary;
    }

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    myFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Container(
        width: widget.width ?? MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom: BorderSide(
            width: 1,
            color: widget.controller.text == ''
                ? Color.fromARGB(31, 69, 69, 69)
                : (valid ? Colors.green : Colors.red),
          )),
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(8.0),
            bottomLeft: Radius.circular(8.0),
            topRight: Radius.circular(8.0),
            topLeft: Radius.circular(8.0),
          ),
        ),
        child: Padding(
          padding: bosluklar,
          child: Column(
            children: [
              InternationalPhoneNumberInput(
                onInputChanged: widget.phoneNumber,
                onInputValidated: (bool value) {
                  setState(() {
                    valid = value;
                    widget.phoneValid!(value);
                  });
                },
                selectorConfig: SelectorConfig(
                  selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                  useBottomSheetSafeArea: true,
                ),
                ignoreBlank: false,
                autoValidateMode: AutovalidateMode.disabled,
                selectorTextStyle: TextStyle(
                    color: widget.controller.text == ''
                        ? Colors.black
                        : (valid ? Colors.green : Colors.red)),
                initialValue: TelefonNumber,
                textFieldController: widget.controller,
                hintText: widget.placeHolder,
                formatInput: true,
                searchBoxDecoration: InputDecoration(
                  labelText: widget.searchPlaceHolder,
                ),
                keyboardType: TextInputType.number,
                inputBorder: InputBorder.none,
                onSaved: (PhoneNumber number) {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
