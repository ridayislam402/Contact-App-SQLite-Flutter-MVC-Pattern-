import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String getFormatedDate(DateTime dt, String pattern) =>
    DateFormat(pattern).format(dt);

void showMsg(BuildContext context, String msg) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

void showUpdateDialog({
  required BuildContext context,
  required String title,
  required Function(String) onSave,
}) {
  final _controller = TextEditingController();
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Update $title'),
      content: Padding(
        padding: EdgeInsets.all(8),
        child: TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: 'Enter New $title',
            filled: true,
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () {
          Navigator.pop(context);
        }, child: Text('Cancel')),
        TextButton(onPressed: () {
          if(_controller.text.isEmpty)return;
          final value = _controller.text;
          onSave(value);
          Navigator.pop(context);
        }, child: Text('Update')),
      ],
    ),
  );
}
