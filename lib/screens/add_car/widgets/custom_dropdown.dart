import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:zoomicar/constants/app_constants.dart';

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
  final _userEditTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<String>(
      mode: Mode.DIALOG,
      selectedItem: widget.initialValue,
      popupShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cornerRadius)),
      showSearchBox: true,
      showClearButton: true,
      showSelectedItems: true,
      showAsSuffixIcons: true,
      clearButtonSplashRadius: 24,
      dropdownButtonSplashRadius: 24,
      searchFieldProps: TextFieldProps(
          controller: _userEditTextController,
          decoration: InputDecoration(
              hintText: 'جستجو',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                splashRadius: 24,
                icon: const Icon(Icons.clear, size: 20),
                onPressed: () => _userEditTextController.clear(),
              ),
              contentPadding: const EdgeInsets.all(12))),
      onFind: widget.onFind,
      errorBuilder: (context, searchEntry, exception) {
        return Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Colors.red.shade800,
            ),
            const SizedBox(width: 4),
            Text(
              'اتصال برقرار نیست!',
              style: TextStyle(color: Colors.red.shade800),
            ),
          ],
        ));
      },
      emptyBuilder: (context, searchEntry) {
        return const Center(child: Text('موردی یافت نشد'));
      },
      itemAsString: (item) => item ?? '',
      onChanged: widget.onChanged,
      dropdownSearchDecoration: InputDecoration(
        labelText: widget.hint,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        contentPadding: const EdgeInsets.all(14),
      ),
      validator: widget.validator,
    );
  }

  // Future<List<String>> onFind(String filter) async {
  //   return widget.items.where((item) => item.contains(filter)).toList();
  // }
}
