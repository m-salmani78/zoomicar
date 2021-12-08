import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

class VerificationCodeInput extends StatefulWidget {
  final ValueChanged<String> onCompleted;
  final int length;
  final double itemSize;
  final BoxDecoration? itemDecoration;
  final bool autofocus;
  final bool forceUpperCase;
  const VerificationCodeInput(
      {Key? key,
      this.forceUpperCase = true,
      required this.onCompleted,
      this.length = 5,
      this.itemDecoration,
      this.itemSize = 45,
      this.autofocus = true})
      : assert(length > 0),
        assert(itemSize > 0),
        super(key: key);

  @override
  _VerificationCodeInputState createState() => _VerificationCodeInputState();
}

class _VerificationCodeInputState extends State<VerificationCodeInput> {
  final List<FocusNode> _listFocusNode = [];
  final List<TextEditingController> _listControllerText = [];
  final List<String> _code = [];
  int _currentIdex = 0;
  @override
  void initState() {
    if (_listFocusNode.isEmpty) {
      for (var i = 0; i < widget.length; i++) {
        _listFocusNode.add(FocusNode());
        _listControllerText.add(TextEditingController());
        _code.add(' ');
      }
    }
    super.initState();
  }

  String _getInputVerify() {
    String verifycode = '';
    for (var i = 0; i < widget.length; i++) {
      for (var index = 0; index < _listControllerText[i].text.length; index++) {
        if (_listControllerText[i].text[index] != ' ') {
          verifycode += _listControllerText[i].text[index];
        }
      }
    }
    return verifycode;
  }

  Widget _buildInputItem(int index) {
    return TextField(
      keyboardType: TextInputType.number,
      maxLines: 1,
      maxLength: 2,
      focusNode: _listFocusNode[index],
      showCursor: false,
      enableInteractiveSelection: false,
      decoration: InputDecoration(
        enabled: _currentIdex == index,
        counterText: "",
        contentPadding: EdgeInsets.all(((widget.itemSize * 2) / 10)),
        errorMaxLines: 1,
        fillColor: Colors.black,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: inputBorder(Colors.grey),
        disabledBorder: inputBorder(Colors.grey[400]!),
        focusedBorder: inputBorder(Theme.of(context).colorScheme.primary),
      ),
      onChanged: (String value) {
        if (value.length > 1 && index < widget.length ||
            index == 0 && value.isNotEmpty) {
          if (index == widget.length - 1) {
            widget.onCompleted(_getInputVerify());
            return;
          }
          if (_listControllerText[index + 1].value.text.isEmpty) {
            _listControllerText[index + 1].value =
                const TextEditingValue(text: " ");
          }
          if (value.length == 2) {
            if (value[0] != _code[index]) {
              _code[index] = value[0];
            } else if (value[1] != _code[index]) {
              _code[index] = value[1];
            }
            if (value[0] == " ") {
              _code[index] = value[1];
            }
            _listControllerText[index].text = _code[index];
          }
          _next(index);

          return;
        }
        if (value.isEmpty && index >= 0) {
          if (_listControllerText[index - 1].value.text.isEmpty) {
            _listControllerText[index - 1].value =
                const TextEditingValue(text: " ");
          }
          _prev(index);
        }
      },
      controller: _listControllerText[index],
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      autocorrect: false,
      textAlign: TextAlign.center,
      autofocus: widget.autofocus,
      style: const TextStyle(fontSize: 20, color: Colors.black),
      inputFormatters: widget.forceUpperCase ? [UpperCaseTextFormatter()] : [],
    );
  }

  void _next(int index) {
    if (index != widget.length) {
      setState(() {
        _currentIdex = index + 1;
      });
      SchedulerBinding.instance?.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(_listFocusNode[index + 1]);
      });
    }
  }

  void _prev(int index) {
    if (index > 0) {
      setState(() {
        if (_listControllerText[index].text.isEmpty) {
          _listControllerText[index - 1].text = ' ';
        }
        _currentIdex = index - 1;
      });
      SchedulerBinding.instance?.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(_listFocusNode[index - 1]);
      });
    }
  }

  List<Widget> _buildListWidget() {
    List<Widget> listWidget = [];
    for (int index = 0; index < widget.length; index++) {
      double left = (index == 0) ? 0.0 : (widget.itemSize / 10);
      listWidget.add(Container(
          height: widget.itemSize,
          width: widget.itemSize,
          margin: EdgeInsets.only(left: left),
          decoration: widget.itemDecoration,
          child: _buildInputItem(index)));
    }
    return listWidget;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _buildListWidget(),
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

inputBorder(Color color) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(width: 2.5, color: color),
    );
