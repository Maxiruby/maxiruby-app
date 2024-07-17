import 'package:flutter/material.dart';

class AnasayfaCard extends StatelessWidget {
  final Color backgroundColor;
  final String title;
  final int value;
  final String valueType;
  final String imgRoute;

  const AnasayfaCard(
      {Key? key,
      required this.backgroundColor,
      required this.title,
      required this.value,
      required this.valueType,
      required this.imgRoute})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
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
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        fontWeight: FontWeight.w800, color: Colors.white),
                  ),
                  Text(
                    value.toString(),
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        color: Colors.white),
                  ),
                  Text(
                    valueType,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          right: 20,
          bottom: 20,
          child: Opacity(
            opacity: 0.4,
            child: Image.asset(
              imgRoute,
              width: 60,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}
