import 'package:flutter/material.dart';

typedef Validator = String? Function (String? text);

class MaterialTextFormField extends StatefulWidget {
  String hint;
  TextInputType keyboardType ;
  bool securedPassword ;
  Validator? validator = null;
  TextEditingController? controller = null;
  int lines;
  VoidCallback? onClick;
  bool editable = true;
  MaterialTextFormField({
    required this.hint,
   this.keyboardType = TextInputType.text,
    this.securedPassword = false,
    this.validator,
    this.controller,
    this.lines =1,
    this.onClick,
    this.editable = true
  });

  @override
  State<MaterialTextFormField> createState() => _MaterialTextFormFieldState();
}

class _MaterialTextFormFieldState extends State<MaterialTextFormField> {
  bool isVisibleText = true;

  @override
  void initState() {
    super.initState();
    isVisibleText = widget.securedPassword;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            onTap: (){
              widget.onClick?.call();
            },
            enableInteractiveSelection: widget.editable,
            focusNode: FocusNode(),
            validator: widget.validator,
            decoration: InputDecoration(
              errorStyle: TextStyle(
                color: Colors.red,
                fontSize: 16
              ),
              suffixIcon: widget.securedPassword? InkWell(
                onTap: (){
                  setState(() {
                    isVisibleText = !isVisibleText;
                  });
                },
                child: Icon(
                    isVisibleText ? Icons.visibility_off_outlined : Icons.visibility),
              )
              :null,
              hintStyle: Theme.of(context).textTheme
                .titleSmall?.copyWith(
                color: Colors.black
              ),
              labelText: widget.hint,
              floatingLabelBehavior: FloatingLabelBehavior.auto
            ),
            keyboardType: widget.keyboardType,
            obscureText: isVisibleText,
            controller: widget.controller,
            minLines: widget.lines,
            maxLines: widget.lines,
          ),
        ],

      ),
    );
  }
}
