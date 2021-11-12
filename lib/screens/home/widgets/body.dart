import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import '/constants/app_constants.dart';
import '/main.dart';
import '/models/problem_model.dart';
import '/screens/add_car/add_car.dart';
import '/screens/maintenance/maintenace_screen.dart';
import '/models/account_model.dart';
import '/screens/notifs/notifs_screen.dart';
import '/screens/problem/widget/mark_complete.dart';
import '/screens/settings/settings_screen.dart';
import '/screens/suggested_brands/suggested_brand.dart';
import '../../../utils/services/account_change_handler.dart';
import '../../../constants/api_keys.dart';
import '/utils/services/notifications_service.dart';
import '/widgets/app_name.dart';
import '/widgets/form_error.dart';
import '/widgets/icon_badge.dart';
import '/widgets/problem_card_view.dart';

import 'explore_items.dart';
import 'home_header.dart';

class Body extends StatefulWidget {
  final Account? account;
  // ignore: use_key_in_widget_constructors
  const Body({required this.account});

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  void initState() {
    if (widget.account != null) {
      _notifInitialListeners(account: widget.account!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final account = widget.account;
    return Scaffold(
      appBar: _buildAppBar(account: account),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: size.height * 0.45),
              child: HomeHeader(account?.car),
            ),
            account == null
                ? _emptyField(
                    context,
                    text: 'افزودن خودرو',
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddCarScreen()),
                    ),
                  )
                : _buildExploreItems(context, account: account),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar({Account? account}) {
    return AppBar(
      title: const AppName(),
      leading: IconButton(
        icon: const Icon(Icons.settings),
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const SettingsScreen())),
      ),
      actions: [
        IconBadge(
          onPressed: account == null
              ? null
              : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotifsScreen(carId: account.id)),
                  );
                },
          icon: const Icon(Icons.notifications),
          itemsNum: account == null
              ? 0
              : account.problems
                  .where((element) => element.percent >= 100)
                  .length,
        )
      ],
    );
  }

  Widget _emptyField(BuildContext context,
      {required VoidCallback? onPressed, required String text}) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.35,
      child: Center(
        child: OutlinedButton(
          onPressed: onPressed,
          child: Text(text),
        ),
      ),
    );
  }

  Widget _buildExploreItems(BuildContext context, {required Account account}) {
    return account.problems.isNotEmpty
        ? ExploreItems(
            name: 'قطعات خودرو',
            onPressedViewAll: () => _onPressedViewAll(context),
            children: account.problems
                .map((e) => ProblemCardView(problem: e))
                .toList(),
          )
        : FutureBuilder(
            future: http.post(Uri.parse(baseUrl + '/car/notifications'),
                headers: {authorization: AccountChangeHandler.token ?? ''},
                body: {"car_id": account.id.toString()}),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildLoading();
              }
              if (snapshot.hasError) {
                log('@ Problem Error: ${snapshot.error}');
                return _buildError();
              }
              if (snapshot.connectionState == ConnectionState.done) {
                final response = snapshot.data as http.Response;
                log('@ Problems: ' + response.body);
                if (response.statusCode == 200) {
                  var problems = problemsFromJson(
                    utf8.decode(response.bodyBytes),
                    carId: account.id,
                  );
                  if (problems.isNotEmpty) {
                    var accountBox = Hive.box<Account>(accountBoxKey);
                    accountBox.delete(account.id);
                    accountBox.put(account.id,
                        Account(car: account.car, problems: problems));
                    for (var problem in problems) {
                      NotificationService.showNotification(
                          problem: problem, car: account.car);
                    }
                  }
                  return ExploreItems(
                    name: 'قطعات خودرو',
                    onPressedViewAll: () => _onPressedViewAll(context),
                    children: problems
                        .map((e) => ProblemCardView(problem: e))
                        .toList(),
                  );
                }
              }
              return _buildLoading();
            },
          );
  }

  void _onPressedViewAll(BuildContext context) {
    if (widget.account == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MaintenanceScreen(car: widget.account!.car)),
    );
  }

  Widget _buildError() {
    return Container(
      color: Theme.of(context).colorScheme.primary.withOpacity(0.02),
      height: 200,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FormError(errors: ['اتصال برقرار نیست']),
            TextButton.icon(
              onPressed: () {
                setState(() {});
              },
              label: const Text('تلاش مجدد'),
              icon: const Icon(Icons.refresh),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Container(
      color: Theme.of(context).colorScheme.primary.withOpacity(0.02),
      height: 200,
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  void _notifInitialListeners({required Account account}) {
    NotificationService.notifListeners(
      onData: (receivedAction) async {
        log('@ notif on data listener');
        int carId = -1;
        String tag;
        try {
          carId = int.parse(receivedAction.payload!["car_id"]!);
          tag = receivedAction.payload!["problem_tag"]!;
        } catch (e) {
          return;
        }
        log('@ carId = $carId , tag = $tag');
        log('@ buttonKeyPressed = ${receivedAction.buttonKeyPressed}');
        if (receivedAction.buttonKeyPressed == NotifButtonKey.done &&
            MyApp.navigatorKey.currentContext != null) {
          await showDialog(
            context: MyApp.navigatorKey.currentContext!,
            builder: (context) => MarkCompleteDialog(carId: carId, tag: tag),
          );
          return;
        } else if (receivedAction.buttonKeyPressed == NotifButtonKey.repeate) {
          var problem = account.findProblem(tag: tag);
          if (problem != null) {
            NotificationService.showNotification(
              problem: problem,
              car: account.car,
              notifDate: DateTime.now().add(const Duration(days: 7)),
            );
          }
          return;
        }
        if (MyApp.navigatorKey.currentContext == null) return;
        final problem = account.findProblem(tag: tag);
        Navigator.of(MyApp.navigatorKey.currentContext!).push(
          MaterialPageRoute(
            builder: (context) => problem != null
                ? SuggestedBrandsScreen(problem: problem)
                : NotifsScreen(carId: carId),
          ),
        );
      },
    );
  }
}
