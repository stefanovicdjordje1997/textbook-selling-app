import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    super.key,
    required this.labelText,
    required this.hintText,
    this.initialText,
    required this.validator,
    required this.onSaved,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.capitalFirstLetter = false,
  });
  final String labelText;
  final String hintText;
  final String? initialText;
  final String? Function(String? value) validator;
  final void Function(String? value) onSaved;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool capitalFirstLetter;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        errorMaxLines: 2,
        suffixIcon: widget.obscureText
            ? Container(
                padding: const EdgeInsets.only(right: 10),
                child: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
              )
            : null,
      ),
      controller: TextEditingController(text: widget.initialText),
      keyboardType: widget.keyboardType,
      obscureText: _obscureText,
      textCapitalization: widget.capitalFirstLetter
          ? TextCapitalization.sentences
          : TextCapitalization.none,
      validator: widget.validator,
      onSaved: widget.onSaved,
    );
  }
}
