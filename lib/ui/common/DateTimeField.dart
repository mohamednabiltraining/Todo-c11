import 'package:flutter/material.dart';
import 'package:todo_c11/ui/common/MaterialTextFormField.dart';

class DateTimeField extends StatelessWidget {
  String title;
  String hint;
  VoidCallback onClick;
  DateTimeField({required this.title,
  required this.hint,
  required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,style: Theme.of(context).textTheme.titleSmall
          ?.copyWith(
          color: Colors.blue
        )
          ,),
        MaterialTextFormField(hint: hint,
        editable: false,
        onClick: onClick,
        )
      ],
    );
  }
}
