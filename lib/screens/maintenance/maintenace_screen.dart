import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '/constants/app_constants.dart';
import '/models/problem_model.dart';
import '/screens/problem/problem_screen.dart';
import '../../utils/services/account_change_handler.dart';
import '../../constants/api_keys.dart';
import '/widgets/form_error.dart';
import '/widgets/status_label.dart';
import '/models/car_model.dart';

class MaintenanceScreen extends StatefulWidget {
  final Car car;
  const MaintenanceScreen({Key? key, required this.car}) : super(key: key);

  @override
  _MaintenanceScreenState createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen> {
  final List<Problem> problems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('قطعات خودرو'),
        // title: Text('Maintenance'),
      ),
      body: FutureBuilder(
        future: http.post(Uri.parse(baseUrl + '/car/notifications'),
            headers: {authorization: AccountChangeHandler().token ?? ''},
            body: {"car_id": widget.car.carId.toString()}),
        builder: (context, snapshot) {
          // log('@ Connection State: ${snapshot.connectionState}');
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            log('@ Problem Error: ${snapshot.error}');
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const FormError(errors: ['اتصال برقرار نیست']),
                  TextButton.icon(
                      onPressed: () {
                        setState(() {});
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('تلاش مجدد'))
                ],
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            final response = snapshot.data as http.Response;
            log('@ Problems: ' + response.body);
            if (response.statusCode == 200) {
              var problems = problemsFromJson(
                utf8.decode(response.bodyBytes),
                carId: widget.car.carId,
              );
              return ListView(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                children:
                    problems.map((e) => _buildCardView(context, e)).toList(),
              );
            }
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildCardView(BuildContext context, Problem problem) {
    return Card(
      margin: const EdgeInsets.all(8),
      elevation: defaultElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cornerRadius),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProblemScreen(problem: problem),
            ),
          );
        },
        child: Column(
          children: [
            ListTile(
              leading: Hero(
                  tag: problem.hashCode,
                  child: Image.asset(
                    problem.imageAssetAddress,
                    height: 48,
                    width: 48,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Image.asset('assets/images/ic-engine-oil-filled.png'),
                  )),
              title: Text(problem.title),
              trailing: StatusLabel(problemStatus: problem.problemStatus),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                "سطح روغن ماشین شما کم است. برای از بین بردن اصطکاک و گرم شدن بیش از حد ، روغن موتور را تعویض کنید.",
                textAlign: TextAlign.justify,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
