import 'package:flutter/material.dart';
import 'package:maxiruby/services/setting.dart';

class LisansViewTek extends StatelessWidget {
  final int value;
  final String title;
  final bool colorChange;

  const LisansViewTek(
      {Key? key,
      required this.value,
      required this.title,
      required this.colorChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        width: MediaQuery.of(context).size.width / 4 - 30,
        decoration: BoxDecoration(
          color: colorChange == true ? Settings.success : Settings.danger,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(8.0),
            bottomLeft: Radius.circular(8.0),
            topRight: Radius.circular(8.0),
            topLeft: Radius.circular(8.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [
              Text(
                value.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 17,
                  color: Colors.white,
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
