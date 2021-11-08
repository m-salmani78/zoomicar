import 'package:flutter/cupertino.dart';

abstract class IAddCarPage extends Widget {
  const IAddCarPage({Key? key}) : super(key: key);

  bool onGoNext();
}
