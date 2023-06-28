import 'package:flutter/material.dart';
import 'package:dinstagram/presentation/resources/colors_manager.dart';

class GeneralTextFormField extends StatefulWidget {
  final bool hasSuffixIcon;
  final bool hasPrefixIcon;
  final TextEditingController controller;
  final String label;
  final String? Function(String?) validator;
  final TextInputType textInputType;
  final IconData iconData;
  final bool autoFocus;
  const GeneralTextFormField({
    Key? key,
    required this.hasPrefixIcon,
    required this.hasSuffixIcon,
    required this.controller,
    required this.label,
    required this.validator,
    required this.textInputType,
    required this.iconData,
    required this.autoFocus,
  }) : super(key: key);

  @override
  State<GeneralTextFormField> createState() => _GeneralTextFormFieldState();
}

class _GeneralTextFormFieldState extends State<GeneralTextFormField> {
  bool isVisible = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Colors.white,
      autofocus: widget.autoFocus,
      obscureText: widget.hasSuffixIcon ? isVisible : false,
      keyboardType: widget.textInputType,
      validator: widget.validator,
      controller: widget.controller,
      decoration: InputDecoration(
        fillColor: const Color.fromARGB(255, 33, 38, 63),
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 1.5,
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.circular(
            10,
          ),
        ),
        label: Text(
          widget.label,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        prefixIcon: widget.hasPrefixIcon
            ? Icon(
                widget.iconData,
                color: Colors.grey,
              )
            : null,
        suffixIcon: widget.hasSuffixIcon
            ? IconButton(
                onPressed: () {
                  setState(() {
                    isVisible = !isVisible;
                  });
                },
                icon: isVisible
                    ? Icon(
                        Icons.visibility,
                        color: ColorsManager.grey,
                      )
                    : Icon(
                        Icons.visibility_off,
                        color: ColorsManager.grey,
                      ),
              )
            : null,
      ),
      onSaved: (text) {
        widget.controller.text = text!;
      },
    );
  }
}
