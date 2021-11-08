import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/constants/app_constants.dart';

class CheckBoxTextField extends StatefulWidget {
  final String title;
  final void Function(String)? onChanged;

  // ignore: use_key_in_widget_constructors
  const CheckBoxTextField({required this.title, this.onChanged});

  @override
  _CheckBoxTextFieldState createState() => _CheckBoxTextFieldState();
}

class _CheckBoxTextFieldState extends State<CheckBoxTextField> {
  TextEditingController controller = TextEditingController();
  bool _enabled = false;

  set _setIsDone(bool value) {
    if (_enabled == value) return;
    setState(() {
      _enabled = value;
      if (!value) {
        controller.clear();
        if (widget.onChanged != null) widget.onChanged!('');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                value: _enabled,
                onChanged: (flag) => _setIsDone = flag ?? false,
                visualDensity: VisualDensity.compact,
              ),
              Text(widget.title),
            ],
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            enabled: _enabled,
            controller: controller,
            onChanged: widget.onChanged,
            decoration: const InputDecoration(hintText: '0 Km'),
            validator: (value) {
              if (_enabled && controller.text.isEmpty) {
                return requiredInputError;
              }
            },
          ),
        ],
      ),
    );
  }
}
