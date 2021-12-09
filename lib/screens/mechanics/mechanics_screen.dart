import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zoomicar/models/mechanic.dart';
import 'package:zoomicar/screens/filter_screen/filter_screen.dart';
import 'package:zoomicar/utils/services/mechanic_filter_provider.dart';
import 'package:zoomicar/utils/services/mechanics_service.dart';
import '/models/problem_model.dart';
import '/widgets/icon_badge.dart';
import 'widgets/body.dart';

class MechanicsScreen extends StatefulWidget {
  // static const routeName = '/mechanic-screen';
  final Problem problem;

  const MechanicsScreen({Key? key, required this.problem}) : super(key: key);

  @override
  _MechanicsScreenState createState() => _MechanicsScreenState();
}

class _MechanicsScreenState extends State<MechanicsScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MechanicsFilterProvider.newInstance(),
      builder: (context, child) {
        final provider = context.watch<MechanicsFilterProvider>();
        return Scaffold(
          appBar: AppBar(
            title: const Text('مکانیکی ها'),
            actions: [
              IconBadge(
                tooltip: 'فیلتر ها',
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider.value(
                      value: MechanicsFilterProvider(),
                      child: const FilterScreen(),
                    ),
                  ),
                ),
                icon: const Icon(Icons.filter_list),
                itemsNum: provider.filtersNum(),
              ),
            ],
          ),
          body: FutureBuilder(
              future: MechanicsService().getLocation(context),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildLoading();
                }
                if (snapshot.hasError) {
                  return Center(
                    child: TextButton.icon(
                        onPressed: () => setState(() {}),
                        icon: const Icon(Icons.place),
                        label: const Text('GPS را روشن کنید')),
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
                        return _buildError();
                      }
                      final list = snapshot.data as List<Mechanic>;
                      return Body(
                        mechanics: provider.getFilteredList(list),
                        customLocation: customLocation,
                      );
                    },
                  );
                }
                return _buildLoading();
              }),
        );
      },
    );
  }

  Widget _buildLoading() => const Center(child: CircularProgressIndicator());

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/no_wifi.png',
            width: MediaQuery.of(context).size.width * 0.35,
          ),
          TextButton.icon(
            onPressed: () => setState(() {}),
            label: const Text('تلاش مجدد'),
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
    );
  }
}
