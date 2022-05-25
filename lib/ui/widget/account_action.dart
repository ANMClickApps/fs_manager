import 'package:flutter/material.dart';

import '../../style/brand_color.dart';

class AccountAction extends StatelessWidget {
  const AccountAction({
    Key? key,
    required this.title,
    required this.onPressed,
    required this.iconData,
    this.isDelete = false,
  }) : super(key: key);

  final String title;
  final VoidCallback onPressed;
  final IconData iconData;
  final bool isDelete;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 4.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                12.0,
              ),
              color: isDelete ? BrandColor.red : Colors.white,
              boxShadow: const [
                BoxShadow(
                    offset: Offset(0, 4),
                    blurRadius: 4.0,
                    spreadRadius: 0,
                    color: Colors.black26)
              ]),
          child: IconButton(
            onPressed: onPressed,
            icon: Icon(
              iconData,
              color: isDelete ? Colors.white : Colors.black,
            ),
          ),
        ),
        const SizedBox(width: 12.0),
        Text(
          title,
          style: const TextStyle(color: BrandColor.dark),
        ),
      ],
    );
  }
}
