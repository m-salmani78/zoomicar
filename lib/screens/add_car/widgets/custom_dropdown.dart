import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class ChooseCarParameter extends StatefulWidget {
  // final List<String> items;
  final DropdownSearchOnFind<String>? onFind;
  final String? hint;
  final Function(String?) onChanged;
  final FormFieldValidator<String?>? validator;
  final String? initialValue;

  const ChooseCarParameter({
    Key? key,
    required this.onFind,
    this.hint,
    required this.onChanged,
    this.validator,
    this.initialValue,
  }) : super(key: key);

  @override
  _ChooseCarParameterState createState() => _ChooseCarParameterState();
}

class _ChooseCarParameterState extends State<ChooseCarParameter> {
  @override
  Widget build(BuildContext context) {
    return DropdownSearch<String>(
      mode: Mode.MENU,
      selectedItem: widget.initialValue,
      showSearchBox: true,
      showClearButton: true,
      showSelectedItems: true,
      showAsSuffixIcons: true,
      onFind: widget.onFind,
      itemAsString: (item) => item ?? '',
      onChanged: widget.onChanged,
      dropdownSearchDecoration: InputDecoration(
        labelText: widget.hint,
        hintText: 'یک مورد را انتخاب کنید',
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      ),
      validator: widget.validator,
    );
  }

  // Future<List<String>> onFind(String filter) async {
  //   return widget.items.where((item) => item.contains(filter)).toList();
  // }
}
