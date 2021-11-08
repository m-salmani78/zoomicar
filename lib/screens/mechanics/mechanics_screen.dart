import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/models/problem_model.dart';
import '/screens/mechanics/widgets/mechanics_list.dart';
import '/widgets/icon_badge.dart';

class MechanicsScreen extends StatefulWidget {
  // static const routeName = '/mechanic-screen';
  final Problem problem;

  // ignore: use_key_in_widget_constructors
  const MechanicsScreen({required this.problem});

  @override
  _MechanicsScreenState createState() => _MechanicsScreenState();
}

class _MechanicsScreenState extends State<MechanicsScreen> {
  String filter = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مکانیکی ها'),
        actions: [
          IconBadge(
            onPressed: () {},
            icon: const Icon(Icons.filter_alt),
          ),
        ],
        bottom: PreferredSize(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: CupertinoSearchTextField(
                onChanged: (value) {
                  setState(() => filter = value);
                },
              ),
            ),
            preferredSize: const Size.fromHeight(kToolbarHeight)),
      ),
      body: MechanicsList(problem: widget.problem, filter: filter),
    );
  }
}
