import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    super.key,
    required this.labelText,
    required this.hintText,
    this.defaultText,
    required this.validator,
    required this.onSaved,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.capitalFirstLetter = false,
    this.maxLines = 2,
  });
  final String labelText;
  final String hintText;
  final String? defaultText;
  final String? Function(String? value) validator;
  final void Function(String? value) onSaved;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool capitalFirstLetter;
  final int maxLines;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool _obscureText;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
    _controller = TextEditingController(text: widget.defaultText);
  }

  @override
  void didUpdateWidget(covariant CustomTextFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.defaultText != oldWidget.defaultText) {
      _controller.text = widget.defaultText ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
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
      keyboardType: widget.keyboardType,
      obscureText: _obscureText,
      textCapitalization: widget.capitalFirstLetter
          ? TextCapitalization.sentences
          : TextCapitalization.none,
      validator: widget.validator,
      onSaved: widget.onSaved,
      minLines: 1,
      maxLines: _obscureText ? 1 : widget.maxLines,
    );
  }
}
