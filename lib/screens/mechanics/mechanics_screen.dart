import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zoomicar/models/mechanic.dart';
import 'package:zoomicar/utils/services/mechanics_service.dart';
import '/models/problem_model.dart';
import '/widgets/icon_badge.dart';
import 'widgets/mechanics_list.dart';

class MechanicsScreen extends StatefulWidget {
  // static const routeName = '/mechanic-screen';
  final Problem problem;

  const MechanicsScreen({Key? key, required this.problem}) : super(key: key);

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
      ),
      body: Column(
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
          FutureBuilder(
              future: MechanicsService().getLocation(context),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildLoading();
                }
                if (snapshot.hasError) {
                  return Expanded(
                    child: Center(
                      child: TextButton.icon(
                          onPressed: () => setState(() {}),
                          icon: const Icon(Icons.place),
                          label: const Text('GPS را روشن کنید')),
                    ),
                  );
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  final customLocation = snapshot.data as CustomLocation;
                  return FutureBuilder(
                    future:
                        MechanicsService().getServiceCenters(customLocation),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return _buildLoading();
                      }
                      if (snapshot.hasError) {
                        return _buildError('اتصال برقرار نیست');
                      }
                      final mechanics = snapshot.data as List<Mechanic>;
                      if (filter.isEmpty) {
                        return MechanicsList(
                          mechanics: mechanics
                              .where((item) =>
                                  item.tags.contains(widget.problem.tag))
                              .toList(),
                          location: customLocation,
                        );
                      } else {
                        return MechanicsList(
                          mechanics: mechanics
                              .where((item) => item.name.contains(filter))
                              .where((item) =>
                                  item.tags.contains(widget.problem.tag))
                              .toList(),
                          location: customLocation,
                        );
                      }
                    },
                  );
                }
                return _buildLoading();
              }),
        ],
      ),
    );
  }

  Widget _buildLoading() => const Expanded(
        child: Center(child: CircularProgressIndicator()),
      );

  Widget _buildError(String title) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title),
            TextButton.icon(
              onPressed: () => setState(() {}),
              label: const Text('تلاش مجدد'),
              icon: const Icon(Icons.refresh),
            )
          ],
        ),
      ),
    );
  }
}
