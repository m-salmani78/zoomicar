import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zoomicar/models/mechanic.dart';

import 'mechanics_list.dart';

class Body extends StatefulWidget {
  final List<Mechanic> mechanics;
  final CustomLocation customLocation;
  const Body({Key? key, required this.mechanics, required this.customLocation})
      : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String filter = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: CupertinoSearchTextField(
            onChanged: (value) {
              setState(() => filter = value);
            },
          ),
        ),
        const Divider(height: 0),
        MechanicsList(
          mechanics: widget.mechanics
              .where((item) => item.name.contains(filter))
              .toList(),
          location: widget.customLocation,
        ),
      ],
    );
  }
}
