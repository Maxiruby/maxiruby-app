import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:maxiruby/services/setting.dart';
import 'package:maxiruby/widgets/button.dart';

class DatePickerr extends StatefulWidget {
  final double? width;
  final String placeHolder;
  final DateTime date;
  final void Function(DateTime callbackDate) onChange;
  final bool? disabled;

  const DatePickerr(
      {Key? key,
      this.width,
      required this.placeHolder,
      required this.date,
      required this.onChange,
      this.disabled})
      : super(key: key);

  @override
  _DatePickerrState createState() => _DatePickerrState();
}

class _DatePickerrState extends State<DatePickerr> {
  DateTime icDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: GestureDetector(
        onTap: () {
          if (widget.disabled == true) {
            return;
          } else {
            showBarModalBottomSheet(
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
                          mode: CupertinoDatePickerMode.date,
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
            });
          }
        },
        child: Container(
          width: widget.width ?? MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Color.fromARGB(23, 148, 148, 148),
            border: Border.all(
              width: 1,
              color: Color.fromARGB(31, 133, 133, 133),
            ),
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
                    FontAwesome5.calendar_day,
                    color: Settings.primary,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.placeHolder + ": ",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Settings.primary,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      DateFormat("dd.MM.yyyy").format(widget.date),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
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
