import 'package:flutter/material.dart';

class TransmogListItem extends StatelessWidget {
  const TransmogListItem(
      {required this.showHighlight, required this.onTap, Key? key})
      : super(key: key);

  final bool showHighlight;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
