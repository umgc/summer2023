import 'package:flutter/material.dart';

class TransmogListItem extends StatelessWidget {
  const TransmogListItem(
      {required this.title,
      required this.icon,
      required this.showHighlight,
      required this.onTap,
      Key? key})
      : super(key: key);

  final String title;
  final IconData icon;
  final bool showHighlight;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(right: 10),
        width: 115,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
            color: showHighlight
                ? const Color(0xFFCA595D)
                : const Color(0xFF262626),
            borderRadius: const BorderRadius.all(Radius.circular(30))),
        child: TextButton(
          onPressed: onTap,
          child: Container(
            padding: const EdgeInsets.all(1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: Colors.white, size: 40),
                Text(title,
                    style: const TextStyle(color: Colors.white, fontSize: 16))
              ],
            ),
          ),
        ));
  }
}
