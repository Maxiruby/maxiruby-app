import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:maxiruby/services/setting.dart';

class Switchh extends StatefulWidget {
  final bool? value;
  final void Function(bool value)? checkUpdate;
  final void Function()? labelClick;
  final String label;
  const Switchh(
      {Key? key,
      this.value,
      this.checkUpdate,
      required this.label,
      this.labelClick})
      : super(key: key);

  @override
  _SwitchhState createState() => _SwitchhState();
}

class _SwitchhState extends State<Switchh> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FlutterSwitch(
                width: 50,
                height: 30,
                activeIcon: Icon(
                  FontAwesome5.check,
                  color: Settings.primary,
                ),
                value: widget.value ?? false,
                activeColor: Settings.primary,
                onToggle: (val) async {
                  widget.checkUpdate!(val);
                },
              ),
              Flexible(
                child: GestureDetector(
                  onTap: widget.labelClick,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Text(
                      widget.label,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
