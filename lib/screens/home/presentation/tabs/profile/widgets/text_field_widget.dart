import 'package:flutter/material.dart';

class TextFieldWidget extends StatefulWidget {
  final TextEditingController textEditingController;
  final String label;

  const TextFieldWidget({super.key, required this.textEditingController, required this.label});

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.textEditingController,
      validator: (val){
        if(val != null && val.isNotEmpty){
          return null;
        }
        else {
          return "You need to provide this information";
        }
      },
      decoration: InputDecoration(border: OutlineInputBorder(), labelText: widget.label),
    );
  }
}
