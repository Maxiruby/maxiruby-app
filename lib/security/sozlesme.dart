import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_table/flutter_html_table.dart';
import 'package:maxiruby/services/Uyari.dart';
import 'package:maxiruby/services/functions.dart';
import 'package:maxiruby/services/setting.dart';
import 'package:maxiruby/widgets/button.dart';
import 'package:maxiruby/widgets/input.dart';
import 'package:maxiruby/widgets/maskInput.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_table/flutter_html_table.dart';
import 'package:html/parser.dart';

Uyari uyari = new Uyari();
AppFunctions function = new AppFunctions();

class Sozlesme extends StatefulWidget {
  final veri;

  const Sozlesme({
    Key? key,
    this.veri,
  }) : super(key: key);

  @override
  _SozlesmeState createState() => _SozlesmeState();
}

class _SozlesmeState extends State<Sozlesme> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          height: MediaQuery.of(context).size.height * 0.90,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: Text(
                      widget.veri['baslik'],
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 17,
                        color: Settings.primary,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 1,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(31, 174, 174, 174),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: ListView(
                    children: [
                      if (_parseHtmlString(widget.veri['metin']) != '') ...[
                        Html(
                          data: widget.veri['metin'],
                          shrinkWrap: true,
                          style: {
                            "table": Style(
                              backgroundColor: Colors.transparent,
                            ),
                            "tr": Style(
                                padding: HtmlPaddings.all(3),
                                border: Border.all(
                                    color: Color.fromARGB(255, 97, 97, 97),
                                    width: 1)),
                          },
                        ),
                      ],
                      Button(
                        width: 50,
                        backgroundColor: Settings.danger,
                        textColor: Colors.white,
                        text: '',
                        icon: FontAwesome5.times,
                        onPress: () {
                          Navigator.pop(context);
                        },
                        loading: false,
                      )
                    ],
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

String _parseHtmlString(String htmlString) {
  final document = parse(htmlString);
  final String parsedString = parse(document.body!.text).documentElement!.text;

  return parsedString;
}
