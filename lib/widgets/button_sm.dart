import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ButtonSm extends StatefulWidget {
  final Color backgroundColor;
  final Color textColor;
  final String text;
  final IconData? icon;
  final void Function()? onPress;
  final bool loading;

  const ButtonSm(
      {Key? key,
      required this.backgroundColor,
      required this.textColor,
      required this.text,
      this.icon,
      required this.onPress,
      required this.loading})
      : super(key: key);

  @override
  _ButtonSmState createState() => _ButtonSmState();
}

class _ButtonSmState extends State<ButtonSm> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.loading == true ? null : widget.onPress,
      child: Container(
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(5.0),
            bottomLeft: Radius.circular(5.0),
            topRight: Radius.circular(5.0),
            topLeft: Radius.circular(5.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.loading == true) ...[
                SpinKitRing(
                  lineWidth: 3,
                  color: widget.textColor,
                  size: 25.0,
                ),
              ] else ...[
                if (widget.icon != null) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                    child: Icon(
                      widget.icon,
                      color: widget.textColor,
                      size: 14,
                    ),
                  ),
                ],
                Text(
                  widget.text,
                  style: TextStyle(
                    color: widget.textColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
