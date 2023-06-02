import 'package:flutter/material.dart';

Future<void> buildErrorDialog(BuildContext context, Object error) async {
  if (!context.mounted) return;
  var ex = error as Exception?;
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          'Error',
          style: TextStyle(color: Colors.red),
        ),
        content: Text(ex != null ? ex.toString() : error.toString()),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<void> buildDialog(
    BuildContext context, String caption, String content) async {
  if (!context.mounted) return;
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(caption),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
