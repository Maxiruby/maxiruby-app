import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Button extends StatefulWidget {
  final Color backgroundColor;
  final Color textColor;
  final String text;
  final IconData? icon;
  final void Function()? onPress;
  final bool loading;
  final double? width;
  final bool? border;

  const Button(
      {Key? key,
      required this.backgroundColor,
      required this.textColor,
      required this.text,
      this.icon,
      required this.onPress,
      required this.loading,
      this.width,
      this.border})
      : super(key: key);

  @override
  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Container(
        clipBehavior: Clip.hardEdge,
        width: widget.width ?? MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          border: Border.all(
              width: widget.border == true ? 2 : 0, color: widget.textColor),
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(10.0),
            bottomLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
            topLeft: Radius.circular(10.0),
          ),
        ),
        child: TextButton(
            onPressed: widget.loading == true ? null : widget.onPress,
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                if (states.contains(MaterialState.focused))
                  return widget.textColor.withAlpha(40);
                if (states.contains(MaterialState.hovered))
                  return widget.textColor.withAlpha(40);
                if (states.contains(MaterialState.pressed))
                  return widget.textColor.withAlpha(40);
                return null; // Defer to the widget's default.
              }),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              padding: MaterialStateProperty.all<EdgeInsets>(
                EdgeInsets.all(widget.border == true ? 10 : 14),
              ),
            ),
            child: Row(
              mainAxisAlignment: (widget.text == ''
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.spaceBetween),
              children: [
                if (widget.loading == true) ...[
                  SpinKitRing(
                    lineWidth: 3,
                    color: widget.textColor,
                    size: 25.0,
                  ),
                ] else ...[
                  if (widget.icon != '') ...[
                    Text(
                      widget.text,
                      style: TextStyle(
                        color: widget.textColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ],
                  if (widget.icon != null) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Icon(
                        widget.icon,
                        color: widget.textColor,
                        size: 18,
                      ),
                    ),
                  ],
                ]
              ],
            )),
      ),
    );
  }
}
