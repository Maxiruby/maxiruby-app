import 'package:flutter/material.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:maxiruby/pages/anasayfa.dart';
import 'package:maxiruby/services/setting.dart';
import 'package:page_transition/page_transition.dart';

class BottomBar extends StatelessWidget {
  final int index;
  final Map<String, dynamic>? user;
  final Map<String, dynamic> sistemCevirileri;
  final void Function(int returnIndex, String returnTitle) onPressed;

  const BottomBar(
      {Key? key,
      required this.index,
      required this.onPressed,
      this.user,
      required this.sistemCevirileri})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.size,
                alignment: Alignment.bottomCenter,
                child: Anasayfa(
                  index: 0,
                ),
              ),
            );
          },
          child: Container(
            color: Color.fromARGB(255, 248, 248, 248),
            width: MediaQuery.of(context).size.width / 3,
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Column(
                children: [
                  Icon(
                    Typicons.tags,
                    size: 20,
                    color: index == 0
                        ? Settings.primary
                        : Color.fromARGB(153, 47, 47, 47),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: Text(
                      sistemCevirileri['Kampanyalar'] ?? '',
                      style: TextStyle(
                        fontSize: 12,
                        color: index == 0
                            ? Settings.primary
                            : Color.fromARGB(153, 47, 47, 47),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            onPressed(1, sistemCevirileri['Markalar'] ?? '');
          },
          child: Container(
            color: Color.fromARGB(255, 248, 248, 248),
            width: MediaQuery.of(context).size.width / 3,
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Column(
                children: [
                  Icon(
                    Typicons.location,
                    size: 20,
                    color: index == 1
                        ? Settings.primary
                        : Color.fromARGB(153, 47, 47, 47),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: Text(
                      sistemCevirileri['Markalar'] ?? '',
                      style: TextStyle(
                        fontSize: 12,
                        color: index == 1
                            ? Settings.primary
                            : Color.fromARGB(153, 47, 47, 47),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            onPressed(2, sistemCevirileri['Cüzdan'] ?? '');
          },
          child: Container(
            color: Color.fromARGB(255, 248, 248, 248),
            width: MediaQuery.of(context).size.width / 3,
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Column(
                children: [
                  Icon(
                    Typicons.vcard,
                    size: 20,
                    color: index == 2
                        ? Settings.primary
                        : Color.fromARGB(153, 47, 47, 47),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: Text(
                      sistemCevirileri['Cüzdan'] ?? '',
                      style: TextStyle(
                        fontSize: 12,
                        color: index == 2
                            ? Settings.primary
                            : Color.fromARGB(153, 47, 47, 47),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
