import 'package:flutter/material.dart';
import 'package:maxiruby/services/setting.dart';

class Input extends StatefulWidget {
  final TextEditingController controller;
  final IconData? leftIcon;
  final IconData? rightIcon;
  final String placeHolder;
  final TextInputType? keyboardType;
  final TextInputAction? keyboardAction;
  final int backgroundType;
  final double? width;
  final int? minLines;
  final int? maxLines;
  final void Function(String)? onSubmitted;
  final bool? disabled;

  const Input({
    Key? key,
    required this.controller,
    this.leftIcon,
    this.keyboardAction,
    required this.placeHolder,
    this.keyboardType,
    this.rightIcon,
    this.width,
    required this.backgroundType,
    this.onSubmitted,
    this.minLines,
    this.maxLines,
    this.disabled,
  }) : super(key: key);

  @override
  _InputState createState() => _InputState();
}

class _InputState extends State<Input> {
  bool passwordVisibility = false;
  late FocusNode myFocusNode = FocusNode();

  EdgeInsets bosluklar = new EdgeInsets.fromLTRB(20, 0, 20, 0);
  Color iconColor = Color.fromARGB(255, 255, 255, 255);
  Color textColor = Color.fromARGB(255, 255, 255, 255);
  Color hintColor = Color.fromARGB(255, 255, 255, 255);

  @override
  void initState() {
    var sol = 5;
    var sag = 5;
    if (widget.leftIcon != null) {
      sol = 5;
    }
    if (widget.rightIcon != null) {
      sag = 5;
    }
    if (widget.keyboardType == TextInputType.visiblePassword) {
      sag = 5;
    }

    bosluklar = EdgeInsets.fromLTRB(sol.toDouble(), 2, sag.toDouble(), 2);

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
            color: Color.fromARGB(31, 69, 69, 69),
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
          child: Column(children: [
            TextFormField(
              readOnly: widget.disabled == true ? true : false,
              maxLines: widget.maxLines ?? 1,
              minLines: widget.minLines ?? 1,
              onFieldSubmitted: widget.onSubmitted,
              cursorColor: Settings.primary,
              keyboardType:
                  widget.keyboardType == null ? null : widget.keyboardType,
              controller: widget.controller,
              textInputAction: widget.keyboardAction == null
                  ? TextInputAction.next
                  : widget.keyboardAction,
              autofocus: false,
              focusNode: myFocusNode,
              autofillHints: [AutofillHints.email],
              obscureText: widget.keyboardType == TextInputType.visiblePassword
                  ? !passwordVisibility
                  : false,
              decoration: InputDecoration(
                contentPadding: bosluklar,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: hintColor,
                ),
                labelText: widget.placeHolder + ":",
                suffixIcon: widget.keyboardType == TextInputType.visiblePassword
                    ? InkWell(
                        onTap: () => setState(
                          () => passwordVisibility = !passwordVisibility,
                        ),
                        focusNode: FocusNode(skipTraversal: true),
                        child: Icon(
                          passwordVisibility
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: iconColor,
                          size: 18,
                        ),
                      )
                    : widget.rightIcon != null
                        ? Icon(
                            widget.rightIcon,
                            color: iconColor,
                          )
                        : null,
                prefixIcon: widget.leftIcon != null
                    ? Icon(
                        widget.leftIcon,
                        color: iconColor,
                      )
                    : null,
                hintStyle: TextStyle(
                  color: hintColor,
                  fontWeight: FontWeight.w700,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0x00000000),
                    width: 1,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4.0),
                    topRight: Radius.circular(4.0),
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0x00000000),
                    width: 1,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4.0),
                    topRight: Radius.circular(4.0),
                  ),
                ),
                errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0x00000000),
                    width: 1,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4.0),
                    topRight: Radius.circular(4.0),
                  ),
                ),
                focusedErrorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0x00000000),
                    width: 1,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4.0),
                    topRight: Radius.circular(4.0),
                  ),
                ),
              ),
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
