import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maxiruby/services/setting.dart';
import 'package:file_picker/file_picker.dart';

class FilePickerr extends StatefulWidget {
  final double? width;
  final String placeHolder;
  final XFile? file;
  final void Function(XFile callbackDate) onChange;

  const FilePickerr(
      {Key? key,
      this.width,
      required this.placeHolder,
      this.file,
      required this.onChange})
      : super(key: key);

  @override
  _FilePickerrState createState() => _FilePickerrState();
}

class _FilePickerrState extends State<FilePickerr> {
  String? adi;

  Future<void> dosyaSec() async {
    FocusScope.of(context).unfocus();
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'jpg',
        'png',
        'pdf',
      ],
    );

    if (result != null) {
      adi = result.files.single.name;
      widget.onChange(XFile(result.files.single.path!));
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: GestureDetector(
        onTap: () {
          dosyaSec();
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
                    FontAwesome5.file_upload,
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
                      widget.file == null ? "Seçiniz" : adi!,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
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
