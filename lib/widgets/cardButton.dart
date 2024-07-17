import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';

class CardButton extends StatelessWidget {
  final Color backgroundColor;
  final IconData icon;
  final Color iconColor;
  final String title;
  final Color titleColor;
  final void Function() onPress;

  const CardButton(
      {Key? key,
      required this.title,
      required this.icon,
      required this.backgroundColor,
      required this.iconColor,
      required this.titleColor,
      required this.onPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              width: MediaQuery.of(context).size.width / 2 - 30,
              height: 150,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(8.0),
                  bottomLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0),
                  topLeft: Radius.circular(8.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(77, 208, 208, 208),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 0), // changes position of shadow
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                      child: Icon(
                        icon,
                        color: iconColor,
                        size: 30,
                      ),
                    ),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: titleColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            right: 15,
            top: 10,
            child: Opacity(
              opacity: 0.02,
              child: Icon(
                FontAwesome5.arrow_right,
                size: 70,
              ),
            ),
          )
        ],
      ),
    );
  }
}
