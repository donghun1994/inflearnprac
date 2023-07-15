import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../const/const.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final bool isTime;

  const CustomTextField({Key? key, required this.label, required this.isTime})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
              color: PRIMARY_COLOR,
              fontWeight: FontWeight.w600,
            )),
        if (isTime) renderTextField(),
        if (!isTime)
          Expanded(
            child: renderTextField(),
          ),
      ],
    );
  }

  Widget renderTextField() {
    return TextField(
      maxLines: isTime ? 1 : null,
      expands: !isTime,
      keyboardType: isTime ? TextInputType.number : TextInputType.multiline,
      inputFormatters: isTime
          ? [
              // input 박스에서 숫자만 입력하게 제한하는 것!!
              FilteringTextInputFormatter.digitsOnly,
            ]
          : [],
      cursorColor: Colors.grey,
      decoration: InputDecoration(
        border: InputBorder.none,
        filled: true,
        fillColor: Colors.grey[300],
      ),
    );
  }
}
