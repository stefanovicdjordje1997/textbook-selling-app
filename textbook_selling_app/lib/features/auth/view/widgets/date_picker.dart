import 'package:flutter/material.dart';
import 'package:textbook_selling_app/core/constants/local_keys.dart';
import 'package:textbook_selling_app/core/localization/app_localizations.dart';

class CustomDatePicker extends StatefulWidget {
  const CustomDatePicker({
    super.key,
    required this.onDateSelected,
    required this.validator,
  });

  final void Function(DateTime?) onDateSelected;
  final String? Function(String? value) validator;

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDatePicker(context),
      child: AbsorbPointer(
        child: TextFormField(
          controller: _controller,
          decoration: InputDecoration(
            labelText: AppLocalizations.getString(LocalKeys.dateOfBirthLabel),
            hintText: AppLocalizations.getString(LocalKeys.dateOfBirthHint),
          ),
          validator: widget.validator,
        ),
      ),
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null) {
      _controller.text = "${selectedDate.day.toString().padLeft(2, '0')}/"
          "${selectedDate.month.toString().padLeft(2, '0')}/"
          "${selectedDate.year}";
      widget.onDateSelected(selectedDate);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
