import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:maxiruby/services/setting.dart';
import 'package:maxiruby/widgets/button.dart';

class TimePicker extends StatefulWidget {
  final double? width;
  final String placeHolder;
  final DateTime date;
  final void Function(DateTime callbackDate) onChange;

  const TimePicker(
      {Key? key,
      this.width,
      required this.placeHolder,
      required this.date,
      required this.onChange})
      : super(key: key);

  @override
  _TimePickerState createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  DateTime icDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: GestureDetector(
        onTap: () => showBarModalBottomSheet(
          context: context,
          backgroundColor: Color.fromARGB(0, 255, 255, 255),
          builder: (context) => Container(
            height: MediaQuery.of(context).size.height * 0.35,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
              child: Column(
                children: [
                  Expanded(
                    child: CupertinoDatePicker(
                      initialDateTime: widget.date,
                      mode: CupertinoDatePickerMode.time,
                      use24hFormat: true,
                      // This is called when the user changes the time.
                      onDateTimeChanged: (DateTime newTime) {
                        setState(() {
                          icDate = newTime;
                        });
                      },
                    ),
                  ),
                  Button(
                    icon: FontAwesome5.check_circle,
                    backgroundColor: Settings.success,
                    textColor: Colors.white,
                    text: "Tamam",
                    onPress: () {
                      widget.onChange(icDate);
                      Navigator.pop(context);
                    },
                    loading: false,
                  ),
                ],
              ),
            ),
          ),
        ).whenComplete(() {
          // getir();
        }),
        child: Container(
          width: widget.width ?? MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Color.fromARGB(25, 0, 0, 0),
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(8.0),
              bottomLeft: Radius.circular(8.0),
              topRight: Radius.circular(8.0),
              topLeft: Radius.circular(8.0),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 20, 10),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Icon(
                    FontAwesome5.clock,
                    color: Settings.primary,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.placeHolder + ": ",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: Settings.primary,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      (widget.date.hour < 10 ? "0" : "") +
                          widget.date.hour.toString() +
                          ":" +
                          (widget.date.minute < 10 ? "0" : "") +
                          widget.date.minute.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
